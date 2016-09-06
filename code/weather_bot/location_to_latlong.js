var request = require('request');

function main(params) {
  var options = {
    url: "https://maps.googleapis.com/maps/api/geocode/json",
    qs: {address: params.address},
    json: true
  };

  return new Promise(function (resolve, reject) {
    request(options, function (err, resp) {
      if (err) {
      	console.log(err);
        return reject({err: err})
      } 
      if (resp.body.status !== "OK") {
      	console.log(resp.body.status);
        return reject({err: resp.body.status})
      }

      resolve(resp.body.results[0].geometry.location);
    });
  });
};
