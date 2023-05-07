//
//  ViewController.swift
//  EyeTracking
//
//  Created by Ilya Yushkevich on 04/30/2023.
//  Copyright (c) 2023 Ilya Yushkevich. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController{
    

    let faceTracker = FaceTracker(session: (UIApplication.shared.delegate as! AppDelegate).session)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        faceTracker.delegate = self
        faceTracker.initiateFaceExpression(FaceExpression(blendShape: .eyeBlinkLeft, minValue: 0.4, maxValue: 1))
    }
    
}

extension ViewController: FaceTrackerDelegate {
    func faceTracker(_ faceTracker: FaceTracker, didUpdateExpression expression: FaceExpression) {
        print(expression.blendShape)
    }
}

