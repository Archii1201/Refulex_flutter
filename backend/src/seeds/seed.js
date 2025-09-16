// backend/src/seeds/seed.js
require("dotenv").config();
const mongoose = require("mongoose");
const bcrypt = require("bcrypt");
const connectDB = require("../config/db");
const User = require("../models/User");
const Pump = require("../models/Pump");

async function seed() {
  await connectDB();

  try {
    // wipe sample data (be careful in prod!)
    await User.deleteMany({});
    await Pump.deleteMany({});

    const salt = await bcrypt.genSalt(10);
    const pumpOwnerPassword = await bcrypt.hash("pumpowner123", salt);
    const customerPassword = await bcrypt.hash("customer123", salt);

    const pumpOwner = new User({
      name: "Rajesh Fuel Supplier",
      email: "rajesh@fuelx.com",
      password: pumpOwnerPassword,
      role: "pump_owner",
      location: { lat: 23.0225, lng: 72.5714 }
    });
    await pumpOwner.save();

    const customer = new User({
      name: "Alice Customer",
      email: "alice@fuelx.com",
      password: customerPassword,
      role: "customer",
      location: { lat: 23.035, lng: 72.565 }
    });
    await customer.save();

    // create 3 sample pumps around Ahmedabad (example coordinates)
    const pumps = [
      { name: "Rajesh HP Pump - Ellisbridge", owner: pumpOwner._id, coords: [72.575, 23.026] , price: 102.5 },
      { name: "Rajesh HP Pump - Bodakdev", owner: pumpOwner._id, coords: [72.535, 23.045], price: 100.5 },
      { name: "Rajesh HP Pump - Navrangpura", owner: pumpOwner._id, coords: [72.565, 23.030], price: 101.0 },
    ];

    for (const p of pumps) {
      const pump = new Pump({
        owner: p.owner,
        name: p.name,
        fuelPricePerLitre: p.price,
        location: { type: "Point", coordinates: [p.coords[0], p.coords[1]] } // [lng, lat]
      });
      await pump.save();
    }

    console.log("Seed finished.");
    process.exit(0);
  } catch (err) {
    console.error("Seed error:", err);
    process.exit(1);
  }
}

seed();
