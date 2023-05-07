//
//  EyeTrackingDelegate.swift
//  EyeTracking_Example
//
//  Created by Ilya Yushkevich on 07.05.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

public protocol EyeTrackerDelegate {
    func eyeTracking(_ eyeTracker: EyeTracker, didUpdateState: EyeTracker.TrackingState)
}
