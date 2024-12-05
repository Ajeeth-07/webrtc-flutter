const express = require("express");
const app = express();
const mongoose = require("mongoose");
const http = require("http");
const server = http.createServer(app);
const { initMeetingServer } = require("./meeting-server");
const dotenv = require("dotenv");
const cors = require("cors");
app.use(cors());

dotenv.config();

//meeting-server
initMeetingServer(server);

// mongoose.Promise = global.Promise;
// mongoose.connect(MONGO_DB_CONFIG.DB).then(() => {
//     console.log("Database connected successfully");
// }).catch(err => {
//     console.log("Database could not be connected", err);
//     process.exit();
// });

const MONGO_DB = process.env.MONGO_DB;

mongoose
  .connect(MONGO_DB)
  .then(() => {
    console.log("Database connected successfully");
  })
  .catch((err) => {
    console.log("Database could not be connected", err);
    process.exit();
  });

app.use(express.json());
app.use("/api", require("./routes/app.routes"));

server.listen(process.env.PORT || 4000, () => {
  console.log(
    `Server is running on port http://localhost:${process.env.PORT || 4000}`
  );
});
