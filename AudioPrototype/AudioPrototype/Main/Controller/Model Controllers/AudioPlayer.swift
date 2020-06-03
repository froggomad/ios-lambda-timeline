//
//  AudioPlayer.swift
//  AudioPrototype
//
//  Created by Kenny on 6/2/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import AVFoundation
import UIKit

protocol AudioPlayerUIDelegate: AVAudioPlayerDelegate {
    func updateUI()
}

class AudioPlayer {
    var delegate: AudioPlayerUIDelegate?
    var timer: Timer?

    init(delegate: AudioPlayerUIDelegate) {
        self.delegate = delegate
        loadAudio()
    }

    deinit {
        cancelTimer()
    }

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.030, repeats: true) { [weak self] (_) in
            guard let self = self else { return }
            self.delegate?.updateUI()
        }
    }

    func cancelTimer() {
        timer?.invalidate()
        timer = nil
        delegate?.updateUI()
    }

    ///the active Audio Player
    var player: AVAudioPlayer? {
        didSet {
            player?.delegate = delegate
        }
    }

    var isPlaying: Bool {
        return player?.isPlaying ?? false
    }

    func loadAudio() {
        guard let songURL = Bundle.main.url(forResource: "kid_laugh", withExtension: "mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: songURL)
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
        player?.play()
        startTimer()
    }

    func pause() {
        player?.pause()
        cancelTimer()
    }
}
