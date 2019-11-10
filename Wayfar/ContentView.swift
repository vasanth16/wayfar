//
//  ContentView.swift
//  Wayfar
//
//  Created by Vasanth Rajasekaran on 11/8/19.
//  Copyright © 2019 Vasanth. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack {
          // Target color block
          VStack {
            Rectangle()
            Text("Match this color")
          }
          // Guess color block
          VStack {
            Rectangle()
            HStack {
              Text("R: xxx")
              Text("G: xxx")
              Text("B: xxx")
            }
          }
        }


    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
