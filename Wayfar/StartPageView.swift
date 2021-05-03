//
//  StartPageView.swift
//  Wayfar
//
//  Created by Vasanth Rajasekaran on 11/11/19.
//  Copyright © 2019 Vasanth. All rights reserved.
//

import SwiftUI
import Liquid

struct StartPageView: View {
       var body: some View {
        // body of the view
        NavigationView{
            // allows for easy navigation via NavigationLinks
            GeometryReader{ geometry in
                // Helps with structure of the page
                ZStack {
                    
                    Liquid() // creates blue bubbles
                        .frame(width: 240, height: 240, alignment: .center)
                        .foregroundColor(.blue)
                        .opacity(0.3)
                    
                    
                    Liquid()
                        .frame(width: 220, height: 220)
                        .foregroundColor(.blue)
                        .opacity(0.6)
                    
                    Liquid(samples: 5)
                        .frame(width: 200, height: 200, alignment: .center)
                        .foregroundColor(.blue)
                    
                    NavigationLink(destination: InterestsView()){ Text("Wayfare").font(.largeTitle).foregroundColor(.white).frame(alignment: .center)
                    }} // link to the next view where you can select your interests
            }
        }
        .padding(.leading, 3.0)
        
        
        
    }
}


struct StartPageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StartPageView()
            StartPageView()
        }
    }
}
