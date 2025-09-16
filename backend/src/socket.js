// backend/src/socket.js
let io = null;

module.exports = {
  init: (server) => {
    const { Server } = require("socket.io");
    io = new Server(server, {
      cors: { origin: "*" } // tighten in production
    });

    io.on("connection", (socket) => {
      console.log("Socket connected:", socket.id);

      socket.on("joinRoom", ({ room }) => {
        if (room) {
          socket.join(room);
          console.log(`Socket ${socket.id} joined room ${room}`);
        }
      });

      socket.on("disconnect", () => {
        console.log("Socket disconnected:", socket.id);
      });
    });

    return io;
  },

  getIO: () => {
    if (!io) throw new Error("Socket.io not initialized. Call init(server) first.");
    return io;
  }
};
