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
        @IBOutlet var recordButton: UIButton!
        @IBOutlet var timeElapsedLabel: UILabel!

        private var timer: Timer?
        private lazy var timeIntervalFormatter: DateComponentsFormatter = {
            // NOTE: DateComponentFormatter is good for minutes/hours/seconds
            // DateComponentsFormatter is not good for milliseconds, use DateFormatter instead)

            let formatting = DateComponentsFormatter()
            formatting.unitsStyle = .positional // 00:00  mm:ss
            formatting.zeroFormattingBehavior = .pad
            formatting.allowedUnits = [.minute, .second]
            return formatting
        }()

        var isRecording: Bool {
            audioRecorder?.isRecording ?? false
        }

        // MARK: - View Controller Lifecycle

        override func viewDidLoad() {
            super.viewDidLoad()
            // Use a font that won't jump around as values change
            timeElapsedLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeElapsedLabel.font.pointSize,
                                                                     weight: .regular)
        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            try? prepareAudioSession()
            updateViews()
        }

        deinit {
            cancelTimer()
        }

        func prepareAudioSession() throws {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
            try session.setActive(true, options: []) // can fail if on a phone call, for instance
        }

        // MARK: - Timer
        func startTimer() {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.030, repeats: true) { [weak self] (_) in
                guard let self = self else { return }
                self.updateViews()
                //            if let audioRecorder = self.audioRecorder,
                //                self.isRecording == true {
                //
                //                audioRecorder.updateMeters()
                //                self.audioVisualizer.addValue(decibelValue: audioRecorder.averagePower(forChannel: 0))
                //
                //            }
                //
                //            if let audioPlayer = self.audioPlayer,
                //                self.isPlaying == true {
                //
                //                audioPlayer.updateMeters()
                //                self.audioVisualizer.addValue(decibelValue: audioPlayer.averagePower(forChannel: 0))
                //            }
            }
        }
        func cancelTimer() {
            timer?.invalidate()
            timer = nil
        }
        private func updateViews() {
            recordButton.isSelected = isRecording
            displayElapsedTime()
        }

        private func displayElapsedTime() {
            let elapsedTime = audioRecorder?.currentTime ?? 0
            timeElapsedLabel.text = timeIntervalFormatter.string(from: elapsedTime)
        }


        // MARK: - Recording
        var recordingURL: URL?
        var audioRecorder: AVAudioRecorder?

        func createNewRecordingURL() -> URL {
            let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

            let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
            let file = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")

            print("recording URL: \(file)")

            return file
        }


        func requestPermissionOrStartRecording() {
            switch AVAudioSession.sharedInstance().recordPermission {
            case .undetermined:
                AVAudioSession.sharedInstance().requestRecordPermission { granted in
                    guard granted == true else {
                        print("We need microphone access")
                        return
                    }

                    print("Recording permission has been granted!")
                    // NOTE: Invite the user to tap record again, since we just interrupted them, and they may not have been ready to record
                }
            case .denied:
                print("Microphone access has been blocked.")

                let alertController = UIAlertController(title: "Microphone Access Denied", message: "Please allow this app to access your Microphone.", preferredStyle: .alert)

                alertController.addAction(UIAlertAction(title: "Open Settings", style: .default) { (_) in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                })

                alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))

                present(alertController, animated: true, completion: nil)
            case .granted:
                startRecording()
            @unknown default:
                break
            }
        }

        func toggleRecording() {
            if isRecording {
                stopRecording()
            } else {
                requestPermissionOrStartRecording()
            }
            updateViews()
        }

        func startRecording() {
            let recordingURL = createNewRecordingURL()

            let audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
            audioRecorder = try? AVAudioRecorder(url: recordingURL, format: audioFormat)
            //audioRecorder?.delegate = self
            audioRecorder?.record()
            self.recordingURL = createNewRecordingURL()
        }

        func stopRecording() {
            updateViews()
            audioRecorder?.stop()
        }

        // MARK: - Actions

        @IBAction func updateCurrentTime(_ sender: UISlider) {

        }

        @IBAction func toggleRecording(_ sender: Any) {
            toggleRecording()
        }
}

extension AudioRecorderPrototypeViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if let recordingURL = recordingURL {
            print("Finished Recording: \(recordingURL.path)")
        }
    }

    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Error recording: \(error)")
        }
    }
}
