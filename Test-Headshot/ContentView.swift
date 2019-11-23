//
//  ContentView.swift
//  Test-Headshot
//
//  Created by Doug on 2019-11-23.
//  Copyright © 2019 Shodu Ltd. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var isShowingCameraView = false
    var body: some View {
         VStack {
            CameraView()
            Button(action : {
                print("Button Pressed")
                self.isShowingCameraView.toggle()
            }, label : {
                Text("Show Camera Preview")
            })
            .sheet(isPresented: $isShowingCameraView, content: {
                CameraPreviewView()
            })
         }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
