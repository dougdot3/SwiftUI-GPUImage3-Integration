//
//  BBMetalScreenBlendFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

/// Applies a screen blend of two images
public class BBMetalScreenBlendFilter: BBMetalBaseFilter {
    public init() { super.init(kernelFunctionName: "screenBlendKernel") }
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {}
}
