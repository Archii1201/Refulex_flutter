// backend/src/utils/distance.js
const axios = require("axios");
const haversine = require("hav ersine-distance".replace(' ','')); // if package name conflict, use require('haversine-distance')
/*
  NOTE: The package name is `haversine-distance`. If Node cannot require it directly because of name transform,
  use a small fallback function below (we also provide it).
*/

const GOOGLE_KEY = process.env.GOOGLE_MAPS_API_KEY;

// helper fallback haversine (meters)
function haversineMeters(lat1, lng1, lat2, lng2) {
  const toRad = (deg) => (deg * Math.PI) / 180.0;
  const R = 6371000; // earth radius in meters
  const dLat = toRad(lat2 - lat1);
  const dLon = toRad(lng2 - lng1);
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return Math.round(R * c);
}

/**
 * Given origin (lat,lng) and an array of pumps (each must have location.coordinates [lng,lat]),
 * calls Google Distance Matrix and returns array of { pumpId, distanceMeters, durationSeconds } in the same order as pumps.
 * If Google fails or key missing, returns haversine distances instead.
 */
async function getDrivingDistances(originLat, originLng, pumps) {
  if (!pumps || pumps.length === 0) return [];

  if (!GOOGLE_KEY) {
    // fallback: haversine
    return pumps.map((p) => {
      const coords = (p.location && p.location.coordinates) || [];
      const pumpLng = coords[0];
      const pumpLat = coords[1];
      const meters = haversineMeters(originLat, originLng, pumpLat, pumpLng);
      return { pumpId: String(p._id), distanceMeters: meters, durationSeconds: Math.round((meters / 1000) / 40 * 3600) }; // rough: 40 km/h
    });
  }

  // build destinations string: lat,lng|lat,lng|...
  const dests = pumps.map((p) => {
    const coords = (p.location && p.location.coordinates) || [];
    const lng = coords[0];
    const lat = coords[1];
    return `${lat},${lng}`;
  }).join("|");

  const url = `https://maps.googleapis.com/maps/api/distancematrix/json?origins=${originLat},${originLng}&destinations=${encodeURIComponent(dests)}&key=${GOOGLE_KEY}&mode=driving&units=metric`;

  try {
    const { data } = await axios.get(url);
    if (!data || data.status !== "OK" || !data.rows || data.rows.length === 0) {
      // fallback
      return pumps.map((p) => {
        const coords = (p.location && p.location.coordinates) || [];
        const pumpLng = coords[0];
        const pumpLat = coords[1];
        const meters = haversineMeters(originLat, originLng, pumpLat, pumpLng);
        return { pumpId: String(p._id), distanceMeters: meters, durationSeconds: Math.round((meters / 1000) / 40 * 3600) };
      });
    }

    const elements = data.rows[0].elements; // one origin -> many destination elements
    return elements.map((el, idx) => {
      if (el.status === "OK") {
        return {
          pumpId: String(pumps[idx]._id),
          distanceMeters: el.distance.value,
          durationSeconds: el.duration.value
        };
      } else {
        // fallback for this element
        const coords = (pumps[idx].location && pumps[idx].location.coordinates) || [];
        const pumpLng = coords[0];
        const pumpLat = coords[1];
        const meters = haversineMeters(originLat, originLng, pumpLat, pumpLng);
        return { pumpId: String(pumps[idx]._1d), distanceMeters: meters, durationSeconds: Math.round((meters / 1000) / 40 * 3600) };
      }
    });
  } catch (err) {
    // on any error fallback to haversine
    return pumps.map((p) => {
      const coords = (p.location && p.location.coordinates) || [];
      const pumpLng = coords[0];
      const pumpLat = coords[1];
      const meters = haversineMeters(originLat, originLng, pumpLat, pumpLng);
      return { pumpId: String(p._id), distanceMeters: meters, durationSeconds: Math.round((meters / 1000) / 40 * 3600) };
    });
  }
}

module.exports = { getDrivingDistances, haversineMeters };
