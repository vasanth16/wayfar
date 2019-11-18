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
    var selections: [CDYelpBusiness] = []
    var body: some View {
        List(selections, id: \.id){ sel in
            PlaceView(sel: sel)
        }.navigationBarTitle("Places")
    }
}

func parseBusiness(bus: CDYelpBusiness) -> [String]{
    let busName = bus.name
    let busType = bus.categories![0].title!
    return [busName!, busType]
    
}

struct PlaceView: View {
    var sel: CDYelpBusiness
    var body: some View{
        VStack{
            Text(parseBusiness(bus: self.sel)[0])
            Text(parseBusiness(bus: self.sel)[1].replacingOccurrences(of: " ", with: ""))
        }
        }
    }




struct ItineraryView_Previews: PreviewProvider {
    static var previews: some View {
        ItineraryView()
    }
}
