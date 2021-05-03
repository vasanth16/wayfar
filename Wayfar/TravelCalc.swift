//
//  TravelCalc.swift
//  Wayfar
//
//  Created by Vasanth Rajasekaran
//  Copyright © 2021 Vasanth. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit
import CDYelpFusionKit


class TravelCalc{
    
    let locationManager = CLLocationManager() // location manager to manage user's location
    
    func getLatitude() -> Double { // get user coordinates
      let coordinate = locationManager.location?.coordinate ?? CLLocationCoordinate2D()
      return coordinate.latitude
    }
    
    func getLongitude() -> Double { // get user coordinates
      let coordinate = locationManager.location?.coordinate ?? CLLocationCoordinate2D()
      return coordinate.longitude
    }
    var optimalRoute : Dictionary <String,Any> = [:] // data recieved from API is stored
    var optimalList : [CDYelpBusiness] = [] // stores places in right order
    
    /// method to send API call to optimize route
    /// - Parameter coords: coordinates of places selected by the user being parsed by the main function
    func getRoute(coords:[String:[Double]]) {
        //reference: https://stackoverflow.com/questions/24321165/make-rest-api-call-in-swift
        let username = "" // private info for API call, app will not function with API credentials, please contact me if you require the creditials
        let password = ""
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString() // encode authorization to send as a parameter
        
        var params : [[String:String]] = [["address":"Current Location","lat":String(29.956748), "lng": String(-90.065540)]] // set to new orleans but can be changed to user's location using the functions above
        for (key,value) in coords{
            let insert = ["address":key,"lat": String(value[0]), "lng": String(value[1])] // creates dict from coordinates
            params.append(insert)
        }
        var request = URLRequest(url: URL(string: "https://api.routexl.com/tour/")!) // API endpoint and method
        request.httpMethod = "POST" // sets call as a POST request
        var string = ""
        do {
            let data = try JSONSerialization.data(withJSONObject: params, options: []) // turns dict of coordinates into JSON obj to format and then back to string
            string = String(data: data, encoding: String.Encoding.utf8)!
            } catch {
              print("Error")
            }
        string = "locations=" + string // adds string to beginning of stringify dict to conform to API's parameter format
        request.httpBody = string.data(using: .utf8)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization") // sends in auth info
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, Any> // gets response and encodes to JSON
                self.optimalRoute = json
            } catch {
                print("error")
            }
        })
        task.resume()
    }
    /// main method to control the travel calc process
    /// - Parameter places: places selected by user
    func main(places: [String:CDYelpBusiness]){
        var coords: [String:[Double]] = [:]
        for (place,obj) in places{ // creates dict of coordinates
            coords[place] = [obj.coordinates!.latitude!,obj.coordinates!.longitude!]
        }
        getRoute(coords: coords) // calls method to getRoute
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0){ [self] in
            parseResponse(places: places)}
        
    }
    
    /// Parse response from API call
    /// - Parameter places: places selected by the user to reorder based on data recieved from API
    func parseResponse (places: [String:CDYelpBusiness]){
        let route = self.optimalRoute["route"] as! Dictionary<String, Dictionary<String, Any>>
        let count = self.optimalRoute["count"] as! Int
        for i in 1...count-1{
            let curr = route[String(i)]
            let name = curr!["name"]
            self.optimalList.append(places[name as! String]!)
        }
    }
    

}

