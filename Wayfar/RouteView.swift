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
import MapKit

var altRoute: [String:CDYelpBusiness] = [:]

struct RouteView: View { // main view to display route that is generated from previous view
    var route: [CDYelpBusiness] = []
    var body: some View {
        MapViewRoute(route: route) // displays all places picked on map
        Text("From your current location, first head to...")
        List{
            ForEach(route, id: \.id){ r in
                // displays all places in the route in order
                RoutePlaceView(current: r)
                Text("Then head to...").bold().underline()
            }
            
        }.navigationBarTitle("Your Route")
        
}
}

struct MapViewRoute:UIViewRepresentable{ // creates map with pins for each places selected by the user
    var route: [CDYelpBusiness]
    func makeUIView(context: UIViewRepresentableContext<MapViewRoute>) -> MKMapView {
        let mapView = MKMapView()
        let center = CLLocationCoordinate2D(latitude: route[0].coordinates!.latitude!, longitude:route[0].coordinates!.longitude!) // picks point to center map on
        for place in route{ // adds each pin based on coordinates
            let annotation = MKPointAnnotation()
            let coor = CLLocationCoordinate2D(latitude: place.coordinates!.latitude!, longitude:place.coordinates!.longitude!)
            annotation.coordinate = coor
            annotation.title = place.name! // annotates each pin with place name
            mapView.addAnnotation(annotation)
        }
        let region = MKCoordinateRegion( center: center, latitudinalMeters: CLLocationDistance(exactly: 6000)!, longitudinalMeters: CLLocationDistance(exactly: 6000)!) // sets region for map to zoom in on
        mapView.centerCoordinate = center
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
        return mapView

    }
    func updateUIView(_ view: MKMapView, context: UIViewRepresentableContext<MapViewRoute>) {
        
    }
}
struct MapView: UIViewRepresentable { // creates map for current place to display in DetailsViews
    var current: CDYelpBusiness
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let mapView = MKMapView()
        let annotation = MKPointAnnotation()
        let center = CLLocationCoordinate2D(latitude: current.coordinates!.latitude!, longitude:current.coordinates!.longitude!)
        annotation.coordinate = center
        annotation.title = current.name!
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion( center: center, latitudinalMeters: CLLocationDistance(exactly: 2000)!, longitudinalMeters: CLLocationDistance(exactly: 2000)!)
        mapView.centerCoordinate = center
        mapView.setRegion(mapView.regionThatFits(region), animated: true)

        return mapView
    }
    func updateUIView(_ view: MKMapView, context: UIViewRepresentableContext<MapView>) {
        
    }
}

struct RoutePlaceView: View{ // View that is shown as a list for the RouteView above
    var current: CDYelpBusiness
    var body: some View{
        ZStack{
            Liquid() // creates blue bubbles as with the start screen
                .frame(width: 340, height: 180, alignment: .center)
                .foregroundColor(.blue)
                .opacity(0.5)
            Liquid()
                .frame(width: 320, height: 140, alignment: .center)
                .foregroundColor(.blue)
                .opacity(0.3)
            Liquid(samples: 5)
                .frame(width: 300, height: 100, alignment: .center)
                .foregroundColor(.blue)
            Text(current.name ?? "Name").bold().frame(maxWidth: .infinity, alignment: .center).colorInvert()
            NavigationLink(destination: RouteDetailsView(current: current)){} // linkes to details about the current place
        }
    }
}

struct RouteDetailsView: View{
    var current: CDYelpBusiness
    var alts: [CDYelpBusiness] = [] // stores alternatives that are gathered
    @State var next: Bool = false // controls whether to proceed if get alternatives is clicked
    @State var yelp = yelpRequests()
    var body: some View{
        VStack{
            URLImage(url: current.imageUrl!) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            Text(current.name ?? "Name").bold().frame(maxWidth: .infinity, alignment: .center)
            Text(current.phone ?? "Phone")
            Text(String(current.rating!) + " Stars")
            MapView(current: current)
            
            if next{
                NavigationLink("Next", destination: AlternativesView(altOf: current, alternatives: yelp.busis)).foregroundColor(.white).padding().background(Color.accentColor) .cornerRadius(8)
            }else{ // grabs alternatives for the current place by sending another request to the Yelp API
                Button(action:{
                    let newY = yelpRequests()
                    newY.getBusiness(interests: [current.categories![0].alias!], amount: 5, exception: current.name!, prices: ["$","$$","$$$"] )
                    // new request is sent with current place as an exception to ensure no duplicates
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                        yelp = newY
                        next = true // allows next button to appear
                    }
                    
                }){
                    Text("Get Alternatives!")
                }.foregroundColor(.white).padding().background(Color.accentColor) .cornerRadius(8)
                
            }
        }
    }
}

struct AlternativesView: View{ // view to display the alternatives that are gathered
    var altOf: CDYelpBusiness
    var alternatives: [CDYelpBusiness] = []
    var body: some View{
        List(alternatives, id: \.id){ alt in
            AlternativesPlaceView(current: alt, altOf: altOf)
        }.navigationBarTitle(Text("Alternatives"))
    }
}

func removeCurrent(current: CDYelpBusiness){ // method to remove current place from list if alternatives are chosen
    let currName = current.name!
    for i in 0...route.count-1{
        if currName == route[i].name!{
            continue
        }else{
            altRoute[route[i].name!] = route[i]
            
        }
    }
    
}
struct AlternativesPlaceView: View{ // place view for alternatives list with minimal information
    var current: CDYelpBusiness
    var altOf: CDYelpBusiness
    var body: some View{
        Text(current.name ?? "Name").bold()
        Text(String(current.rating!) + " Stars") // shows name and rating for the alternative
        NavigationLink(destination: AlternativesDetailsView(current: current, altOf: altOf)){}
    }
}

/// View to show details of alternative 
struct AlternativesDetailsView: View{
    var current: CDYelpBusiness
    var altOf: CDYelpBusiness // keeps track of which place this is an alternative of to ensure correct removal
    @State var next = false
    var body: some View{
        Text(current.name ?? "Name").bold().frame(maxWidth: .infinity, alignment: .center)
        Text(current.phone ?? "Phone")
        Text(String(current.rating!) + " Stars")
        Text(String(format: "%f", (current.distance!*0.000621371))) // shows current distance from the current alternative
        URLImage(url: current.imageUrl!) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        if next{
            NavigationLink("New Route", destination: RouteView(route: route)).foregroundColor(.white).padding().background(Color.accentColor) .cornerRadius(8)
        }else{
            Button("Select", action:{
                removeCurrent(current: altOf) // removes original place
                altRoute[current.name!] = current // adds alternative to route list
                let altCalc = TravelCalc()
                altCalc.main(places: altRoute) // calculates new optimal route with alternative included 
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0){
                    route = altCalc.optimalList
                    next = true
                }
            }).foregroundColor(.white).padding().background(Color.accentColor) .cornerRadius(8)
        }
    }
}


struct RouteView_Previews: PreviewProvider {
    static var previews: some View {
        RouteView()
    }
}
