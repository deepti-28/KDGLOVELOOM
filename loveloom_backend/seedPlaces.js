require('dotenv').config();
const mongoose = require('mongoose');
const Place = require('./models/Place');

(async () => {
  await mongoose.connect(process.env.MONGO_URI);
  const place = await Place.create({
    name: 'Test Place',
    address: 'Delhi',
    location: 'Delhi',
  });
  console.log('Created place with id:', place._id.toString());
  await mongoose.disconnect();
})();