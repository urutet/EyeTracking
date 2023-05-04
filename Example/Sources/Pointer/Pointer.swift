//
//  Pointer.swift
//  EyeTracking_Example
//
//  Created by Ilya Yushkevich on 04.05.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

final public class Pointer {
    private weak var window: UIWindow?
    private var pointer: UIView
    
    public init(window: UIWindow) {
        self.window = window
        self.pointer = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    /**
     Shows pointer.
     - Parameters:
     - parameter config: Pointer configuration.
     
     */
    
    func show(with config: PointerConfiguration) {
        pointer = UIView(frame: CGRect(x: 0, y: 0, width: config.size.width, height: config.size.height))
        pointer.backgroundColor = config.color
        pointer.layer.cornerRadius = config.cornerRadius
        pointer.layer.cornerCurve = config.cornerCurve
        pointer.layer.zPosition = config.zPosition
        
        window?.addSubview(pointer)
    }
    
    func move(coordinates: CGPoint) {
        pointer.frame = CGRect(x: coordinates.x, y: coordinates.y, width: pointer.frame.width, height: pointer.frame.height)
    }
}
