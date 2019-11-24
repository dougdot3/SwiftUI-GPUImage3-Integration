//
//  CameraView.swift
//  Test-Head
//
//  Created by Doug on 2019-11-23.
//  Copyright © 2019 Shodu Ltd. All rights reserved.
//
import UIKit
import SwiftUI
import GPUImage

// CameraView is a UIVViewRepresentable which returns a view in which an image has been filtered via GPUImage3

struct FilteredPhotoView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        // These are standard GPUImage3 methods.
        //Note that the API methods from GPUImage2 are (mostly) available in GPUImage3
        // The following methods drawn from documentation from GPUImage2
        let testImage = UIImage(named:"photo")!
        let inversionFilter = ColorInversion()
        let filteredImage = testImage.filterWithOperation(inversionFilter)
        // We then take the image and assign it to a view returned via UIViewRepresentable
        let imageView = UIImageView(image: filteredImage)
        return imageView
    }
    
    // The view does not update so there is no need to return
    func updateUIView(_ uiView: UIView, context: Context) {
        //return uiView.load(request)
    }
}

