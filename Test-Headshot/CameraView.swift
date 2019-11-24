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

struct CameraView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        let testImage = UIImage(named:"brock")!
        let toonFilter = ColorInversion()
        let filteredImage = testImage.filterWithOperation(toonFilter)
        let imageView = UIImageView(image: filteredImage)
        return imageView
    }
    
    // 3.
    func updateUIView(_ uiView: UIView, context: Context) {
        //return uiView.load(request)
    }
}

