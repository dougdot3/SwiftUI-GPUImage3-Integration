//
//  BBMetalGammaFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/3/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void gammaKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                        texture2d<half, access::read> inputTexture [[texture(1)]],
                        constant float *gamma [[buffer(0)]],
                        uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const half4 inColor = inputTexture.read(gid);
    const half4 outColor(pow(inColor.rgb, half3(*gamma)), inColor.a);
    outputTexture.write(outColor, gid);
}
