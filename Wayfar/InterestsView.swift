//
//  InterestsView.swift
//  Wayfar
//
//  Created by Vasanth Rajasekaran on 11/11/19.
//  Copyright © 2019 Vasanth. All rights reserved.
//

import SwiftUI

var interests = ["Parks", "Restaurants", "Theater", "Nightlife","Hiking","Festivals", "Museums", "Shopping", "Amusement Parks", "Beaches"] // some sample interests

struct InterestsView: View {
    @State var selections: [String] = [] // where user selections will be storedd
    @State var show = false // whether to show the next view or not
    @State var yrequests = yelpRequests() // requests object
    var prices = ["$","$$","$$$"]
    @State var PriceSelections: [String] = []
    var body: some View{
        VStack {
            NavigationView{
                List(interests, id: \.self) { interest in
                    MultipleSelectionRow(title: interest, isSelected: self.selections.contains(interest)) { // interests from above are displayed in list using custom row view from below
                        if self.selections.contains(interest) {
                            self.selections.removeAll(where: { $0 == interest })
                        }
                        else {
                            self.selections.append(interest)
                        }
                    }.navigationBarTitle(Text("Interests")).foregroundColor(.red)
            }
                
            }
            Text("Please Select your Price Tiers")
                List(prices, id: \.self){ price in
                    MultipleSelectionRow(title: price, isSelected: self.PriceSelections.contains(price)){
                        if self.PriceSelections.contains(price) {
                            self.PriceSelections.removeAll(where: { $0 == price })
                        }
                        else {
                            self.PriceSelections.append(price)
                    }
                }
                }
            
            Button(action: {
                // On button tap
                let newY = yelpRequests()
                for i in self.selections{
                    newY.getBusiness(interests: [i], amount: 3,prices: PriceSelections)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){print(newY.busis)}
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                    yrequests = newY
                    self.show.toggle() // toggles show to trigger NavigationLink
                }
                
            }){
                Text("Next")
            }.foregroundColor(.white).padding().background(Color.accentColor) .cornerRadius(8)
            NavigationLink(destination: ItineraryView(selections: yrequests.busis), isActive: self.$show){
                // links to ItineraryView, sends in businesses recieved from yelp request
            }
        
    }
}
}

// From Stackoverflow : https://stackoverflow.com/questions/57022615/select-multiple-items-in-swiftui-list
struct MultipleSelectionRow: View { // Custom row view in order to give users the ablity to choose from a list
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark") // displays checkmark if selected
                }
            }
        }
    }
}
struct InterestsView_Previews: PreviewProvider {
    static var previews: some View {
        InterestsView()
        
    }
}


