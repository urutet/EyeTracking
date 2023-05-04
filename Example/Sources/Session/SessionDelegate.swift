//
//  SessionDelegate.swift
//  EyeTracking_Example
//
//  Created by Ilya Yushkevich on 30.04.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import ARKit

public protocol SessionDelegate {
    
    /**
     Method responsible for any frame updates from ARSession.
     - Parameters:
     - parameter session: Represents ``ARSession`` in progress. Its status can be checked with ``isSessionInProgress`` property in ``Session`` class.
     - parameter frame: Updated ``ARFrame``.
     */
    func sessionDidUpdate(_ session: ARSession, frame: ARFrame)

}
