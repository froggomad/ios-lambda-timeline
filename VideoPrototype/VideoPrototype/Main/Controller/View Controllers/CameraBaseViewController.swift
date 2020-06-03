//
//  ViewController.swift
//  VideoPrototype
//
//  Created by Kenny on 6/3/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class CameraBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension CameraBaseViewController: PresentCameraUIDelegate {
    func showCamera() {
        performSegue(withIdentifier: "ShowCamera", sender: self)
    }
}
