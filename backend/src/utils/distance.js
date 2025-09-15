const axios = require("axios");
const haversine = require("./haversine");

const GOOGLE_API_KEY = process.env.GOOGLE_MAPS_API_KEY;

exports.getDistanceInKm = async (lat1, lng1, lat2, lng2) => {
try {
const url = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=${lat1},${lng1}&destinations=${lat2},${lng2}&key=${GOOGLE_API_KEY}";
const res = await axios.get(url);
const value = res.data.rows?.[0]?.elements?.[0]?.distance?.value;

if (value) {
  return value / 1000; // meters → km
}

// fallback
return haversine(lat1, lng1, lat2, lng2);
} catch (e) {
return haversine(lat1, lng1, lat2, lng2);
}
};