//
//  Song.swift
//  iPod
//
//  Created by Fernando Moya de Rivas on 05/12/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

struct Song: Identifiable, Equatable {
    var id: String { return title + bandName }
    var title: String
    var bandName: String
    var imageName: String
    var audioFileName: String
}

let songs = [
    Song(title: "Welcome to the jungle", bandName: "Guns & Roses", imageName: "guns&roses", audioFileName: "sample.wav"),
    Song(title: "I want to break free", bandName: "Queen", imageName: "queen", audioFileName: "sample.wav"),
    Song(title: "I like it", bandName: "Cardi B - Bad Bunny & J Balvin", imageName: "cardi-b", audioFileName: "sample.wav"),
    Song(title: "Dirty Old Town", bandName: "The Dubliners", imageName: "the-dubliners", audioFileName: "sample.wav"),
    Song(title: "Feliz Navidad", bandName: "Jose Feliciano", imageName: "jose-feliciano", audioFileName: "sample.wav"),
    Song(title: "Il mondo", bandName: "Jimmy Fontana", imageName: "jimmy-fontana", audioFileName: "sample.wav"),
    Song(title: "Macarena", bandName: "Los del río", imageName: "los-del-rio", audioFileName: "sample.wav")
]
