//
//  AlbumView.swift
//  iPod
//
//  Created by Fernando Moya de Rivas on 05/12/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

struct AlbumView: View {

    private var backgroundColor: Color = .clear
    private var shadowColor: Color = .white
    private var cardAspectRatio: CGFloat = 9 / 16

    @Binding var trackIndex: Int
    @Binding var pageOffset: Double

    var tracks: [Song]

    init(trackIndex: Binding<Int>, pageOffset: Binding<Double>, tracks: [Song]) {
        self._trackIndex = trackIndex
        self._pageOffset = pageOffset
        self.tracks = tracks
    }

    var body: some View {
        GeometryReader { geometry in
            Pager(page: self.$trackIndex, pageSize: self.pageSize(geometry), data: self.tracks) {
                SongCardView(song: $0, size: self.pageSize(geometry))
            }.pageOffset(self.pageOffset)
                .itemShadowColor(self.shadowColor)
                .background(self.backgroundColor)
                .frame(width: min(geometry.size.width, geometry.size.height),
                       height: min(geometry.size.width, geometry.size.height))
                .clipped()
        }.padding()
    }
}

extension AlbumView: Buildable {

    func pageSize(_ geometry: GeometryProxy) -> CGSize {
        CGSize(width: min(geometry.size.width, geometry.size.height) * self.cardAspectRatio,
               height: min(geometry.size.width, geometry.size.height))
    }

    func background(_ background: Color, alignment: Alignment = .center) -> Self {
        mutate(keyPath: \.backgroundColor, value: background)
    }

    func cardShadowColor(_ color: Color) -> Self {
        mutate(keyPath: \.shadowColor, value: color)
    }

}

//struct AlbumView_Previews: PreviewProvider {
//    static var previews: some View {
//        AlbumView()
//    }
//}
