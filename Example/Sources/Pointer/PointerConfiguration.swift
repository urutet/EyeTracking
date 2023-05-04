//
//  PointerConfiguration.swift
//  EyeTracking_Example
//
//  Created by Ilya Yushkevich on 04.05.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

final public class PointerConfiguration {
    public var color: UIColor
    public var size: CGSize
    public var cornerRadius: Double
    public var cornerCurve: CALayerCornerCurve
    public var zPosition: CGFloat
    
    public init(
        color: UIColor = .red,
        size: CGSize = CGSize(width: 30, height: 30),
        cornerRadius: Double = 15,
        cornerCurve: CALayerCornerCurve = .continuous,
        zPosition: CGFloat = .greatestFiniteMagnitude
    ) {
        self.color = color
        self.size = size
        self.cornerRadius = cornerRadius
        self.cornerCurve = cornerCurve
        self.zPosition = zPosition
    }
}
