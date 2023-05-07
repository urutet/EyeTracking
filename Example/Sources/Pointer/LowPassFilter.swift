//
//  LowPassFilter.swift
//  EyeTracking_Example
//
//  Created by Ilya Yushkevich on 07.05.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

struct LowPassFilter {
    private(set) var value: CGFloat
    
    let filterValue: CGFloat
    
    /// Updates the value with smoothing.
    mutating func update(with value: CGFloat) {
        self.value = filterValue * self.value + (1.0 - filterValue) * value
    }
}
