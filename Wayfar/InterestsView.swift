//
//  InterestsView.swift
//  Wayfar
//
//  Created by Vasanth Rajasekaran on 11/11/19.
//  Copyright © 2019 Vasanth. All rights reserved.
//

import SwiftUI

var interests = ["Parks", "Resturants", "Shows", "Nightlife","Camping","Sightseeing", "Mueseums"]

struct InterestsView: View {
    var body: some View{
        VStack {
            NavigationView{
                List(interests, id: \.self) { interest in
                    Text(interest).accentColor(Color(.red))
                }.navigationBarTitle(Text("Interests")).foregroundColor(.red)
            }
            Button(action: {
                getBusiness(interests: [""])
            }) {
                Text(/*@START_MENU_TOKEN@*/"Button"/*@END_MENU_TOKEN@*/)
            }
        }
        
    }

    
    }


struct InterestsView_Previews: PreviewProvider {
    static var previews: some View {
        InterestsView()
        
    }
}
