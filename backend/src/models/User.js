const mongoose = require('mongoose');
const UserSchema = new mongoose.Schema({
  name: String,
  email: { type: String, unique: true },
  password: String,
  role: { type: String, enum: ['customer','pump_owner','admin'], default: 'customer' },
  lat: Number,
  lng: Number
}, { timestamps:true });
module.exports = mongoose.model('User', UserSchema);