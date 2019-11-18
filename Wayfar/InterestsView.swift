//
//  InterestsView.swift
//  Wayfar
//
//  Created by Vasanth Rajasekaran on 11/11/19.
//  Copyright © 2019 Vasanth. All rights reserved.
//

import SwiftUI

var interests = ["Parks", "Restaurants", "Theater", "Nightlife","Hiking","Festivals", "Museums", "Shopping", "Amusement Parks", "Beaches"]

struct InterestsView: View {
    @State var selections: [String] = []
    @State var show = false
    @State var yrequests = yelpRequests()
    var body: some View{
        VStack {
            NavigationView{
                List(interests, id: \.self) { interest in
                    MultipleSelectionRow(title: interest, isSelected: self.selections.contains(interest)) {
                        if self.selections.contains(interest) {
                            self.selections.removeAll(where: { $0 == interest })
                        }
                        else {
                            self.selections.append(interest)
                        }
                }.navigationBarTitle(Text("Interests")).foregroundColor(.red)
            }
                
            }
            
            Button(action: {
                let newY = yelpRequests()
                newY.getBusiness(interests: self.selections)
                self.yrequests = newY
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.show.toggle()
                }
            }) {
                Text("Next")
            }
            NavigationLink(destination: ItineraryView(selections: yrequests.busis), isActive: self.$show){
                EmptyView()
            }
        
    }
}
}

// From Stackoverflow : https://stackoverflow.com/questions/57022615/select-multiple-items-in-swiftui-list
struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
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

