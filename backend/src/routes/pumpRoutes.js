const express = require("express");
const router = express.Router();
const pumpController = require("../controllers/pumpController");
const auth = require("../middlewares/auth");

// Create pump (pump owner only)
router.post("/", auth(["pump_owner", "admin"]), pumpController.createPump);

// Get nearby pumps (specific route, should come first)
router.get("/nearby", pumpController.getNearbyPumps);

// Test route (specific route, should come before /:id)
router.get("/test", (req, res) => {
  res.json({ message: "Pump routes working fine!" });
});

// Get pump details by ID (general route, should come last)
router.get("/:id", pumpController.getPumpById);

// Update pump (owner or admin)
router.put("/:id", auth(["pump_owner", "admin"]), pumpController.updatePump);

module.exports = router;