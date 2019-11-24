//
//  ContentView.swift
//  Test-Headshot
//
//  Created by Doug on 2019-11-23.
//  Copyright © 2019 Shodu Ltd. All rights reserved.
//

import SwiftUI

// A simple SwiftUI screen showing a current view, (CameraView) which displays a static image filtered via GPUImage3
// A button opens up a modal view with a video camera preview active

struct ContentView: View {
        
    // Variable to keep track of whether the modal is open
    @State var isShowingCameraView = false
   
    var body: some View {
         VStack {
            // CameraView shows a static image that has been filtered via GPUImage3
            // Compare original to filtered
            Text("Original:")
                .font(.headline)
            Image("photo")
            .frame(width: 195, height: 259, alignment: .center)
            .padding(.top, 20)
            FilteredPhotoView()
                .frame(width: 195, height: 259, alignment: .center)
                .padding(.top, 100)
            Spacer()
            Button(action : {
                print("Button Pressed")
                self.isShowingCameraView.toggle()
            }, label : {
                Text("Show Camera Preview")
            })
            .sheet(isPresented: $isShowingCameraView, content: {
                // When the button is clicked, a modal sheet is presented showing CameraPreviewView. We apply a gaussian filter to the live videocurrent fr
                FilteredVideoPreviewView()
            })
         }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
