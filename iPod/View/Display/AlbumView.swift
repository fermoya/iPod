//
//  AlbumView.swift
//  iPod
//
//  Created by Fernando Moya de Rivas on 05/12/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

struct AlbumView: View {

    private var blurRatio: CGFloat = 0.1
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
            ZStack {
                Pager(page: self.$trackIndex, pageSize: self.pageSize(geometry), data: self.tracks) {
                    SongCardView(song: $0, size: self.pageSize(geometry))
                }.pageOffset(self.pageOffset)
                    .itemShadowColor(self.shadowColor)
                    .background(self.backgroundColor)
                    .frame(width: min(geometry.size.width, geometry.size.height),
                           height: min(geometry.size.width, geometry.size.height))
                    .clipped()
                self.blurredView
                    .frame(width: geometry.size.width * self.blurRatio,
                           height: geometry.size.height)
                    .offset(x: -geometry.size.width * (1 - self.blurRatio) / 2,
                            y: 0)
                self.blurredView
                    .rotationEffect(.radians(.pi))
                    .frame(width: geometry.size.width * self.blurRatio,
                           height: geometry.size.height)
                    .offset(x: geometry.size.width * (1 - self.blurRatio) / 2,
                            y: 0)
                    
            }.cornerRadius(5)
        }.padding()
    }
}

extension AlbumView {
    
    private var gradient: Gradient {
        Gradient(stops: [
            .init(color: backgroundColor.opacity(0.5), location: 0),
            .init(color: backgroundColor.opacity(0), location: 1)])
    }
    
    private var blurredView: some View {
        Rectangle()
            .fill(LinearGradient(gradient: gradient,
                                 startPoint: .leading,
                                 endPoint: .trailing)
        )
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
