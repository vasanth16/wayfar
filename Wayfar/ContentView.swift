//
//  ContentView.swift
//  Wayfar
//
//  Created by Vasanth Rajasekaran on 11/8/19.
//  Copyright © 2019 Vasanth. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    @State var inte = false
    var body: some View{
        return Group {
            if inte {
                InterestsView()
            }else{
                StartPageView(next: $inte)
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
