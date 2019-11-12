//
//  StartPageView.swift
//  Wayfar
//
//  Created by Vasanth Rajasekaran on 11/11/19.
//  Copyright © 2019 Vasanth. All rights reserved.
//

import SwiftUI

struct StartPageView: View {
    @Binding var next: Bool
       var body: some View {
        GeometryReader{ geometry in
            ZStack{
                Image("bg")
                    .resizable()
                    .aspectRatio( contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("WayFar")
                        .font(.largeTitle)
                        .padding()
                        .colorInvert()
                    Button(action: {
                        print(self.next)
                        self.next = true
                       }) {
                       Text("Get Started")
                           .font(.headline)
                           .padding()
                        .border(Color.white, width: 1)
                        .accentColor(.white)
                        
                       }
                }
            }
        }
    }
}

struct StartPageView_Previews: PreviewProvider {
    @State static var idk = false
    static var previews: some View {
        StartPageView(next: $idk)
    }
}
