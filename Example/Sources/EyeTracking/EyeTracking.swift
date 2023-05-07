//
//  EyeTracking.swift
//  EyeTracking_Example
//
//  Created by Ilya Yushkevich on 30.04.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import ARKit

public class EyeTracking {
    var session: Session
    var pointer: Pointer?
    
    public init(session: Session = Session()) {
        self.session = session
        session.delegate = self
    }
    
    /**
     Shows pointer if it is needed by application.
     - Parameters:
     - parameter window: Application window to attach pointer to.
     - parameter config: Pointer configuration.
     */
    public func showPointer(window: UIWindow, with config: PointerConfiguration) {
        pointer = Pointer(window: window)
        pointer?.show(with: config)
    }
}

extension EyeTracking: SessionDelegate {
    public func sessionDidUpdate(_ session: ARSession, frame: ARFrame) {
        guard
            let anchor = frame.anchors.first as? ARFaceAnchor,
            let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        else { return }
        
        // Get distance between camera and anchor
        let distanceVector = frame.camera.transform.columns.3 - anchor.transform.columns.3
        
        // Project the new distance vector into screen coordinate space.
        let distancePoint = frame.camera.projectPoint(
            SIMD3<Float>(x: distanceVector.x, y: distanceVector.y, z: distanceVector.z),
            orientation: orientation,
            viewportSize: UIScreen.main.bounds.size
        )
        
        // Convert lookAtPoint vector to world coordinate space, from face coordinate space.
        let lookAtVector = anchor.transform * SIMD4<Float>(anchor.lookAtPoint, 1)
        
        // Project lookAtPoint into screen coordinates.
        let lookPoint = frame.camera.projectPoint(
            SIMD3<Float>(x: lookAtVector.x, y: lookAtVector.y, z: lookAtVector.z),
            orientation: orientation,
            viewportSize: UIScreen.main.bounds.size
        )
        
        let screenPoint: CGPoint
        
        switch orientation {
        case .landscapeRight:
            screenPoint = CGPoint(x: lookPoint.x + (distancePoint.x / 2), y: lookPoint.y - (distancePoint.y / 2))
        case .landscapeLeft:
            screenPoint = CGPoint(x: lookPoint.x - (distancePoint.x / 2), y: lookPoint.y - (distancePoint.y / 2))
        case .portrait:
            screenPoint = CGPoint(x: lookPoint.x, y: lookPoint.y)
        case .portraitUpsideDown:
            screenPoint = CGPoint(x: lookPoint.x + (distancePoint.x / 2), y: lookPoint.y - (distancePoint.y))
        default:
            assertionFailure("Unknown Orientation")
            return
        }
        
        // TODO: Manage screenPoint on screen
        print("POINT: \(screenPoint)")
        pointer?.move(to: screenPoint)
    }
}
