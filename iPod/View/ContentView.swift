//
//  ContentView.swift
//  iPod
//
//  Created by Fernando Moya de Rivas on 04/12/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {

    @State private var trackIndex = 0 {
        didSet {
            trackSubject.send(trackIndex)
        }
    }
    @State private var pageOffset: Double = 0
    @State private var trackSubject = CurrentValueSubject<Int, Never>(0)
    @State var cancelable: AnyCancellable!

    @EnvironmentObject var styleManager: StyleManager

    var audioPlayer = AudioPlayer(songs: songs)

    var body: some View {
        ZStack {
            Rectangle()
                .fill(styleManager.colorScheme.primaryColor)
                .edgesIgnoringSafeArea(.all)
            VStack {
                AlbumView(trackIndex: $trackIndex,
                          pageOffset: $pageOffset,
                          tracks: songs)
                    .onPageChanged({
                        self.trackSubject.send($0)
                    })
                
                ControlPadView()
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
                    }).onSpinningEnded({ _ in
                        let newPage = self.trackIndex + Int(-self.pageOffset.rounded())
                        self.trackIndex = max(0, min(newPage, songs.count - 1))
                        self.pageOffset = 0
                    }).onPlayTapped ({
                        self.audioPlayer.play()
                    }).onPauseTapped ({
                        self.audioPlayer.pause()
                    })
                    .padding()
            }.background(self.styleManager.colorScheme.primaryColor)
        }.onAppear {
            self.cancelable = self.trackSubject.assign(to: \AudioPlayer.trackIndex, on: self.audioPlayer)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
