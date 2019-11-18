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
    let id = "9E7QeY2veNmPTWtEiwlZxw"
    let locationManager = CLLocationManager() // location manager to manage user's location
    let yelpAPIClient = CDYelpAPIClient(apiKey:"jyeNOVKa449cPnMn7EASMGbfGXNaipPDebuUviXP1PH1PPJoPE4GNmrfviz_JyOLhLQuM-rtDIsUVFPHJKH5IZy1_dHjHr1cyo5DwWIi9g7dji5pN2BlkSPlGUXLXXYx" ) // Yelp API Key
    var busis: [CDYelpFusionKit.CDYelpBusiness] = [] // Array of businesses to be exported to different views

    func getBusiness(interests: [String]) -> Void{ // function to get businesses near location based on type
        locationManager.requestAlwaysAuthorization() // Gets authorization to use the Devices location
        locationManager.requestWhenInUseAuthorization()
        var categories: [CDYelpBusinessCategoryFilter] = [] // List of categories
        for interest in interests{ // creates category objects that are then appended categories array to be sent into the api call
            categories.append( CDYelpBusinessCategoryFilter.init(rawValue: interest.lowercased().replacingOccurrences(of: " ", with: "")) ?? CDYelpBusinessCategoryFilter.artsAndEntertainment )
        }
        if CLLocationManager.locationServicesEnabled(){
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation() // Starts getting the user's location consistantly
            // The yelp api call
            yelpAPIClient.searchBusinesses(byTerm: nil, location: nil, latitude: locationManager.location?.coordinate.latitude, longitude: locationManager.location?.coordinate.longitude, radius: 10000, categories: categories, locale: nil, limit: 10, offset: nil, sortBy: nil, priceTiers: nil, openNow: true, openAt: nil, attributes: nil) { (response) in
                let res = response // response from API
                if ((res!.businesses) != nil){
                    for r in (res!.businesses)!{
                        self.busis.append(r) // adds the business to the list of businesses
                    }
                }
            }
        }
    }
}





