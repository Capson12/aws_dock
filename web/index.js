// index.js
const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send('Hello, this is a simple Node.js app!');
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});


jad