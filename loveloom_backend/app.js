const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const multer = require('multer');
require('dotenv').config();

const WebSocket = require('ws');      // Add WebSocket package
const http = require('http');         // Add http module to create server

const authRoutes = require('./routes/auth');
const userRoutes = require('./routes/user');
const galleryRoutes = require('./routes/gallery');

const app = express();

// Middleware to parse JSON requests
app.use(express.json());

// Enable CORS to allow frontend access
app.use(cors());

// Configure multer for general file uploads in uploads directory
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/'); // Root uploads folder
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, uniqueSuffix + '-' + file.originalname);
  }
});
const upload = multer({ storage: storage });

// Serve uploaded files statically from /uploads endpoint
app.use('/uploads', express.static('uploads'));

// Connect to MongoDB
mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.error('MongoDB connection error:', err));

// Use modular route handlers
app.use('/api/auth', authRoutes);

// Note: If specific routes require multer middleware, apply inside those route files
app.use('/api/user', userRoutes);

app.use('/api/gallery', galleryRoutes);

// Test root route
app.get('/', (req, res) => {
  res.send('LoveLoom API is running');
});

// Create HTTP server wrapping express app
const server = http.createServer(app);

// Start HTTP + WebSocket server on same port (5000 or from env)
const PORT = process.env.PORT || 5000;
server.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));

// WebSocket server setup
const wss = new WebSocket.Server({ server });

// In-memory place data for demo purposes (replace with DB later)
const places = {
  // Example structure:
  // "some_place_id": { likesCount: 0, likedUsers: new Set(), notes: [] },
};

function broadcast(data) {
  const message = JSON.stringify(data);
  wss.clients.forEach(client => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(message);
    }
  });
}

wss.on('connection', (ws) => {
  console.log('WebSocket client connected');

  ws.on('message', (message) => {
    console.log('Received WS message:', message);
    try {
      const data = JSON.parse(message);

      if (data.type === 'toggle_like' && typeof data.placeId === 'string' && typeof data.userId === 'string') {
        const place = places[data.placeId] || (places[data.placeId] = { likesCount: 0, likedUsers: new Set(), notes: [] });

        if (place.likedUsers.has(data.userId)) {
          place.likedUsers.delete(data.userId);
          place.likesCount = Math.max(place.likesCount - 1, 0);
        } else {
          place.likedUsers.add(data.userId);
          place.likesCount += 1;
        }

        broadcast({
          type: 'like_update',
          placeId: data.placeId,
          likesCount: place.likesCount,
          isLikedByUser: place.likedUsers.has(data.userId),
        });
      }

      else if (data.type === 'add_note' && typeof data.placeId === 'string' && data.note) {
        const place = places[data.placeId] || (places[data.placeId] = { likesCount: 0, likedUsers: new Set(), notes: [] });
        place.notes.unshift(data.note);

        broadcast({
          type: 'new_note',
          placeId: data.placeId,
          note: data.note,
        });
      }
    } catch (err) {
      console.error('Failed to parse WS message:', err);
    }
  });

  ws.on('close', () => {
    console.log('WebSocket client disconnected');
  });
});

module.exports = { upload };
