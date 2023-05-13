//
//  TrackingManager.swift
//  EyeTracking_Example
//
//  Created by Ilya Yushkevich on 11.05.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//


public class TrackingManager {
    static let shared = TrackingManager()
    
    var eyeTracker = EyeTracker()
    var faceTracker = FaceTracker()
    
    private init() { }
    
    public func start(with session: Session) {
        eyeTracker = EyeTracker(session: session)
        faceTracker = FaceTracker(session: session)
    }
}
