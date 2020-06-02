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
    var timer: Timer?

    init(delegate: AVAudioPlayerDelegate) {
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
            if let delegate = self.delegate as? CommentPlaybackCell {
                delegate.updateViews()
            }
        }
    }

    func cancelTimer() {
        timer?.invalidate()
        timer = nil
        if let delegate = self.delegate as? AudioPrototypeViewController {
            delegate.updateViews()
        }
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
