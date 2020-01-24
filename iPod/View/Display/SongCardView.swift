//
//  SongCardView.swift
//  iPod
//
//  Created by Fernando Moya de Rivas on 04/12/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI
import UIKit

struct SongCardView: View {

    // TODO: style
    private var color: Color { .black }
    @EnvironmentObject var styleManager: StyleManager

    var song: Song

    var body: some View {
        GeometryReader { geometry in
            VStack {
                self.albumImage(size: geometry.size)
                Spacer()
                self.songTitle
                Spacer()
            }.background(self.color)
                .clipped()
                .cornerRadius(5)
        }
    }
    
}

extension SongCardView {

    func albumImage(size: CGSize) -> some View {
        Image(song.imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: min(size.width, size.height),
                   height: min(size.width, size.height),
                   alignment: .center)
            .clipped()
    }

    var songTitle: some View {
        Text("\(song.title)-\(song.bandName)")
            .foregroundColor(styleManager.colorScheme.highlightColor)
            .multilineTextAlignment(.center)
            .padding()
    }

}

struct SongCardView_Previews: PreviewProvider {
    static var previews: some View {
        SongCardView(song: songs[1])
    }
}
