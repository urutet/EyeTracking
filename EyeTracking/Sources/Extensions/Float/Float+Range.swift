//
//  Float+Range.swift
//  EyeTracking_Example
//
//  Created by Ilya Yushkevich on 07.05.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

extension Float {
    func inRange(min: Float, max: Float) -> Bool {
        guard self >= min && self <= max else { return false }
        
        return true
    }
}
