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
}

let songs = [
    Song(title: "Welcome to the jungle", bandName: "Guns & Roses", imageName: "guns&roses"),
    Song(title: "I want to break free", bandName: "Queen", imageName: "guns&roses"),
    Song(title: "I like it", bandName: "Cardi B - Bad Bunny & J Balvin", imageName: "guns&roses"),
    Song(title: "Dirty Old Town", bandName: "The Dubliners", imageName: "guns&roses"),
    Song(title: "Feliz Navidad", bandName: "Jose Feliciano", imageName: "guns&roses"),
    Song(title: "Il mondo", bandName: "Jimmy Fontana", imageName: "guns&roses"),
    Song(title: "Macarena", bandName: "Los del río", imageName: "guns&roses")
]
