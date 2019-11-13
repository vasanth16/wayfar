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

let id = "9E7QeY2veNmPTWtEiwlZxw"
let apikey = "jyeNOVKa449cPnMn7EASMGbfGXNaipPDebuUviXP1PH1PPJoPE4GNmrfviz_JyOLhLQuM-rtDIsUVFPHJKH5IZy1_dHjHr1cyo5DwWIi9g7dji5pN2BlkSPlGUXLXXYx"
    let locationManager = CLLocationManager()
    let yelpAPIClient = CDYelpAPIClient(apiKey: apikey)
    func getBusiness(interests: [String]){
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled(){
            
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
            yelpAPIClient.searchBusinesses(byTerm: "Food", location: nil, latitude: locationManager.location?.coordinate.latitude, longitude: locationManager.location?.coordinate.longitude, radius: 10000, categories: nil, locale: nil, limit: 10, offset: nil, sortBy: nil, priceTiers: nil, openNow: true, openAt: nil, attributes: nil) { (response) in
                let res = response
                if ((res!.businesses) != nil){
                    for r in (res?.businesses)!{
                        print(r.name)
                    }
                }else{
                    print(res!)
                }
                
            }
        }
    }









