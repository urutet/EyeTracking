//
//  TrackingViewController.swift
//  EyeTracking_Example
//
//  Created by Ilya Yushkevich on 11.05.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

public class TrackingViewController: UIViewController {
    let eyeTracker = TrackingManager.shared.eyeTracker
    let faceTracker = TrackingManager.shared.faceTracker
    
    lazy var scrollView = UIScrollView()
    lazy var tableView = UITableView()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        faceTracker.initiateFaceExpression(FaceExpression(blendShape: .jawOpen, minValue: 0.4, maxValue: 1))

        eyeTracker.delegate = self
        faceTracker.delegate = self
    }
}

extension TrackingViewController: EyeTrackerDelegate, FaceTrackerDelegate {
    public func eyeTracking(_ eyeTracker: EyeTracker, didUpdateState state: EyeTracker.TrackingState, with expression: FaceExpression?) {
        switch state {
        case .screenIn(let point):
            guard let expression else { return }
            switch expression.blendShape {
            case .jawOpen:
                let sView = view.hitTest(point, with: nil)
                sView?.layer.borderWidth = 1
                sView?.layer.borderColor = UIColor.black.cgColor
            default:
                return
            }
        case .screenOut(let edge, _):
            return
        }
    }
    
    public func faceTracker(_ faceTracker: FaceTracker, didUpdateExpression expression: FaceExpression) {
        print(expression.blendShape)
        eyeTracker.delegates.forEach { delegate in
            delegate?.eyeTracking(eyeTracker, didUpdateState: eyeTracker.state, with: expression)
        }
    }
}
