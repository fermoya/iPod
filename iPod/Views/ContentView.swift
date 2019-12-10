//
//  ContentView.swift
//  iPod
//
//  Created by Fernando Moya de Rivas on 04/12/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @State private var trackIndex = 0
    @State private var pageOffset: Double = 0

    var backgroundColor: Color = .red
    var displayColor: Color = .white
    var shadowColor: Color = .gray

    var body: some View {
        VStack {
            AlbumView(trackIndex: $trackIndex,
                      pageOffset: $pageOffset,
                      tracks: songs)
                .background(displayColor)
                .cardShadowColor(shadowColor)
            ControlPadView(color: backgroundColor)
                .onForwardTapped ({
                    guard self.trackIndex < (songs.count - 1) else { return }
                    self.trackIndex += 1
                }).onBackwardTapped ({
                    guard self.trackIndex > 0 else { return }
                    self.trackIndex -= 1
                }).onSpinningChanged({ rotation in
                    //TODO: This isn't working as expected
                    let newPageOffset = -(rotation.laps + rotation.velocity / 10)
                    self.pageOffset = abs(newPageOffset) > abs(self.pageOffset) || rotation.hasChangedDirection ? newPageOffset : self.pageOffset
                    print(self.pageOffset)
                }).onSpinningEnded({ _ in
                    let newPage = self.trackIndex + Int(-self.pageOffset.rounded())
                    self.trackIndex = max(0, min(newPage, songs.count - 1))
                    self.pageOffset = 0
                })
                .padding()
        }.background(backgroundColor)
            .cornerRadius(5)
            .edgesIgnoringSafeArea(.vertical)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
