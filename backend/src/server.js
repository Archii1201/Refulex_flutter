require("dotenv").config();

const express = require("express");
const http = require("http");
const socketio = require("socket.io");
const connectDB = require("./config/db");
const { setSocketIO } = require("./controllers/orderController");

const app = express();
const server = http.createServer(app);
const io = socketio(server, { cors: { origin: "*" }});

connectDB();

app.use(express.json());
app.use(require("cors")());
app.use(require("morgan")("dev"));

// routes
app.use("/api/auth", require("./routes/authRoutes"));
app.use("/api/users", require("./routes/userRoutes"));
app.use("/api/pumps", require("./routes/pumpRoutes"));
app.use("/api/orders", require("./routes/orderRoutes"));

// setup socket
io.on("connection", (socket) => {
  console.log("socket connected", socket.id);
  socket.on("joinRoom", ({ room }) => socket.join(room));
});

setSocketIO(io); // 🔥 inject io into orderController

const PORT = process.env.PORT || 5001;
server.listen(PORT, () => console.log(`Server running on ${PORT}`));
