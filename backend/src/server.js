require('dotenv').config();
const express = require('express');
const http = require('http');
const socketio = require('socket.io');
const connectDB = require('./config/db');

const app = express();
const server = http.createServer(app);
const io = socketio(server, { cors: { origin: '*' }});

connectDB();

app.use(express.json());
app.use(require('cors')());
app.use(require('morgan')('dev'));

// import routes
app.use('/api/auth', require('./routes/authRoutes'));
app.use('/api/pumps', require('./routes/pumpRoutes'));
app.use('/api/orders', require('./routes/orderRoutes'));

// Socket.IO basic rooms/logic
io.on('connection', socket => {
  console.log('socket connected', socket.id);
  socket.on('joinRoom', ({room}) => socket.join(room));
  // emit to a room: io.to(room).emit('orderCreated', order)
});

const PORT = process.env.PORT || 5000;
server.listen(PORT, () => console.log(`Server running on ${PORT})`));
module.exports = io; // allow other modules to import io