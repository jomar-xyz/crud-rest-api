const express = require("express");
const app = express();
const axios = require("axios");
const bodyParser = require("body-parser");
const cors = require("cors");

app.use(bodyParser.urlencoded({ extended: false }));
app.use(cors())

app.get("/", (req, res) => {
  res.send("Hi from server!");
});

axios.post(`http://gpu1.ailan:1111/generate_email`,{ email: "dadlskjf", initial: "initial" }).then(res=>{
    console.log('res', res.body)
    // res.status(200).json({
    //   ...res.data
    // });
  }).catch(err => {
    console.log('err', err)
  })

app.post("/", (req, res) => {
  axios.post(`http://gpu1.ailan:1111/generate_email`,{
    ...req.body
  }).then(res=>{
    res.status(200).json({
      ...res.data
    });
  })
});

app.listen(8080, () => {
  console.log("server running...");
});