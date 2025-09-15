const Pump = require("../models/Pump.js");


// Create pump (only pump owners)
exports.createPump = async (req, res) => {
  try {
    const { name, fuelPricePerLitre, lat, lng } = req.body;


    const pump = new Pump({
      owner: req.user.id,
      name,
      fuelPricePerLitre,
      location: {
        type: "Point",
        coordinates: [lng, lat],
      },
    });


    await pump.save();
    res.status(201).json({ message: "Pump created successfully", pump });
  } catch (error) {
    res
      .status(500)
      .json({ message: "Error creating pump", error: error.message });
  }
};


// Get nearby pumps
exports.getNearbyPumps = async (req, res) => {
  try {
    const { lat, lng, radius } = req.query;


    if (!lat || !lng) {
      return res.status(400).json({ message: "lat and lng are required" });
    }


    const pumps = await Pump.find({
      location: {
        $near: {
          $geometry: { type: "Point", coordinates: [parseFloat(lng), parseFloat(lat)] },
          $maxDistance: parseInt(radius) || 25000, // default 25 km
        },
      },
    });


    res.json(pumps);
  } catch (error) {
    res
      .status(500)
      .json({ message: "Error fetching nearby pumps", error: error.message });
  }
};


// Update pump
// A more efficient way to write the updatePump controller
exports.updatePump = async (req, res) => {
  try {
    // First, check if the pump exists and if the user is authorized
    const pumpToAuth = await Pump.findById(req.params.id);
    if (!pumpToAuth) {
      return res.status(404).json({ message: "Pump not found" });
    }
    if (pumpToAuth.owner.toString() !== req.user.id && req.user.role !== "admin") {
      return res.status(403).json({ message: "Unauthorized" });
    }

    // Prepare the update object
    const { name, fuelPricePerLitre, lat, lng } = req.body;
    const updateData = {};
    if (name) updateData.name = name;
    if (fuelPricePerLitre) updateData.fuelPricePerLitre = fuelPricePerLitre;
    if (lat && lng) {
      updateData.location = { type: "Point", coordinates: [lng, lat] };
    }

    // Perform the update
    const updatedPump = await Pump.findByIdAndUpdate(
      req.params.id,
      { $set: updateData },
      { new: true, runValidators: true } // {new: true} returns the updated document
    );
    
    res.json({ message: "Pump updated", pump: updatedPump });
  } catch (error) {
    res.status(500).json({ message: "Error updating pump", error: error.message });
  }
};

// Get pump details
exports.getPumpById = async (req, res) => {
  try {
    const pump = await Pump.findById(req.params.id).populate(
      "owner",
      "name email"
    );
    if (!pump) return res.status(404).json({ message: "Pump not found" });
    res.json(pump);
  } catch (error) {
    res
      .status(500)
      .json({ message: "Error fetching pump", error: error.message });
  }
}