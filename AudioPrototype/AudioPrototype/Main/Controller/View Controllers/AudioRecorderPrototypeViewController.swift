//
//  ViewController.swift
//  AudioPrototype
//
//  Created by Kenny on 6/2/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit
import AVFoundation

class AudioRecorderPrototypeViewController: UIViewController {
    // MARK: - Outlets -
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var timeElapsedLabel: UILabel!

    // MARK: - Properties -
    //lazy to ensure self is available
    lazy var audioRecorder = RecordingController(delegate: self)

    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Use a font that won't jump around as values change
        timeElapsedLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeElapsedLabel.font.pointSize,
                                                                 weight: .regular)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        try? audioRecorder.prepareAudioSession()
        updateViews()
    }

    private func updateViews() {
        recordButton.isSelected = audioRecorder.isRecording
        displayElapsedTime()
    }

    private func displayElapsedTime() {
        let elapsedTime = audioRecorder.recorder?.currentTime ?? 0
        timeElapsedLabel.text = audioRecorder.timeIntervalFormatter.string(from: elapsedTime)
    }

    
    // MARK: - Actions
    @IBAction func updateCurrentTime(_ sender: UISlider) {

    }

    @IBAction func toggleRecording(_ sender: Any) {
        audioRecorder.toggleRecording()
    }
}

extension AudioRecorderPrototypeViewController: RecordingUIDelegate {
    func updateUI() {
        updateViews()
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if let recordingURL = audioRecorder.recordingURL {
            print("Finished Recording: \(recordingURL.path)")
        }
    }

    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Error recording: \(error)")
        }
    }
}
