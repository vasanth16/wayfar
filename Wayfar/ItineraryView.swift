//
//  ItineraryView.swift
//  Wayfar
//
//  Created by Vasanth Rajasekaran on 11/17/19.
//  Copyright © 2019 Vasanth. All rights reserved.
//

import SwiftUI
import CDYelpFusionKit

struct ItineraryView: View {
    var selections: [CDYelpBusiness] = [] // Selections are sent in as a list
    var body: some View {
        List(selections, id: \.id){ sel in // displays business as PlaceViews
            PlaceView(sel: sel) // creates a placeView with current selection and adds to list
        }.navigationBarTitle("Places")
    }
}
func parseBusiness(bus: CDYelpBusiness) -> [String] { // parses business object that is sent in and returns an array with the name and its type
    let busName = bus.name
    let busType = bus.categories![0].title!
    return [busName!, busType]
}
struct PlaceView: View { // Custom view to display businesses
    var sel: CDYelpBusiness // takes in a business object
    var body: some View{
        VStack{
            Text(parseBusiness(bus: self.sel)[0]) // displays name
            Text(parseBusiness(bus: self.sel)[1].replacingOccurrences(of: " ", with: "")) // displays the type
        }
        }
    }

struct ItineraryView_Previews: PreviewProvider {
    static var previews: some View {
        ItineraryView()
    }
}
