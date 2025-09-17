const express = require("express");
const router = express.Router();
const { getUser, updateUser } = require("../controllers/userController");

// Get user by ID
router.get("/:id", getUser);

// Update user by ID
router.put("/:id", updateUser);

module.exports = router;