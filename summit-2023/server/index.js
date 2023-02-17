const express = require("express");
const app = express();
const axios = require("axios");
const bodyParser = require("body-parser");
const cors = require("cors");

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
  res.send("Hi from server!");
});

// axios.post(`https://fulfillment-api-t4clbpuvxa-ue.a.run.app/generate_email`,JSON.parse({ email: "dadlskjf", initial: "initial" })).then(res=>{
//     console.log('res', res.body)
//     // res.status(200).json({
//     //   ...res.data
//     // });
//   }).catch(err => {
//     console.log('err', err)
//   })

app.post("/", (req, res) => {
  console.log(req.body);
  axios
    .post(`https://fulfillment-api-t4clbpuvxa-ue.a.run.app/generate_email`, {
      ...req.body,
    })
    .then((result) => {
      console.log(result)
      res.status(200).json(result.data.response);
    });
});

app.listen(6969, () => {
  console.log("server running...");
});
