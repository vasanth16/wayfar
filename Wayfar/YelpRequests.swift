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
    let id = ""
    let locationManager = CLLocationManager() // location manager to manage user's location
    let yelpAPIClient = CDYelpAPIClient(apiKey:"" ) // Yelp API Key
    var busis: [CDYelpFusionKit.CDYelpBusiness] = [] // Array of businesses to be exported to different views
    
    func getLatitude() -> Double {
      let coordinate = locationManager.location?.coordinate ?? CLLocationCoordinate2D()
      return coordinate.latitude
    }
    func getLongitude() -> Double {
      let coordinate = locationManager.location?.coordinate ?? CLLocationCoordinate2D()
      return coordinate.longitude
    }
    func getBusiness(interests: [String]) -> Void{ // function to get businesses near location based on type
        locationManager.requestAlwaysAuthorization() // Gets authorization to use the Devices location
        locationManager.requestWhenInUseAuthorization()
        var categories: [CDYelpCategoryAlias] = [] // List of categories
        for interest in interests{ // creates category objects that are then appended categories array to be sent into the api call
            categories.append( CDYelpCategoryAlias.init(rawValue: interest.lowercased().replacingOccurrences(of: " ", with: "")) ?? CDYelpCategoryAlias.artsAndEntertainment )
        }
        if CLLocationManager.locationServicesEnabled(){
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation() // Starts getting the user's location consistantly
            // The yelp api call
            print(getLatitude())
            
            yelpAPIClient.searchBusinesses(byTerm: nil, location: nil, latitude: getLatitude(), longitude: getLongitude(), radius: 10000, categories: categories, locale: nil, limit: 3, offset: nil, sortBy: nil, priceTiers: nil, openNow: true, openAt: nil, attributes: nil) { (response) in
                let res = response // response from API
                if ((res!.businesses) != nil){
                    for r in (res!.businesses)!{
                        print(r.name)
                        self.busis.append(r) // adds the business to the list of businesses
                    }
                }
            }
        }
        print(self.busis)
    }
    
}






