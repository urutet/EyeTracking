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
    public var delegate: FaceTrackerDelegate?
    
    public init(session: Session) {
        self.session = session
        session.delegates.append(self)
    }
    
    public func initiateFaceExpression(_ expression: FaceExpression) {
        expressions.append(expression)
    }
    
    public func removeFaceExpression(_ expression: FaceExpression) {
        expressions.removeAll { $0 == expression }
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
        guard let faceAnchor = frame.anchors.first as? ARFaceAnchor else { return }

        expressions.forEach { expression in
            if checkExpression(expression, faceAnchor: faceAnchor) {
                delegate?.faceTracker(self, didUpdateExpression: expression)
            }
        }
    }
}
