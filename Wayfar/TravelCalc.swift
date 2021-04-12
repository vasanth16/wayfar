//
//  TravelCalc.swift
//  Wayfar
//
//  Created by Vasanth Rajasekaran on 2/27/21.
//  Copyright © 2021 Vasanth. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit
import CDYelpFusionKit


class TravelCalc{
    
    let locationManager = CLLocationManager() // location manager to manage user's location
    
    func getLatitude() -> Double {
      let coordinate = locationManager.location?.coordinate ?? CLLocationCoordinate2D()
      return coordinate.latitude
    }
    
    func getLongitude() -> Double {
      let coordinate = locationManager.location?.coordinate ?? CLLocationCoordinate2D()
      return coordinate.longitude
    }
    //var optimalRoute : String = ""
    var optimalRoute : Dictionary <String,Any> = [:]
    var optimalList : [CDYelpBusiness] = []
    
    func getRoute(coords:[String:[Double]]) {
        //reference: https://stackoverflow.com/questions/24321165/make-rest-api-call-in-swift
        //let coords = coords as Dictionary<String, [Double]>
        //var jsonn : [String: AnyObject]
        let username = "vvvv1100"
        let password = "89M4t48BjG8fJPah"
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        var params : [[String:String]] = []
        for (key,value) in coords{
            let insert = ["address":key,"lat": String(value[0]), "lng": String(value[1])]
            params.append(insert)
        }
        var request = URLRequest(url: URL(string: "https://api.routexl.com/tour/")!)
        request.httpMethod = "POST"
        var string = ""
        do {
            let data = try JSONSerialization.data(withJSONObject: params, options: [])
            string = String(data: data, encoding: String.Encoding.utf8)!
            print(string)
            } catch {
              print("hi")
            }
        string = "locations=" + string
        print(string)
        request.httpBody = string.data(using: .utf8)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            //print(response!)
            //let str = String(decoding: data!, as: UTF8.self)
            //self.optimalRoute = str
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, Any>
                self.optimalRoute = json
            } catch {
                print("error")
            }
        })
        task.resume()
        sleep(3)
    }
    func main(places: [String:CDYelpBusiness]) -> [CDYelpBusiness]{
        var coords: [String:[Double]] = [:]
        for (place,obj) in places{
            coords[place] = [obj.coordinates!.latitude!,obj.coordinates!.longitude!]
        }
        getRoute(coords: coords)
        //print(self.optimalRoute)
        sleep(3)
        parseResponse(places: places)
        print(self.optimalList)
        return self.optimalList
        
    }
    
    func parseResponse (places: [String:CDYelpBusiness]){
        let route = self.optimalRoute["route"] as! Dictionary<String, Dictionary<String, Any>>
        let count = self.optimalRoute["count"] as! Int
        for i in 0...count-1{
            let curr = route[String(i)]
            let name = curr!["name"]
            self.optimalList.append(places[name as! String]!)
        }
    }
    
    func calcTravel(places: [String:[Double]], stringPicked: [String]) {
        
        let request = MKDirections.Request()
        let userLat = self.getLatitude()
        let userLong = self.getLongitude()
        let lat = places[stringPicked[0]]![0]
        let long = places[stringPicked[0]]![1]
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude:userLat , longitude:userLong ), addressDictionary: nil))
        
        
        
        print(self.getLatitude())
        print(self.getLongitude())
        print("----")
        print(lat)
        print(long)
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long), addressDictionary: nil))
        //request.requestsAlternateRoutes = true // if you want multiple possible routes
        request.transportType = .automobile  // will be good for cars
        
        let directions = MKDirections(request: request)
        directions.calculate{ response, error in
            guard let unwrappedResponse = response else { return }

            for route in unwrappedResponse.routes {
                print(route.expectedTravelTime/60, "Minutes")
            }}
        }
    }
}





