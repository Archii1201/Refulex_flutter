const express = require("express");
const router = express.Router();
const orderController = require("../controllers/orderController");
const auth = require("../middlewares/auth");

// POST /api/orders — create order
router.post("/", auth(["customer"]), orderController.createOrder);

// PUT /api/orders/:id/status — update status
router.put("/:id/status", auth(["pump_owner", "admin"]), orderController.updateOrderStatus);

module.exports = router;