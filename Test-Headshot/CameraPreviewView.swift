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

struct CameraPreviewView: UIViewControllerRepresentable  {
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraPreviewView>) -> UIViewController {
        let controller = CameraViewController()
        return controller
    }
    
    
    // Tbh no idea what to do here
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<CameraPreviewView>) {
        
    }
}

class CameraViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCamera()
    }
    
    func loadCamera() {
        let avSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device : captureDevice) else { return }
        avSession.addInput(input)
        avSession.startRunning()
        
        let cameraPreview = AVCaptureVideoPreviewLayer(session: avSession)
        view.layer.addSublayer(cameraPreview)
        cameraPreview.frame = view.frame
    }
}
