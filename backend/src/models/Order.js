const mongoose = require('mongoose');
const OrderSchema = new mongoose.Schema({
  customer: { type: mongoose.Schema.Types.ObjectId, ref:'User' },
  pump: { type: mongoose.Schema.Types.ObjectId, ref:'Pump' },
  litres: Number,
  total_amount: Number,
  delivery_charge: Number,
  status: { type: String, enum:['pending','accepted','in_transit','delivered','cancelled'], default:'pending' },
  createdAt: { type: Date, default: Date.now }
});
module.exports = mongoose.model('Order', OrderSchema);