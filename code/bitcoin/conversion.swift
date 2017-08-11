import KituraNet
import Foundation
import SwiftyJSON

extension Double
{
    func truncate(places : Int)-> Double
    {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}
 
func httpRequestOptions() -> [ClientRequest.Options] {
  let request: [ClientRequest.Options] = [ 
    .method("GET"),
    .schema("https://"),
    .hostname("api.coindesk.com"),
    .path("/v1/bpi/currentprice.json")
  ]

  return request
}

func currentBitcoinPricesJson() -> JSON? {
  var json: JSON = nil
  let req = HTTP.request(httpRequestOptions()) { resp in
    if let resp = resp, resp.statusCode == HTTPStatusCode.OK {
      do {
        var data = Data()
        try resp.readAllData(into: &data)
        json = JSON(data: data)
      } catch {
        print("Error \(error)")
      }
    } else {
      print("Status error code or nil reponse received from App ID server.")
    }
  }
  req.end()

  return json
}

func main(args: [String:Any]) -> [String:Any] {
  guard let currency = args["currency"] as? String else {
    return [ "error": "Missing mandatory argument: currency" ]
  }

  guard let amount = args["amount"] as? Int else {
    return [ "error": "Missing mandatory argument: amount" ]
  }

  guard let prices = currentBitcoinPricesJson() else {
    return [ "error": "Unable to retrieve Bitcoin prices" ]
  }
  
  guard let rate = prices["bpi"][currency]["rate_float"].double else {
    return [ "error": "Currency not listed in Bitcoin prices" ]
  }

  let converted = Double(amount) / rate
  let bitcoins = converted.truncate(places: 6)
  return ["amount": bitcoins, "label": "\(amount) \(currency) is worth \(bitcoins) bitcoins."]
}
