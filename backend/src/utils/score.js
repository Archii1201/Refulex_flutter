// backend/src/utils/score.js
// Score pumps based on normalized price and normalized distance.
// lower score = better

function normalize(values) {
    const min = Math.min(...values);
    const max = Math.max(...values);
    if (max === min) return values.map(() => 0.5); // all equal -> neutral
    return values.map(v => (v - min) / (max - min));
  }
  
  /**
   * pumpsInfo: [ { pump, price, distanceMeters } ]
   * weights: { wPrice, wDistance } sum to 1 ideally
   */
  function pickBestPump(pumpsInfo, weights = { wPrice: 0.5, wDistance: 0.5 }) {
    if (!pumpsInfo || pumpsInfo.length === 0) return null;
    const prices = pumpsInfo.map(p => p.price);
    const dists = pumpsInfo.map(p => p.distanceMeters);
  
    const normPrices = normalize(prices);
    const normDists = normalize(dists);
  
    let best = null;
    let bestScore = Number.POSITIVE_INFINITY;
  
    for (let i = 0; i < pumpsInfo.length; i++) {
      const score = (normPrices[i] * weights.wPrice) + (normDists[i] * weights.wDistance);
      if (score < bestScore) {
        bestScore = score;
        best = { pump: pumpsInfo[i].pump, price: pumpsInfo[i].price, distanceMeters: pumpsInfo[i].distanceMeters, score };
      }
    }
    return best;
  }
  
  module.exports = { pickBestPump };
  