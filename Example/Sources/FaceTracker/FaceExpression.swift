//
//  FaceExpression.swift
//  EyeTracking_Example
//
//  Created by Ilya Yushkevich on 07.05.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import ARKit

public final class FaceExpression: Equatable {
    let blendShape: ARFaceAnchor.BlendShapeLocation
    let minValue: Float
    let maxValue: Float
    
    public init(blendShape: ARFaceAnchor.BlendShapeLocation, minValue: Float, maxValue: Float) {
        self.blendShape = blendShape
        self.minValue = minValue
        self.maxValue = maxValue
    }
    
    public static func == (lhs: FaceExpression, rhs: FaceExpression) -> Bool {
        guard
            lhs.blendShape == rhs.blendShape,
            lhs.minValue == rhs.minValue,
            lhs.maxValue == rhs.maxValue
        else { return false }
        
        return true
    }
}
