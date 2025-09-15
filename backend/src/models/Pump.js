const mongoose = require('mongoose');
const PumpSchema = new mongoose.Schema({
  owner: { type: mongoose.Schema.Types.ObjectId, ref:'User' },
  name: String,
  location: { type: { type: String, default:'Point' }, coordinates: [Number] }, // [lng, lat]
  fuel_price_per_litre: Number,
  createdAt: { type: Date, default: Date.now }
});
PumpSchema.index({ location: '2dsphere' });
module.exports = mongoose.model('Pump', PumpSchema);