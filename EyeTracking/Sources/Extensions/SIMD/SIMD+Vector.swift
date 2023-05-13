//
//  SMID+.swift
//  EyeTracking_Example
//
//  Created by Ilya Yushkevich on 07.05.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import simd

extension simd_float4x4 {
    var position: simd_float3 {
        return simd_float3(columns.3.x, columns.3.y, columns.3.z)
    }

    var frontVector: simd_float3 {
        return simd_float3(-columns.2.x, -columns.2.y, -columns.2.z)
    }
}
