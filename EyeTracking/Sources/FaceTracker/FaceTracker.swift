//
//  FaceTracker.swift
//  EyeTracking_Example
//
//  Created by Ilya Yushkevich on 07.05.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import ARKit

public class FaceTracker {
    var session: Session
    var expressions: [FaceExpression] = []
    
    private var lastActionDate = Date()
    private var delegates: [FaceTrackerDelegate?] = []
    
    public init(session: Session) {
        self.session = session
        session.delegates.append(self)
    }
    
    init() {
        self.session = Session()
        session.delegates.append(self)
    }
    
    public func initiateFaceExpression(_ expression: FaceExpression) {
        if expressions.first(where: { $0.blendShape == expression.blendShape }) != nil { return }
        expressions.append(expression)
    }
    
    public func removeFaceExpression(_ expression: FaceExpression) {
        expressions.removeAll { $0 == expression }
    }
    
    public func setDelegate(_ delegate: FaceTrackerDelegate?) {
        delegates.append(delegate)
    }
    
    public func removeDelegate(_ delegate: FaceTrackerDelegate?) {
        delegates = delegates.filter { $0 !== delegate }
    }
    
    func checkExpression(_ expression: FaceExpression, faceAnchor: ARFaceAnchor) -> Bool {
        guard
            let currentExpression = faceAnchor.blendShapes[expression.blendShape],
            currentExpression.floatValue.inRange(min: expression.minValue, max: expression.maxValue)
        else { return false }
        
        return true
    }
}

extension FaceTracker: SessionDelegate {
    public func sessionDidUpdate(_ session: ARSession, frame: ARFrame) {
        guard
            let faceAnchor = frame.anchors.first as? ARFaceAnchor,
            Date().timeIntervalSinceNow - lastActionDate.timeIntervalSinceNow >= 0.5
        else { return }
        lastActionDate = Date()
        expressions.forEach { expression in
            if checkExpression(expression, faceAnchor: faceAnchor) {
                delegates.forEach { delegate in
                    delegate?.faceTracker(self, didUpdateExpression: expression)
                }
            }
        }
    }
}
