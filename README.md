# SwiftUI and GPUImage3 to Filter Photos and Video with Metal

A basic implementation showing how to use <a href="https://github.com/BradLarson/GPUImage3">GPUImage3</a> within a SwiftUI project in order to add metal-based filters to photos and live video. 

In order to add GPUImage3 to your project, follow <a href="https://github.com/BradLarson/GPUImage3">the instructions</a> in the readme:

<i>To add the GPUImage framework to your Mac or iOS application, either drag the GPUImage.xcodeproj project into your application's project or add it via File | Add Files To...

After that, go to your project's Build Phases and add GPUImage_iOS or GPUImage_macOS as a Target Dependency. Add it to the Link Binary With Libraries phase. Add a new Copy Files build phase, set its destination to Frameworks, and add the upper GPUImage.framework (for iOS) or lower GPUImage.framework (for Mac) to that. That last step will make sure the framework is deployed in your application bundle.

In any of your Swift files that reference GPUImage classes, simply add

import GPUImage
and you should be ready to go.</i>

## Add Representables to Your SwiftUI Project
In order to access UIKit methods, add UIRepresentable. For example, to create a live video preview that is filtered with Metal:

struct FilteredVideoPreviewView: UIViewControllerRepresentable  { <br/>
    func makeUIViewController(context: UIViewControllerRepresentableContext<FilteredVideoPreviewView>) -> UIViewController {<br/> 
        let controller = CameraViewController()<br/>
        return controller<br/>
    }<br/>
       <br/>
    // No values change so no need to return anything. <br/>
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<FilteredVideoPreviewView>)<br/> {. 
    }<br/>
}<br/>

## Add a controller to return a GPUImage filtered view or video
GPUImage3 generally returns a RenderView which is attached to the view hierarchy (and is put in a storyboard as an outlet).

Thus, in our controllers we need to adjust in order to return something that Representable can consume.

For images:
let filteredImage = testImage.filterWithOperation(inversionFilter)<br/>
// We then take the image and assign it to a view returned via UIViewRepresentable<br/>
let imageView = UIImageView(image: filteredImage)<br/>
return imageView<br/>

For video:<br/>
 @IBOutlet weak var renderView: RenderView!..<br/>
 let finalView = RenderView(frame: CGRect(x: 0, y: 0, width: 400, height: 500))..<br/>
 camera.startCapture()...<br/>
 view.addSubview(finalView)
