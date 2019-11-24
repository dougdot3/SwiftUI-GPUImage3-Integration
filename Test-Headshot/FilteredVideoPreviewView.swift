//
//  CameraPreviewView.swift
//  Test-Headshot
//
//  Created by Doug on 2019-11-23.
//  Copyright © 2019 Shodu Ltd. All rights reserved.
//

import SwiftUI
import UIKit
import GPUImage

// Testing showing a video preview which is "live filtered" using GPUImage3
// We use a UIViewControllerRepresentable as the bridge between our UIViewController and Swift

struct FilteredVideoPreviewView: UIViewControllerRepresentable  {
   
    func makeUIViewController(context: UIViewControllerRepresentableContext<FilteredVideoPreviewView>) -> UIViewController {
        let controller = CameraViewController()
        return controller
    }
    
    // No values change so no need to return anything
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<FilteredVideoPreviewView>) {
        
    }
}

class CameraViewController : UIViewController {
    
    // GPUImage3 returns video output to a RenderView. Have tried different ways of doing this, but setting up as an IBOutlet works
    
   @IBOutlet weak var renderView: RenderView!
    
    // GPUImage3 camera values
    var camera:Camera!
    var operation:GaussianBlur!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCamera()
    }
    
    func loadCamera() {
        // Set frame for the video preview to display, as a RenderView
        let finalView = RenderView(frame: CGRect(x: 0, y: 0, width: 400, height: 500))
        // Standard GPUImage3 methods. GPUImage2 APIs still work, so we use the documentation to come up with the following
        do {
            operation = GaussianBlur()
            camera = try Camera(sessionPreset: .vga640x480)
            camera.runBenchmark = true
            // Note that this would USUALLY be --> RenderView, but we can't return it to SwiftUI. Therefore we are returning to finalView
            camera --> operation --> finalView
            camera.startCapture()
        } catch {
            fatalError("Could not initialize rendering pipeline: \(error)")
        }
        // Attach camera preview video to view
        view.addSubview(finalView)
        
    }
}
