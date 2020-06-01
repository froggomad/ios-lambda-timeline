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


    private var originalImage: UIImage?
    private var filter: CIFilter = .gaussianBlur()
    override func viewDidLoad() {
        super.viewDidLoad()
        originalImage = UIImage(named: "ball")!
        imageView.image = originalImage
    }
    private func updateViews() {

    }
    @IBAction func filterControl(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
    }

    @IBAction func filterSlider1(_ sender: UISlider) {
        print(sender.value)
        updateViews()
    }

    @IBAction func filterSlider2(_ sender: UISlider) {
        print(sender.value)
        updateViews()
    }

    @IBAction func filterSlider3(_ sender: UISlider) {
        print(sender.value)
        updateViews()
    }
    

}

