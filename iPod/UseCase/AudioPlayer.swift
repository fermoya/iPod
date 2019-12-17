//
//  AudioPlayer.swift
//  iPod
//
//  Created by Fernando Moya de Rivas on 10/12/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import AVFoundation
import Combine

class AudioPlayer {
    
    private lazy var audioPlayer: AVAudioPlayer = {
        getAudioPlayer()
    }()
    
    private var song: String {
        songs[trackIndex].audioFileName
    }
    
    var trackIndex = 0 {
        didSet {
            print("old: \(oldValue), new: \(trackIndex)")
            audioPlayer = getAudioPlayer()
            audioPlayer.play()
        }
    }
    
    var songs: [Song]
    
    init(songs: [Song]) {
        self.songs = songs
    }
    
    private func getAudioPlayer() -> AVAudioPlayer {
        let name = String(song.split(separator: ".")[0])
        let ext = String(song.split(separator: ".")[1])
        let url = Bundle.main.path(forResource: name, ofType: ext)
        return try! AVAudioPlayer(contentsOf: URL(string: url!)!)
    }
    
    func play() {
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    func pause() {
        audioPlayer.pause()
    }
    
}
