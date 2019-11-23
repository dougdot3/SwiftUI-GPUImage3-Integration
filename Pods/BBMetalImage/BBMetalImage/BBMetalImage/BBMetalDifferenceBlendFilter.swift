//
//  BBMetalDifferenceBlendFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

/// Applies a difference blend of two images
public class BBMetalDifferenceBlendFilter: BBMetalBaseFilter {
    public init() { super.init(kernelFunctionName: "differenceBlendKernel") }
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {}
}
