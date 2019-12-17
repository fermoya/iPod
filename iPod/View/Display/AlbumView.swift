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
    private var cardAspectRatio: CGFloat = 9 / 16
    private var onPageChanged: ((Int) -> Void)?

    @Binding var trackIndex: Int
    @Binding var pageOffset: Double
    @EnvironmentObject var styleManager: StyleManager

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
                    .itemShadowColor(self.styleManager.colorScheme.shadowColor)
                    .onPageChanged(self.onPageChanged)
                    .background(self.styleManager.colorScheme.highlightColor)
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
            .init(color: styleManager.colorScheme.highlightColor.opacity(0.5), location: 0),
            .init(color: styleManager.colorScheme.highlightColor.opacity(0), location: 1)])
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

    func onPageChanged(_ onPageChanged: ((Int) -> Void)?) -> Self {
        mutate(keyPath: \.onPageChanged, value: onPageChanged)
    }

}

//struct AlbumView_Previews: PreviewProvider {
//    static var previews: some View {
//        AlbumView()
//    }
//}
