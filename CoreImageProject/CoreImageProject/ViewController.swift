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
    @IBOutlet weak var slider1Label: UILabel!
    @IBOutlet weak var slider2Label: UILabel!
    @IBOutlet weak var slider3Label: UILabel!
    @IBOutlet weak var slider1: UISlider!
    @IBOutlet weak var slider2: UISlider!
    @IBOutlet weak var slider3: UISlider!


    private var originalImage: UIImage?

    private var inputImage: CIImage? {
        guard let originalImage = originalImage,
            let cgImage = originalImage.cgImage else { return nil }
            let ciImage = CIImage(cgImage: cgImage)
        return ciImage
    }

    private var filter: CIFilter = .gaussianBlur()
    override func viewDidLoad() {
        super.viewDidLoad()
        originalImage = UIImage(named: "ball")!
        imageView.image = originalImage
        updateViews()
    }

    private func updateViews() {
        switch filter.name {
        case "CIGaussianBlur":
            setupGaussianUI()
        default:
            break
        }
    }

    @IBAction func filterControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            filter = .gaussianBlur()
            setupGaussianFilter()
        case 1:
            filter = .checkerboardGenerator()
        default:
            break
        }
    }

    private func setupGaussianUI() {
        slider1Label.text = "Radius"
        slider1.minimumValue = 0
        slider1.maximumValue = 10

        slider2Label.text = ""
        slider2.isHidden = true

        slider3Label.text = ""
        slider3.isHidden = true

        setupGaussianFilter()
    }

    private func setupGaussianFilter() {
        let inputImageKey = "inputImage"
        let inputRadiusKey = "inputRadius"
        let filter: CIFilter = .gaussianBlur()
        filter.setValue(inputImage, forKey: inputImageKey)
        filter.setValue(slider1.value, forKey: inputRadiusKey)
        if let outputImage = filter.outputImage {
            let filteredImage = UIImage(ciImage: outputImage)
            imageView.image = filteredImage
        }
    }

    @IBAction func filterSlider1DidChange(_ sender: UISlider) {
        updateViews()
    }

    @IBAction func filterSlider2DidChange(_ sender: UISlider) {
        updateViews()
    }

    @IBAction func filterSlider3DidChange(_ sender: UISlider) {
        updateViews()
    }
    
}
