import KituraNet
import Foundation
import SwiftyJSON

func httpRequestOptions(auth: (username: String, password: String), location: (lat: Double, lng: Double)) -> [ClientRequest.Options] {
  let request: [ClientRequest.Options] = [ 
    .method("GET"),
    .schema("https://"),
    .hostname("twcservice.mybluemix.net"),
    .path("/api/weather/v1/geocode/\(location.lat)/\(location.lng)/forecast/daily/3day.json"),
    .username(auth.username),
    .password(auth.password)
  ]

  return request
}

func forecastForLocationJson(auth: (String, String), location: (Double, Double)) -> JSON? {
  var json: JSON = nil
  let req = HTTP.request(httpRequestOptions(auth: auth, location: location)) { resp in
    if let resp = resp, resp.statusCode == HTTPStatusCode.OK {
      do {
        var data = Data()
        try resp.readAllData(into: &data)
        json = JSON(data: data)
      } catch {
        print("Error \(error)")
      }
    } else {
      print("Status error code or nil reponse received from geocoding server.")
    }
  }
  req.end()

  return json
}

func parseLocation(args: [String:Any]) -> (Double, Double)? {
  guard let lat = args["lat"] as? Double else {
    return nil
  }

  guard let lng = args["lng"] as? Double else {
    return nil
  }

  return (lat, lng)
}

func parseAuthCredentials(args: [String:Any]) -> (String, String)? {
  guard let username = args["username"] as? String else {
    return nil
  }

  guard let password = args["password"] as? String else {
    return nil
  }

  return (username, password)
}

func main(args: [String:Any]) -> [String:Any] {
  guard let location = parseLocation(args: args) else {
    return [ "error": "Missing mandatory location arguments: lat, lng" ]
  }

  guard let auth = parseAuthCredentials(args: args) else {
    return [ "error": "Missing mandatory authentication arguments: username, password" ]
  }

  guard let json = forecastForLocationJson(auth: auth, location: location) else {
    return [ "error": "Unable to lookup forecast for location." ]
  }
  
  guard let forecast = json["forecasts"][0]["narrative"].string else {
    return [ "error": "Narrative forecast missing from results." ]
  }

  return ["forecast": forecast]
}
