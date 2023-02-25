const express = require("express");
const app = express();
const axios = require("axios");
const bodyParser = require("body-parser");
const cors = require("cors");
const db = require('./queries')

app.use(express.json({ limit: "500mb", extended: true }));
app.use(express.urlencoded({ limit: "500mb", extended: true }));
app.use(cors());
app.use(bodyParser.json({ limit: "500mb", extended: true }));
app.use(
  bodyParser.urlencoded({
    limit: "500mb",
    extended: true,
    parameterLimit: 50000,
  })
);

app.get("/", (req, res) => {
  res.json({ info: 'Node.js, Express, and Postgres API' })
});

app.get("/users", db.getUsers)
app.get('/users/:id', db.getUserById)
app.post('/users', db.createUser)
app.put('/users/:id', db.updateUser)
app.delete('/users/:id', db.deleteUser)

const port = 6060

app.listen(port, () => {
  console.log(`server running on port ${port}...`);
});
