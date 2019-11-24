//
//  CameraPreviewView.swift
//  Test-Headshot
//
//  Created by Doug on 2019-11-23.
//  Copyright © 2019 Shodu Ltd. All rights reserved.
//

import SwiftUI
import AVFoundation
import UIKit
import GPUImage
import BBMetalImage

struct CameraPreviewView: UIViewControllerRepresentable  {
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraPreviewView>) -> UIViewController {
        let controller = CameraViewController()
        return controller
    }
    
    
    // View is not updating so we don't need this
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<CameraPreviewView>) {
        
    }
}

class CameraViewController : UIViewController {
    
    var camera: BBMetalCamera!
    var videoWriter: BBMetalVideoWriter!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCamera()
    }
    
    func loadCamera() {
        
         camera = BBMetalCamera(sessionPreset: .hd1920x1080)!

           // Set up 3 filters to process image
            let contrastFilter = BBMetalContrastFilter(contrast: 3)
            let sharpenFilter = BBMetalSharpenFilter(sharpeness: 1)
            let erosionFilter = BBMetalBrightnessFilter(brightness: 0.4)


           // Set up metal view to display image
         
            let metalView = BBMetalView(frame: CGRect(x: 0, y: 0, width: 400, height: 500))
            view.addSubview(metalView)

           
           // Set up filter chain
           camera.add(consumer: contrastFilter)
                .add(consumer: sharpenFilter)
                .add(consumer: erosionFilter)
                .add(consumer: metalView)
            

          

           // Start capturing
           camera.start()

        
        
    }
}
