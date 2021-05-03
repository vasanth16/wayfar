//
//  ItineraryView.swift
//  Wayfar
//
//  Created by Vasanth Rajasekaran on 11/17/19.
//  Copyright © 2019 Vasanth. All rights reserved.
//
import SwiftUI
import CDYelpFusionKit
import URLImage
import CoreLocation
import UberRides
import SwiftUIKitView
import MapKit


var picked: [String:CDYelpBusiness] = [:] // for selected places
var stringPicked: [String] = []
var route :[CDYelpBusiness] = []

struct ItineraryView: View {
    var selections: [CDYelpBusiness] = [] // Selections are sent in as a list
    @State var next: Bool = false // controls whether to show next button
    
    var body: some View {
        Text("Please select three places!")
        List(selections, id: \.id){ sel in
            // displays business as PlaceViews
            PlaceView(sel: sel) // creates a placeView with current selection and adds to list
        }.navigationBarTitle("Places").navigationViewStyle(StackNavigationViewStyle())
        VStack {
            if next{
                NavigationLink("Next",destination: RouteView(route: route)).foregroundColor(.white).padding().background(Color.accentColor) .cornerRadius(8)
            }else{
                Button(action:{
                    calcTravel()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 7.0){
                        self.next = true
                        print(route)
                    }
                }){
                    Text("Calculate My Route")
                }.foregroundColor(.white).padding().background(Color.accentColor) .cornerRadius(8)
            }
            
        }
    }
}
func calcTravel(){
    // method to calculate optimal route between selected objects
    let travC = TravelCalc() // creates travelCalc obj
    travC.main(places: picked)
    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0){ // wait for ensuring API data is returned before proceeding
        route = travC.optimalList // sets returned
        print(route)
    }
    
}
func parseBusiness(bus: CDYelpBusiness) -> [String] {
    // parses business object that is sent in and returns an array with the name and its type
    let busName = bus.name
    let busType = bus.categories![0].title!
    let busNum = bus.displayPhone
    let busD:String = String(format: "%f", (bus.distance!*0.000621371))
    return [busName!, busType, busNum!, busD]
}

struct PlaceView: View {
    // Custom view to display businesses
    var sel: CDYelpBusiness // takes in a business object
    var body: some View{
        VStack(alignment: .leading){
            Text(parseBusiness(bus: self.sel)[0]).bold() // displays name
            Text(parseBusiness(bus: self.sel)[1].replacingOccurrences(of: " ", with: "")).italic() // displays the type
            Text(parseBusiness(bus: self.sel)[2])
            Text(parseBusiness(bus: self.sel)[3] + " Miles away")
            
        }.navigationViewStyle(StackNavigationViewStyle())
        NavigationLink(destination: detailsView(current: sel)){
            // links to ItineraryView, sends in businesses recieved from yelp request
        }
        }
}


struct UberView: View{ // custom view to display Uber button since it is not made for Swift UI
    let current: CDYelpBusiness
    let button = RideRequestButton()
    var body: some View{
        makebutton().swiftUIView(layout: .intrinsic).fixedSize()
    }
    func makebutton() -> RideRequestButton{ // function to make Uber with user's location
        let pickupLocation = CLLocation(latitude: TravelCalc().getLatitude(), longitude: TravelCalc().getLongitude())
        let dropoffLocation = CLLocation(latitude: current.coordinates!.latitude!, longitude: current.coordinates!.longitude!)
        let builder = RideParametersBuilder()
        builder.pickupLocation = pickupLocation
        builder.pickupNickname = "My Location"
        builder.dropoffLocation = dropoffLocation
        builder.dropoffNickname = current.name!
        builder.productID = "" // custom code given to each Uber account
        button.rideParameters = builder.build()
        return button

    }
}

struct detailsView: View {
    var current: CDYelpBusiness
    

    var body: some View{
        VStack(alignment: .center){
            Text(current.name ?? "Name").bold().frame(maxWidth: .infinity, alignment: .center)
            Text(current.phone ?? "Phone")
            Text(String(current.rating!) + " Stars")
            URLImage(url: current.imageUrl!) { image in
                // grabs image for place from Yelp
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            MapView(current: current) // brings in Map for current place
            UberView(current: current) // displays Uber button for current place
            Button(action:{
                if stringPicked.contains(current.name!){ // adds place picked places for routing
                    let index = stringPicked.firstIndex(of: current.name!)
                    stringPicked.remove(at: index!)
                    picked.removeValue(forKey: current.name!)
                }else{
                    picked[current.name!] = current
                    stringPicked.append(current.name!)
                }
                
            }){
                Text("Select")
            }.foregroundColor(.white).padding().background(Color.accentColor) .cornerRadius(8)
        }
    }
}


struct ItineraryView_Previews: PreviewProvider {
    static var previews: some View {
        ItineraryView()
    }
}
