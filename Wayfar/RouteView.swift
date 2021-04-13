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
import URLImage




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
                    //RoutePlaceView(current: r)
                    NavigationLink(r.name!, destination: RouteDetailsView(current: r))
                }
            }
        }.navigationBarTitle("Your Route")
}
}

struct RoutePlaceView: View{
    var current: CDYelpBusiness
    var body: some View{
        Text(current.name ?? "Name").bold().frame(maxWidth: .infinity, alignment: .center)
        Text(current.phone ?? "Phone")
        NavigationLink(destination: RouteDetailsView(current: current)){
            // links to ItineraryView, sends in businesses recieved from yelp request
        }
    }
}

struct RouteDetailsView: View{
    var current: CDYelpBusiness
    var alts: [CDYelpBusiness] = []
    @State var next: Bool = false
    @State var yelp = yelpRequests()
    var body: some View{
        VStack{
            Text(current.name ?? "Name").bold().frame(maxWidth: .infinity, alignment: .center)
            Text(current.phone ?? "Phone")
            Text(String(current.rating!) + " Stars")
            //Text(String(format: "%f", current.location! as! CVarArg))
            URLImage(url: current.imageUrl!) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            if next{
                NavigationLink("Next", destination: AlternativesView(alternatives: yelp.busis))
            }else{
                Button(action:{
                    //self.alts = getAlts(business: current)
                    let newY = yelpRequests()
                    newY.getBusiness(interests: [current.categories![0].alias!], amount: 5, exception: current.name!)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                        yelp = newY
                        print(yelp.busis)
                        next = true
                        print("bye")
                    }
                    
                }){
                    Text("Get Alternatives!")
                }
                
            }
        }
        
        
//        Text("Alternatives").bold().underline()
//        List (getAlts(business: current), id: \.id){ alts in
//            Text(alts.name!)
//            //PlaceView(sel: current)
//        }
    }
}

struct AlternativesView: View{
    //var current: CDYelpBusiness
    var alternatives: [CDYelpBusiness] = []
    var body: some View{
        List(alternatives, id: \.id){ alt in
            PlaceView(sel: alt)
        }
    }
}

//func getAlts (business: CDYelpBusiness) -> [CDYelpBusiness]{
//
//    var returnArry: [CDYelpBusiness] = []
//
//
//    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
//        returnArry = yelp.busis
//        print(returnArry)
//        print("bye")
//    }
//    print("Hi")
//    //Thread.sleep(forTimeInterval: 3)
//    //print(yelp.busis)
//    return returnArry
//}


struct RouteView_Previews: PreviewProvider {
    static var previews: some View {
        RouteView()
    }
}
