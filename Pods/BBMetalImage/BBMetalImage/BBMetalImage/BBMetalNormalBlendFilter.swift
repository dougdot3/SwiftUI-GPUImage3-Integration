//
//  BBMetalNormalBlendFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

/// Applies a normal blend of two images
public class BBMetalNormalBlendFilter: BBMetalBaseFilter {
    public init() { super.init(kernelFunctionName: "normalBlendKernel") }
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {}
}
