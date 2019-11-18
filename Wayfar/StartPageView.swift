//
//  StartPageView.swift
//  Wayfar
//
//  Created by Vasanth Rajasekaran on 11/11/19.
//  Copyright © 2019 Vasanth. All rights reserved.
//

import SwiftUI

struct StartPageView: View {
       var body: some View { // body of the view
        NavigationView{ // allows for easy navigation via NavigationLinks
        GeometryReader{ geometry in // Helps with structure of the page
            ZStack{
                Image("bg") // Background image
                    .resizable()
                    .aspectRatio( contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("WayFar") // Title of the App
                        .font(.largeTitle)
                        .padding()
                        .colorInvert()
                    NavigationLink(destination: InterestsView()) { // Creates a button that switchs the current view to the interestsView
                    Text("Get Started")
                        .font(.headline)
                        .padding().border(Color.white, width: 1)
                        .accentColor(.white)
                    }
                }
            }
        }
    }
    }
}


struct StartPageView_Previews: PreviewProvider {
    static var previews: some View {
        StartPageView()
    }
}
