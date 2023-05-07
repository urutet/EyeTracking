//
//  EyeTracking.swift
//  EyeTracking_Example
//
//  Created by Ilya Yushkevich on 30.04.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import ARKit
import simd

public class EyeTracker {
    public enum TrackingState {
        case screenIn(CGPoint)
        case screenOut(Edge, CGPoint)
    }
    
    public enum Edge {
        case top
        case bottom
        case left
        case right
    }
    
    var session: Session
    var pointer: Pointer?
    public var delegate: EyeTrackerDelegate?
    public var screenDisplacement: Float = 0.043
    
    private var positionLogs: [CGPoint] = []
    private(set) var state: TrackingState = .screenIn(CGPoint(x: 0, y: 0))
    private var lastUsedPositonLogIndex: Int = 0

    
    public init(session: Session = Session()) {
        self.session = session
        session.delegates.append(self)
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
    
    func getGazePosition(frame: ARFrame, viewport: CGSize) -> CGPoint? {
        guard let faceAnchor = frame.anchors.first as? ARFaceAnchor else { return nil }
        
        let rightEyeSimdTransform = simd_mul(faceAnchor.transform, faceAnchor.rightEyeTransform)
        let leftEyeSimdTransform = simd_mul(faceAnchor.transform, faceAnchor.leftEyeTransform)
        
        var cameraTransform = frame.camera.transform
        
        var translation = matrix_identity_float4x4
        let p1 = cameraTransform.position
        translation.columns.3.x = 1.0
        cameraTransform = simd_mul(cameraTransform, translation)
        let p2 = cameraTransform.position
        translation = matrix_identity_float4x4
        translation.columns.3.y = 1.0
        cameraTransform = simd_mul(cameraTransform, translation)
        let p3 = cameraTransform.position
        
        let plane = Plane(p1: p1, p2: p2, p3: p3)
        let rightRay = Ray(origin: rightEyeSimdTransform.position,
                           direction: -rightEyeSimdTransform.frontVector)
        let leftRay = Ray(origin: leftEyeSimdTransform.position,
                          direction: -leftEyeSimdTransform.frontVector)
        
        translation = matrix_identity_float4x4
        translation.columns.3.z = rightRay.dist(with: plane) - screenDisplacement
        let rightEyeEndSimdTransform = simd_mul(rightEyeSimdTransform, translation)
        translation.columns.3.z = leftRay.dist(with: plane) - screenDisplacement
        let leftEyeEndSimdTransform = simd_mul(leftEyeSimdTransform, translation)
        
        let eyesMidPoint = (rightEyeEndSimdTransform.position + leftEyeEndSimdTransform.position) / 2
        
        let screenPos = frame.camera.projectPoint(eyesMidPoint, orientation: .portrait, viewportSize: viewport)
        let smoothPos = smoothingPosition(with: screenPos)
        
        return smoothPos
    }
}

extension EyeTracker: SessionDelegate {
    public func sessionDidUpdate(_ session: ARSession, frame: ARFrame) {
        let viewport = UIScreen.main.bounds.size
        
        guard let smoothPos = getGazePosition(frame: frame, viewport: viewport) else { return }
        
        if UIScreen.main.bounds.contains(smoothPos) {
            state = .screenIn(smoothPos)
        } else {
            switch (smoothPos.x, smoothPos.y) {
            case (_, ...0):
                state = .screenOut(.top, smoothPos)
            case (_, viewport.height...):
                state = .screenOut(.bottom, smoothPos)
            case (...0, _):
                state = .screenOut(.left, smoothPos)
            case (viewport.width..., _):
                state = .screenOut(.right, smoothPos)
            default:
                fatalError("Invalid state")
            }
        }
        
        delegate?.eyeTracking(self, didUpdateState: state)
        
        pointer?.move(to: smoothPos)
    }
    
    private func smoothingPosition(with newPosition: CGPoint) -> CGPoint {
        let logLimit = 10
        if positionLogs.count >= logLimit {
            if lastUsedPositonLogIndex > logLimit - 1 {
                lastUsedPositonLogIndex = 0
            }
            positionLogs[lastUsedPositonLogIndex] = newPosition
            lastUsedPositonLogIndex += 1
        } else {
            positionLogs.append(newPosition)
        }
        
        let sum = positionLogs.reduce(into: CGPoint.zero) { sum, point in
            sum.x += point.x
            sum.y += point.y
        }
        let count = CGFloat(positionLogs.count)
        
        return CGPoint(x: sum.x / count, y: sum.y / count)
    }
}
