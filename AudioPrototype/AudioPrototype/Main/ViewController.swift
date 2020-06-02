//
//  ViewController.swift
//  AudioPrototype
//
//  Created by Kenny on 6/2/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    ///lazy in order to ensure self is available
    lazy var audioPlayer = AudioPlayer(delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func updateViews() {
        playButton.isSelected = audioPlayer.isPlaying
        //recordButton.isSelected = audioRecorder.isRecording
    }

    @IBAction func playButtonWasTapped(_ sender: UIButton) {
        audioPlayer.togglePlaying()
        updateViews()
    }

    @IBAction func recordButtonWasTapped(_ sender: UIButton) {
        //audioRecorder.toggleRecording()
        updateViews()
    }
}

extension ViewController: AVAudioPlayerDelegate {

}
