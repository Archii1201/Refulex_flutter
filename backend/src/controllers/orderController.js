const Order = require("../models/Order");
const Pump = require("../models/Pump");
const { getDistanceInKm } = require("../utils/distance");
const { RATE_PER_KM } = require("../config/constants");

let io; 
exports.setSocketIO = (serverIO) => { io = serverIO };

// ------------------ Create New Order ------------------
exports.createOrder = async (req, res) => {
  try {
    const { pumpId, litres, customerLat, customerLng } = req.body;

    const pump = await Pump.findById(pumpId).populate("owner");
    if (!pump) return res.status(404).json({ message: "Pump not found" });

    const litresNum = Number(litres);
    const latNum = Number(customerLat);
    const lngNum = Number(customerLng);
    const pricePerLitre = Number(pump.fuelPricePerLitre);

    if ([litresNum, latNum, lngNum, pricePerLitre].some(v => isNaN(v))) {
      return res.status(400).json({ message: "Invalid input: litres/lat/lng/fuelPricePerLitre must be numbers" });
    }

    const fuelCost = litresNum * pricePerLitre;

    const distanceKm = await getDistanceInKm(
      latNum,
      lngNum,
      pump.location.coordinates[1],
      pump.location.coordinates[0]
    );
    if (isNaN(distanceKm)) return res.status(400).json({ message: "Invalid distance calculation" });

    const deliveryCharge = distanceKm * RATE_PER_KM;
    const totalAmount = fuelCost + deliveryCharge;

    const order = new Order({
      customer: req.user.id,
      pump: pump._id,
      litres: litresNum,
      fuelCost,
      deliveryDistanceKm: distanceKm,
      deliveryCharge,
      totalAmount,
      customerLocation: { lat: latNum, lng: lngNum }
    });

    await order.save();

    if (io) {
      io.to(pump.owner._id.toString()).emit("orderCreated", order);
    }

    res.status(201).json({ message: "Order placed", order });
  } catch (error) {
    res.status(500).json({ message: "Error placing order", error: error.message });
  }
};

// ------------------ Update Order Status ------------------
exports.updateOrderStatus = async (req, res) => {
  try {
    const order = await Order.findById(req.params.id).populate("customer");
    if (!order) return res.status(404).json({ message: "Order not found" });

    const { status } = req.body;
    if (req.user.role !== "pump_owner" && req.user.role !== "admin") {
      return res.status(403).json({ message: "Unauthorized" });
    }

    const allowedStatus = ["pending", "accepted", "rejected", "delivering", "delivered"];
    if (!allowedStatus.includes(status)) {
      return res.status(400).json({ message: "Invalid status value" });
    }

    order.status = status;
    await order.save();

    if (io) {
      io.to(order.customer._id.toString()).emit("orderStatusUpdated", {
        orderId: order._id,
        status
      });
    }

    res.json({ message: "Order status updated", order });
  } catch (error) {
    res.status(500).json({ message: "Error updating order", error: error.message });
  }
};

// ------------------ Get Orders for Customer ------------------
exports.getMyOrders = async (req, res) => {
  try {
    const orders = await Order.find({ customer: req.user.id })
      .populate("pump", "name fuelPricePerLitre")
      .sort({ createdAt: -1 });

    res.json(orders);
  } catch (error) {
    res.status(500).json({ message: "Error fetching orders", error: error.message });
  }
};

// ------------------ Get Orders for Pump Owner ------------------
exports.getPumpOrders = async (req, res) => {
  try {
    if (req.user.role !== "pump_owner" && req.user.role !== "admin") {
      return res.status(403).json({ message: "Unauthorized" });
    }

    const pumps = await Pump.find({ owner: req.user.id });
    const pumpIds = pumps.map(p => p._id);

    const orders = await Order.find({ pump: { $in: pumpIds } })
      .populate("customer", "name email")
      .sort({ createdAt: -1 });

    res.json(orders);
  } catch (error) {
    res.status(500).json({ message: "Error fetching pump orders", error: error.message });
  }
};
