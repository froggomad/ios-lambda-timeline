//
//  ViewController.swift
//  CoreImageProject
//
//  Created by Kenny on 6/1/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

class ViewController: UIViewController {

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet weak var filterControl: UISegmentedControl!
    @IBOutlet private var slider1: UISlider!
    @IBOutlet private var slider2: UISlider!
    @IBOutlet private var slider3: UISlider!

    private var originalImage: UIImage?
    private var filter: CIFilter = .gaussianBlur()
    override func viewDidLoad() {
        super.viewDidLoad()
        originalImage = UIImage(named: "ball")!
        imageView.image = originalImage
    }


}

