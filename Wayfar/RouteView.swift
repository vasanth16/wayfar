//
//  RouteView.swift
//  Wayfar
//
//  Created by Vasanth Rajasekaran on 4/8/21.
//  Copyright © 2021 Vasanth. All rights reserved.
//
import Liquid
import SwiftUI
import CDYelpFusionKit

struct RouteView: View {
    var route: [CDYelpBusiness] = []
    var body: some View {
        List{
            ForEach(route, id: \.id){ r in
                ZStack{
                    Liquid()
                        .frame(width: 140, height: 140, alignment: .leading)
                        .foregroundColor(.blue)
                        .opacity(0.3)
                    Liquid(samples: 5)
                        .frame(width: 100, height: 100, alignment: .leading)
                        .foregroundColor(.blue)
                    NavigationLink(r.name!, destination: detailsView(current: r)).colorInvert()
                }
            }
        }.navigationBarTitle("Your Optimal Route")
}
}

struct RoutePlaceView: View{
    var current: CDYelpBusiness
    var body: some View{
        Text(current.name ?? "Name").bold().frame(maxWidth: .infinity, alignment: .center)
        Text(current.phone ?? "Phone")
    }
}


struct RouteView_Previews: PreviewProvider {
    static var previews: some View {
        RouteView()
    }
}
