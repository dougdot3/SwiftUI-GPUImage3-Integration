//
//  BBMetalGaussianBlurFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/4/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import MetalPerformanceShaders

/// A filter that convolves an image with a Gaussian blur of a given sigma in both the x and y directions
public class BBMetalGaussianBlurFilter: BBMetalBaseFilter {
    /// The standard deviation of the gaussian blur filter
    public let sigma: Float
    
    private lazy var kernel: MPSImageGaussianBlur = {
        let k = MPSImageGaussianBlur(device: BBMetalDevice.sharedDevice, sigma: sigma)
        k.edgeMode = .clamp
        return k
    }()
    
    public init(sigma: Float) {
        self.sigma = sigma
        super.init(kernelFunctionName: "", useMPSKernel: true)
    }
    
    public override func encodeMPSKernel(into commandBuffer: MTLCommandBuffer) {
        kernel.encode(commandBuffer: commandBuffer, sourceTexture: _sources.first!.texture!, destinationTexture: _outputTexture!)
    }
}
