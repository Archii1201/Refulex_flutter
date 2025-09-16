// backend/src/utils/dijkstra.js
// Graph is adjacency list: { nodeId: [ { to: nodeId2, weight: number }, ... ], ... }

class MinHeap {
    constructor() { this.heap = []; }
    push(item) { this.heap.push(item); this._siftUp(); }
    pop() { if (this.heap.length === 0) return null; const top = this.heap[0]; const end = this.heap.pop(); if (this.heap.length) { this.heap[0] = end; this._siftDown(); } return top; }
    _siftUp() {
      let i = this.heap.length - 1;
      while (i > 0) {
        const p = Math.floor((i - 1) / 2);
        if (this.heap[i][0] >= this.heap[p][0]) break;
        [this.heap[i], this.heap[p]] = [this.heap[p], this.heap[i]];
        i = p;
      }
    }
    _siftDown() {
      let i = 0;
      const n = this.heap.length;
      while (true) {
        let left = 2 * i + 1;
        let right = 2 * i + 2;
        let smallest = i;
        if (left < n && this.heap[left][0] < this.heap[smallest][0]) smallest = left;
        if (right < n && this.heap[right][0] < this.heap[smallest][0]) smallest = right;
        if (smallest === i) break;
        [this.heap[i], this.heap[smallest]] = [this.heap[smallest], this.heap[i]];
        i = smallest;
      }
    }
  }
  
  function dijkstra(graph, source) {
    const dist = {};
    const prev = {};
    Object.keys(graph).forEach(k => { dist[k] = Infinity; prev[k] = null; });
    if (!(source in graph)) return { dist, prev };
  
    dist[source] = 0;
    const heap = new MinHeap();
    heap.push([0, source]);
  
    while (true) {
      const top = heap.pop();
      if (!top) break;
      const [d, node] = top;
      if (d > dist[node]) continue;
  
      const neighbors = graph[node] || [];
      for (const edge of neighbors) {
        const alt = d + edge.weight;
        if (alt < (dist[edge.to] ?? Infinity)) {
          dist[edge.to] = alt;
          prev[edge.to] = node;
          heap.push([alt, edge.to]);
        }
      }
    }
    return { dist, prev };
  }
  
  module.exports = { dijkstra };
  