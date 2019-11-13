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
        NavigationView{
        List(interests, id: \.self) { interest in
            Text(interest).accentColor(Color(.red))
        }.navigationBarTitle(Text("Interests")).foregroundColor(.red)
        }
    }
    
    }



struct InterestsView_Previews: PreviewProvider {
    static var previews: some View {
        InterestsView()
    }
}
