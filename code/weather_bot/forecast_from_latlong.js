var request = require('request');

function main(params) {
  if (!params.lat) return Promise.reject("Missing latitude");
  if (!params.lng) return Promise.reject("Missing longitude");
  if (!params.username || !params.password) return Promise.reject("Missing credentials");

  var url = "https://twcservice.mybluemix.net/api/weather/v1/geocode/"+params.lat+"/"+params.lng+"/forecast/daily/3day.json";
  var options = {
    url: url,
    json: true,
    auth: {
      user: params.username,
      password: params.password
    }
  };

  return new Promise(function (resolve, reject) {
    request(options, function (err, resp) {
      if (err) {
        return reject({err: err})
      } 

      resolve({text: resp.body.forecasts[0].narrative});
    });
  });
}
