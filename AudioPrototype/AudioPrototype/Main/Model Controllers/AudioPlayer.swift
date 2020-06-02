//
//  AudioPlayer.swift
//  AudioPrototype
//
//  Created by Kenny on 6/2/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import AVFoundation

class AudioPlayer {
    var delegate: AVAudioPlayerDelegate?

    init(delegate: AVAudioPlayerDelegate) {
        self.delegate = delegate
        loadAudio()
    }

    ///the active Audio Player
    var audioPlayer: AVAudioPlayer? {
        didSet {
            audioPlayer?.delegate = delegate
        }
    }

    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }

    func loadAudio() {
        guard let songURL = Bundle.main.url(forResource: "kid_laugh", withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: songURL)
        } catch let audioError {
            print("Error loading audio file: \(audioError)")
        }

    }

    func togglePlaying() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }

    func play() {
        audioPlayer?.play()
//        startTimer()
//        updateViews()
    }

    func pause() {
        audioPlayer?.pause()
//        cancelTimer()
//        updateViews()
    }
}
