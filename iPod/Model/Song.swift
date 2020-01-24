//
//  Song.swift
//  iPod
//
//  Created by Fernando Moya de Rivas on 05/12/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

struct Song: Identifiable, Equatable, CustomStringConvertible {
    var id: Int
    var title: String
    var bandName: String
    var imageName: String
    var audioFileName: String

    var description: String {
        return String(id)
    }
}

let songs = [
    Song(id: 0, title: "Welcome to the jungle", bandName: "Guns & Roses", imageName: "guns&roses", audioFileName: "sample.wav"),
    Song(id: 1, title: "I want to break free", bandName: "Queen", imageName: "queen", audioFileName: "sample.wav"),
    Song(id: 2, title: "I like it", bandName: "Cardi B - Bad Bunny & J Balvin", imageName: "cardi-b", audioFileName: "sample.wav"),
    Song(id: 3, title: "Dirty Old Town", bandName: "The Dubliners", imageName: "the-dubliners", audioFileName: "sample.wav"),
    Song(id: 4, title: "Feliz Navidad", bandName: "Jose Feliciano", imageName: "jose-feliciano", audioFileName: "sample.wav"),
    Song(id: 5, title: "Il mondo", bandName: "Jimmy Fontana", imageName: "jimmy-fontana", audioFileName: "sample.wav"),
    Song(id: 6, title: "Macarena", bandName: "Los del río", imageName: "los-del-rio", audioFileName: "sample.wav")
]
