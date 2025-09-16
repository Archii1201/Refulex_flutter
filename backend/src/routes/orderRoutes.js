const express = require("express");
const router = express.Router();
const auth = require("../middlewares/auth");
const orderController = require("../controllers/orderController");

// create order (customer) — auth required
router.post("/", auth(["customer","pumpOwner","admin"]), orderController.createOrder);

// update status (pump owner or admin) — auth required
router.put("/:id/status", auth(["pumpOwner","admin"]), orderController.updateOrderStatus);

module.exports = router;
