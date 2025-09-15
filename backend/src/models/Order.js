const mongoose = require("mongoose");

const orderSchema = new mongoose.Schema({
customer: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
pump: { type: mongoose.Schema.Types.ObjectId, ref: "Pump", required: true },
litres: { type: Number, required: true },
fuelCost: Number,
deliveryDistanceKm: Number,
deliveryCharge: Number,
totalAmount: Number,
customerLocation: {
lat: Number,
lng: Number
},
status: {
type: String,
enum: ["pending", "accepted", "rejected", "delivering", "delivered"],
default: "pending"
}
}, { timestamps: true });

module.exports = mongoose.model("Order", orderSchema);