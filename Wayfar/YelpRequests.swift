//
//  YelpRequests.swift
//  Wayfar
//
//  Created by Vasanth Rajasekaran on 11/12/19.
//  Copyright © 2019 Vasanth. All rights reserved.
//

import Foundation
import CoreLocation
import CDYelpFusionKit

class yelpRequests {
    let id = "" //Yelp Client ID REDACTED, app will not function with API credentials, please contact me if you require the creditials
    let locationManager = CLLocationManager() // location manager to manage user's location
    let yelpAPIClient = CDYelpAPIClient(apiKey:"" ) // Yelp API Key REDACTED, app will not function with API credentials, please contact me if you require the creditials
    var busis: [CDYelpFusionKit.CDYelpBusiness] = [] // Array of businesses to be exported to different views
    
    func getLatitude() -> Double {
      let coordinate = locationManager.location?.coordinate ?? CLLocationCoordinate2D()
      return coordinate.latitude
    }
    func getLongitude() -> Double {
      let coordinate = locationManager.location?.coordinate ?? CLLocationCoordinate2D()
      return coordinate.longitude
    }
    
    
    /// function to get businesses near location based on type
    /// - Parameters:
    ///   - interests: interests selected by the user
    ///   - amount: how many places to return
    ///   - exception: what places should be left out from returned list of places if any
    ///   - prices: price tier to search
    /// - Returns: void
    func getBusiness(interests: [String], amount: Int, exception: String? = nil, prices:[String]) -> Void{
        locationManager.requestAlwaysAuthorization() // Gets authorization to use the Devices location
        locationManager.requestWhenInUseAuthorization()
        var alt = false
        if exception != nil{
            alt = true
        }
        var priceObjs : [CDYelpPriceTier] = []
        if (interests[0] == "Restaurants"){
            for price in prices{
                if (price == "$"){
                    priceObjs.append(.oneDollarSign)
                    continue
                }
                if(price == "$$"){
                    priceObjs.append(.twoDollarSigns)
                    continue
                }
                if (price == "$$$"){
                    priceObjs.append(.fourDollarSigns)
                    continue
                }
            }
        }
        var categories: [CDYelpCategoryAlias] = [] // List of categories
        for interest in interests{ // creates category objects that are then appended categories array to be sent into the api call
            categories.append( CDYelpCategoryAlias.init(rawValue: interest.lowercased().replacingOccurrences(of: " ", with: "")) ?? CDYelpCategoryAlias.artsAndEntertainment )
        }
        if CLLocationManager.locationServicesEnabled(){
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation() // Starts getting the user's location consistantly
            // The yelp api call
            print(getLatitude())
            
            yelpAPIClient.searchBusinesses(byTerm: nil, location: nil, latitude: 29.956748, longitude: -90.065540, radius: 10000, categories: categories, locale: nil, limit: amount, offset: nil, sortBy: nil, priceTiers: priceObjs, openNow: false, openAt: nil, attributes: nil) { (response) in
                let res = response // response from API
                if ((res!.businesses) != nil){
                    for r in (res!.businesses)!{
                        //print(r.name)
                        if alt{
                            if r.name! == exception{
                                continue
                            }else{
                                self.busis.append(r) // adds the business to the list of businesses
                            }
                        }else{
                        self.busis.append(r) // adds the business to the list of businesses
                        }
                    }
                }
            }
        }
    }
    
}






