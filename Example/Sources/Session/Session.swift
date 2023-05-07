//
//  Session.swift
//  EyeTracking_Example
//
//  Created by Ilya Yushkevich on 30.04.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import ARKit

public class Session: NSObject {
    public let arSession = ARSession()
    public var isSessionInProgress = false
    public private(set) var startTime = Date().timeIntervalSince1970
    public private(set) var endTime: TimeInterval?
    
    public var delegates: [SessionDelegate] = []
    
    var faceTrackingConfiguration = {
        let config = ARFaceTrackingConfiguration()
        
        config.maximumNumberOfTrackedFaces = ARFaceTrackingConfiguration.supportedNumberOfTrackedFaces
        config.worldAlignment = .camera
        
        return config
    }()
    
    /**
     Start AR session with given or default ``ARFaceTrackingConfiguration`` and ``ARSession.RunOptions``.
     - Parameters:
     - parameter config: Face tracking configuration.
     - parameter options: Session options.
     
     */
    public func start(with config: ARFaceTrackingConfiguration? = nil,
                             options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]) throws {
        guard ARFaceTrackingConfiguration.isSupported else { throw SessionError.arNotSupported }
        
        if isSessionInProgress { return }
        
        if let config {
            faceTrackingConfiguration = config
        }
        
        arSession.delegate = self
        arSession.run(faceTrackingConfiguration, options: options)
        
        isSessionInProgress = true
    }
    
    /**
     End current AR session.
     */
    public func end() throws {
        guard isSessionInProgress else { throw SessionError.noSessionsInProgress }
        
        arSession.pause()
        endTime = Date().timeIntervalSince1970
        isSessionInProgress = false
    }
    
    deinit {
        #warning("Implement logger after session dealloc.")
    }
}

extension Session: ARSessionDelegate {
    public func session(_ session: ARSession, didUpdate frame: ARFrame) {
        delegates.forEach { delegate in
            delegate.sessionDidUpdate(session, frame: frame)
        }
    }
}
