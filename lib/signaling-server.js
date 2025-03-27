// signaling-server.js
const express = require('express');
const http = require('http');
const { Server } = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = new Server(server);

const rooms = {};

io.on('connection', (socket) => {
  console.log('User connected:', socket.id);

  socket.on('create-room', (data) => {
    const { roomId } = data;
    rooms[roomId] = {
      host: socket.id,
      participants: []
    };
    socket.join(roomId);
    console.log(`Room created: ${roomId} by ${socket.id}`);
  });

  socket.on('join-room', (data) => {
    const { roomId, userId } = data;
    console.log(`User ${socket.id} joining room ${roomId}`);
    socket.join(roomId);

    socket.to(roomId).emit('user-joined', { userId: socket.id });
  });

  socket.on('offer', (data) => {
    const { roomId, sdp, type, userId } = data;
    console.log(`Offer received from ${userId} for room ${roomId}`);
    socket.to(roomId).emit('offer', { sdp, type, userId, roomId });
  });

  socket.on('answer', (data) => {
    const { roomId, sdp, type, userId } = data;
    console.log(`Answer received from ${userId} for room ${roomId}`);
    socket.to(roomId).emit('answer', { sdp, type, userId, roomId });
  });

  socket.on('ice-candidate', (data) => {
    const { roomId, candidate, userId } = data;
    console.log(`ICE candidate from ${userId} for room ${roomId}`);
    socket.to(roomId).emit('ice-candidate', { candidate, userId, roomId });
  });

  socket.on('disconnect', () => {
    console.log('User disconnected:', socket.id);

    for (const roomId in rooms) {
      if (rooms[roomId].host === socket.id) {
        io.to(roomId).emit('host-left');
        delete rooms[roomId];
      } else {
        const index = rooms[roomId].participants.indexOf(socket.id);
        if (index !== -1) {
          rooms[roomId].participants.splice(index, 1);
        }
      }
    }
  });
});

const PORT = process.env.PORT || 3000;

server.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});
