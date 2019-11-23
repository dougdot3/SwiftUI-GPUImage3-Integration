//
//  BBMetalBoxBlurFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/6/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import MetalPerformanceShaders

/// A filter that convolves an image with a given kernel of odd width and height
public class BBMetalBoxBlurFilter: BBMetalBaseFilter {
    /// The width of the kernel. Must be an odd number
    public let kernelWidth: Int
    /// The height of the kernel. Must be an odd number
    public let kernelHeight: Int
    
    private lazy var kernel: MPSImageBox = {
        let k = MPSImageBox(device: BBMetalDevice.sharedDevice, kernelWidth: kernelWidth, kernelHeight: kernelHeight)
        k.edgeMode = .clamp
        return k
    }()
    
    public init(kernelWidth: Int = 1, kernelHeight: Int = 1) {
        self.kernelWidth = kernelWidth
        self.kernelHeight = kernelHeight
        super.init(kernelFunctionName: "", useMPSKernel: true)
    }
    
    public override func encodeMPSKernel(into commandBuffer: MTLCommandBuffer) {
        kernel.encode(commandBuffer: commandBuffer, sourceTexture: _sources.first!.texture!, destinationTexture: _outputTexture!)
    }
}
