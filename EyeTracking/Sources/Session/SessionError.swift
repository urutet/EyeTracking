//
//  SessionError.swift
//  EyeTracking_Example
//
//  Created by Ilya Yushkevich on 30.04.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation

enum SessionError: Error {
    case arNotSupported
    case noSessionsInProgress
}
