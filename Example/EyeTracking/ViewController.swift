//
//  ViewController.swift
//  EyeTracking
//
//  Created by Ilya Yushkevich on 04/30/2023.
//  Copyright (c) 2023 Ilya Yushkevich. All rights reserved.
//

import UIKit
import ARKit

class ViewController: TrackingViewController {
    
    let button: UIButton = {
        let button = UIButton()
        
        button.setTitle("qwerty", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 400),
            button.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
}
