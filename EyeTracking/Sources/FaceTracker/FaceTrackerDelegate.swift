//
//  FaceTrackerDelegate.swift
//  EyeTracking_Example
//
//  Created by Ilya Yushkevich on 07.05.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

public protocol FaceTrackerDelegate {
    func faceTracker(_ faceTracker: FaceTracker, didUpdateExpression expression: FaceExpression)
}
