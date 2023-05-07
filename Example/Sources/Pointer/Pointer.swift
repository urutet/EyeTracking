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
    var pointerFilter: (x: LowPassFilter, y: LowPassFilter)?
    
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
    
    func move(to point: CGPoint) {
        guard let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else { return }
        let size = UIScreen.main.bounds.size
        let adjusted: (x: CGFloat, y: CGFloat)
        
        switch orientation {
        case .landscapeRight, .landscapeLeft:
            adjusted = (size.width - point.x, size.height - point.y)
        case .portrait, .portraitUpsideDown:
            adjusted = (size.width - point.x, size.height - point.y)
        default:
            assertionFailure("Unknown Orientation")
            return
        }
        
        if pointerFilter == nil {
            pointerFilter = (
                LowPassFilter(value: adjusted.x, filterValue: 0.85),
                LowPassFilter(value: adjusted.y, filterValue: 0.85)
            )
        } else {
            pointerFilter?.x.update(with: adjusted.x)
            pointerFilter?.y.update(with: adjusted.y)
        }
        
        guard let pointerFilter = pointerFilter else { return }
        
        pointer.frame = CGRect(
            x: pointerFilter.x.value,
            y: pointerFilter.y.value,
            width: pointer.frame.width,
            height: pointer.frame.height
        )
    }
}
