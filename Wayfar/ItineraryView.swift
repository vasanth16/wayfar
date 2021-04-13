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



var picked: [String:CDYelpBusiness] = [:] // for selected places
var stringPicked: [String] = []
var route :[CDYelpBusiness] = []

struct ItineraryView: View {
    var selections: [CDYelpBusiness] = [] // Selections are sent in as a list
    @State var next: Bool = false
    
    var body: some View {
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
            //NavigationLink(destination: RouteView(route: route)){}
            }
            
//            Button(action:{
////                let travC = TravelCalc()
////                self.route = travC.main(places: picked)
//                calcTravel()
//                print("Hiiiiiiii")
//
//            }){
//                Text("Calc")
//            }
            //NavigationLink(destination: RouteView(route: route))
            
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
    //picked[bus.name!] = []
    //stringPicked.append(bus.name!)
    return [busName!, busType, busNum!, busD]
}
// from https://medium.com/swlh/loading-images-from-url-in-swift-2bf8b9db266
//func setImage(from url: String) {
//    guard let imageURL = URL(string: url) else { return }
//    DispatchQueue.global().async {
//        guard let imageData = try? Data(contentsOf: imageURL) else { return }
//
//        imageView = Image(data: imageData)
//    }
//}
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
//func uberButton (current: CDYelpBusiness){
//    let Ridebutton = RideRequestButton()
//    let builder = RideParametersBuilder()
//    let dropoffLocation = CLLocation(latitude: (current.coordinates?.latitude)!, longitude: (current.coordinates?.longitude)!)
//    builder.dropoffLocation = dropoffLocation
//    builder.dropoffNickname = current.name!
//    Ridebutton.rideParameters = builder.build()
//}
struct detailsView: View {
    var current: CDYelpBusiness
    var body: some View{
        VStack(alignment: .leading){
            Text(current.name ?? "Name").bold().frame(maxWidth: .infinity, alignment: .center)
            Text(current.phone ?? "Phone")
            Text(String(current.rating!) + " Stars")
            //Text(String(format: "%f", current.location! as! CVarArg))
            URLImage(url: current.imageUrl!) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
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
