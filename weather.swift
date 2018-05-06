import KituraNet
import Foundation
import SwiftyJSON

func httpRequestOptions(location: String) -> [ClientRequest.Options] {
    let query = "q=select item.condition from weather.forecast where woeid in (select woeid from geo.places(1) where text=\"\(location)\")&format=json"
    let escaped = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    
    let request: [ClientRequest.Options] = [
        .method("GET"),
        .schema("https://"),
        .hostname("query.yahooapis.com"),
        .path("/v1/public/yql?\(escaped!)")
    ]
    
    return request
}

func getWeatherJSON(location: String) -> JSON? {
    var json: JSON = nil
    let req = HTTP.request(httpRequestOptions(location: location)) { resp in
        if let resp = resp, resp.statusCode == HTTPStatusCode.OK {
            do {
                var data = Data()
                try resp.readAllData(into: &data)
                json = JSON(data: data)
            } catch {
                print("Error \(error)")
            }
        } else {
            print("Status error code or nil reponse received from server.")
        }
    }
    req.end()
    
    return json
}

func main(args: [String:Any]) -> [String:Any] {
    var location = "Vermont"
    if let userLocation = args["location"] as? String {
        location = userLocation
    }
    
    guard let weather = getWeatherJSON(location: location) else {
        return [ "error": "Unable to retrieve weather." ]
    }
    
    guard let report = weather["query"]["results"]["channel"]["item"]["condition"]["text"].string else {
        return [ "error": "Weather report for location not found." ]
    }
    
    guard let temp = weather["query"]["results"]["channel"]["item"]["condition"]["temp"].string else {
        return [ "error": "Current temperature for location not found." ]
    }
    
    return ["msg": "It is \(temp) degress in \(location) and \(report)."]
}
