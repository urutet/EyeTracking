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
    
    public init(window: UIWindow) {
        self.window = window
    }
    
    /**
     Shows pointer in UIKit.
     - Parameters:
     - parameter config: Pointer configuration.
     
     */
    
    func showUIKitPointer(with config: PointerConfiguration) {
        let pointer = UIView(frame: CGRect(x: 0, y: 0, width: config.size.width, height: config.size.height))
        pointer.backgroundColor = config.color
        pointer.layer.cornerRadius = config.cornerRadius
        pointer.layer.cornerCurve = config.cornerCurve
        pointer.layer.zPosition = config.zPosition
        
        window?.addSubview(pointer)
    }
}
