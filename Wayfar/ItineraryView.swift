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




var picked: [String:CDYelpBusiness] = [:] // for selected places
var stringPicked: [String] = []
var route :[CDYelpBusiness] = []

struct ItineraryView: View {
    var selections: [CDYelpBusiness] = [] // Selections are sent in as a list
    @State var next: Bool = false
    
    var body: some View {
        Text("Please select three places!")
        List(selections, id: \.id){ sel in
            // displays business as PlaceViews
            PlaceView(sel: sel) // creates a placeView with current selection and adds to list
        }.navigationBarTitle("Places").navigationViewStyle(StackNavigationViewStyle())
        VStack {
            if next{
                NavigationLink("Next",destination: RouteView(route: route))
            }else{
                Button(action:{
                    calcTravel()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 7.0){
                        self.next = true
                        print(route)
                    }
                }){
                    Text("Calculate My Route")
                }
            }
            
        }
    }
}
func calcTravel(){
    let travC = TravelCalc()
    travC.main(places: picked)
    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0){
        route = travC.optimalList
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
        NavigationLink(destination: detailsView(current: sel, getWalking: "")){
            // links to ItineraryView, sends in businesses recieved from yelp request
        }
        }
}


struct UberView: View{
    let current: CDYelpBusiness
    let button = RideRequestButton()
    var body: some View{
        makebutton().swiftUIView(layout: .intrinsic).fixedSize()
    }
    func makebutton() -> RideRequestButton{
        print("Uver")
        let pickupLocation = CLLocation(latitude: TravelCalc().getLatitude(), longitude: TravelCalc().getLongitude())
        let dropoffLocation = CLLocation(latitude: current.coordinates!.latitude!, longitude: current.coordinates!.longitude!)
        let builder = RideParametersBuilder()
        builder.pickupLocation = pickupLocation
        builder.pickupNickname = "My Location"
        builder.dropoffLocation = dropoffLocation
        builder.dropoffNickname = current.name!
        builder.productID = "ONd0BXIHXsMRukbg-g1iXO_qOv7tWsqy"
        button.rideParameters = builder.build()
        return button

    }
}
struct detailsView: View {
    var current: CDYelpBusiness
    @State var getWalking: String
    func getWalkingTime() -> String{
        getWalking = TravelCalc().calcTravel(placeLat: current.coordinates!.latitude!, placeLong: current.coordinates!.longitude!)
        return getWalking
    }
    var body: some View{
        VStack(alignment: .center){
            Text(current.name ?? "Name").bold().frame(maxWidth: .infinity, alignment: .center)
            Text(current.phone ?? "Phone")
            Text(String(current.rating!) + " Stars")
            Text(String(getWalkingTime())+" Minutes by walk")
            URLImage(url: current.imageUrl!) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            UberView(current: current)
            //RideRequestButton().swiftUIView(layout: .intrinsic)
            Button(action:{
                if stringPicked.contains(current.name!){
                    let index = stringPicked.firstIndex(of: current.name!)
                    stringPicked.remove(at: index!)
                    picked.removeValue(forKey: current.name!)
                }else{
                    picked[current.name!] = current
                    stringPicked.append(current.name!)
                }
//                    if let details = picked[current.name!] {
//                        if details != []{
//                            picked[current.name!] = [current.coordinates!.latitude! ,current.coordinates!.longitude!]
//                    }else{
//                        picked.removeValue(forKey: current.name!)
//                    }
//                }
                
            }){
                Text("Select")
            }
            
        }
        
    }
//    let Ridebutton = RideRequestButton()
//    let builder = RideParametersBuilder()
//    let dropoffLocation = CLLocation(latitude: (current.coordinates?.latitude)!, longitude: (current.coordinates?.longitude)!)
//    builder.dropoffLocation = dropoffLocation
//    builder.dropoffNickname = current.name!
//    Ridebutton.rideParameters = builder.build()
}


struct ItineraryView_Previews: PreviewProvider {
    static var previews: some View {
        ItineraryView()
    }
}
