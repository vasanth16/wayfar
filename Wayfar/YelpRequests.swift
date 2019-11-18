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

//public class YelpRequests{
//    let id: String
//    let apikey: String
//    let yelpAPIClient: CDYelpAPIClient
//    init(){
//        self.id = "9E7QeY2veNmPTWtEiwlZxw"
//        self.apikey = "jyeNOVKa449cPnMn7EASMGbfGXNaipPDebuUviXP1PH1PPJoPE4GNmrfviz_JyOLhLQuM-rtDIsUVFPHJKH5IZy1_dHjHr1cyo5DwWIi9g7dji5pN2BlkSPlGUXLXXYx"
//        self.yelpAPIClient = CDYelpAPIClient(apiKey: self.apikey)
//    }
//



class yelpRequests {
    let id = ""
    let locationManager = CLLocationManager()
    let yelpAPIClient = CDYelpAPIClient(apiKey:" )
    var busis: [CDYelpFusionKit.CDYelpBusiness] = []



    func getBusiness(interests: [String]) -> Void{
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        var categories: [CDYelpBusinessCategoryFilter] = []

        
        for interest in interests{
            categories.append( CDYelpBusinessCategoryFilter.init(rawValue: interest.lowercased().replacingOccurrences(of: " ", with: "")) ?? CDYelpBusinessCategoryFilter.artsAndEntertainment )
        }
        
        
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            print("fires")
            
            yelpAPIClient.searchBusinesses(byTerm: nil, location: nil, latitude: locationManager.location?.coordinate.latitude, longitude: locationManager.location?.coordinate.longitude, radius: 10000, categories: categories, locale: nil, limit: 10, offset: nil, sortBy: nil, priceTiers: nil, openNow: true, openAt: nil, attributes: nil) { (response) in
                let res = response
                if ((res!.businesses) != nil){
                    for r in (res!.businesses)!{
                        //print(r.name)
                        self.busis.append(r)
                        //print(self.busis)
                    }
                }
            }
        }
    }
}






