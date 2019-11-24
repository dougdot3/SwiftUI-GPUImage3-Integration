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
    
   @IBOutlet weak var renderView: RenderView!
    var camera:Camera!
    var operation:GaussianBlur!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCamera()
    }
    
    func loadCamera() {
        let finalView = RenderView(frame: CGRect(x: 0, y: 0, width: 400, height: 500))
         do {
            operation = GaussianBlur()
            camera = try Camera(sessionPreset: .vga640x480)
            camera.runBenchmark = true
            camera --> operation --> finalView
            camera.startCapture()
        } catch {
            fatalError("Could not initialize rendering pipeline: \(error)")
        }
        view.addSubview(finalView)
        
    }
}
