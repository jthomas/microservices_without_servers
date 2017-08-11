import KituraNet
import Foundation
import SwiftyJSON

func httpRequestOptions(address: String) -> [ClientRequest.Options] {
  let request: [ClientRequest.Options] = [ 
    .method("GET"),
    .schema("https://"),
    .hostname("maps.googleapis.com"),
    .path("/maps/api/geocode/json?address=\(address)")
  ]

  return request
}

func addressToLocationJson (address: String) -> JSON? {
  var json: JSON = nil
  let req = HTTP.request(httpRequestOptions(address: address)) { resp in
    if let resp = resp, resp.statusCode == HTTPStatusCode.OK {
      do {
        var data = Data()
        try resp.readAllData(into: &data)
        json = JSON(data: data)
      } catch {
        print("Error \(error)")
      }
    } else {
      print(resp!.statusCode)
      print("Status error code or nil reponse received from geocoding server.")
    }
  }
  req.end()

  return json
}

func main(args: [String:Any]) -> [String:Any] {
  guard let address = args["address"] as? String else {
    return [ "error": "Missing mandatory argument: address" ]
  }

  guard let json = addressToLocationJson(address: address) else {
    return [ "error": "Unable to lookup location for address." ]
  }
  
  guard let location = json["results"][0]["geometry"]["location"].dictionaryObject else {
    return [ "error": "Location missing from results." ]
  }

  return location
}
