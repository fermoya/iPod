//
//  ContentView.swift
//  iPod
//
//  Created by Fernando Moya de Rivas on 04/12/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

struct ControlPadView: View {

    private var ringRatio: CGFloat = 1 / 3
    private var onForwardTapped: (() -> Void)?
    private var onBackwardTapped: (() -> Void)?
    private var onMenuTapped: (() -> Void)?
    private var onPlayTapped: (() -> Void)?
    private var onPauseTapped: (() -> Void)?
    private var onSpinningChanged: ((Rotation) -> Void)?
    private var onSpinningEnded: ((Rotation) -> Void)?

    @State private var isPaused = false

    var color: Color

    init(color: Color) {
        self.color = color
    }

    private var buttonRelativePosition: CGFloat {
        (1 - self.ringRatio)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Ring(fillColor: self.color,
                     ratio: self.ringRatio)
                SpinnableRing(fillColor: Color.gray,
                              ratio: self.ringRatio)
                    .onChanged ({ (rotation) in
                        withAnimation(self.animation) {
                            self.onSpinningChanged?(rotation)
                        }
                    }).onEnded({ rotation in
                        withAnimation(self.animation) {
                            self.onSpinningEnded?(rotation)
                        }
                    }).blendMode(.multiply)
                self.menuButton
                    .offset(x: 0,
                            y: -self.buttonTranslation(for: geometry.size))
                self.forwardButton
                    .offset(x: self.buttonTranslation(for: geometry.size),
                            y: 0)
                self.backwardButton
                    .offset(x: -self.buttonTranslation(for: geometry.size),
                            y: 0)
                self.playPauseButton
                    .offset(x: 0,
                            y: self.buttonTranslation(for: geometry.size))
            }
        }
    }
}

// MARK: Subviews

extension ControlPadView {

    var menuButton: some View {
        Button(action: {
            withAnimation(self.animation) {
                self.onMenuTapped?()
            }
        }) {
            Text("MENU")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
        }
    }

    var forwardButton: some View {
        Button(action: {
            withAnimation(self.animation) {
                self.onForwardTapped?()
            }
        }) {
           Image(systemName: "forward.end.alt.fill")
            .foregroundColor(.white)
            .padding().onTapGesture {
                withAnimation(self.animation) {
                    self.onForwardTapped?()
                }
            }
        }
    }

    var backwardButton: some View {
        Button(action: {
            withAnimation(self.animation) {
                self.onBackwardTapped?()
            }
        }) {
           Image(systemName: "backward.end.alt.fill")
            .foregroundColor(.white)
            .padding()
        }
    }

    var playPauseButton: some View {
        Button(action: {
            withAnimation(self.animation) {
                self.isPaused ? self.onPlayTapped?() : self.onPauseTapped?()
                self.isPaused.toggle()
            }
        }) {
           Image(systemName: "forward.end.fill")
            .foregroundColor(.white)
            .padding()
        }
    }

}

// MARK: Builder

extension ControlPadView: Buildable {

    func onSpinningEnded(_ onSpinningEnded: @escaping (Rotation) -> Void) -> Self {
        self.mutate(keyPath: \.onSpinningEnded, value: onSpinningEnded)
    }

    func onSpinningChanged(_ onSpinningChanged: @escaping (Rotation) -> Void) -> Self {
        self.mutate(keyPath: \.onSpinningChanged, value: onSpinningChanged)
    }

    func onForwardTapped(_ onForwardTapped: @escaping () -> Void) -> Self {
        self.mutate(keyPath: \.onForwardTapped, value: onForwardTapped)
    }

    func onBackwardTapped(_ onBackwardTapped: @escaping () -> Void) -> Self {
        self.mutate(keyPath: \.onBackwardTapped, value: onBackwardTapped)
    }

    func onMenuTapped(_ onMenuTapped: @escaping () -> Void) -> Self {
        self.mutate(keyPath: \.onMenuTapped, value: onMenuTapped)
    }

    func onPauseTapped(_ onPauseTapped: @escaping () -> Void) -> Self {
        self.mutate(keyPath: \.onPauseTapped, value: onPauseTapped)
    }

    func onPlayTapped(_ onPlayTapped: @escaping () -> Void) -> Self {
        self.mutate(keyPath: \.onPlayTapped, value: onPlayTapped)
    }

}

// MARK: Helper functions
extension ControlPadView {

    private var animation: Animation {
        Animation.easeOut
    }

    private func buttonTranslation(for availableSpace: CGSize) -> CGFloat {
        min(availableSpace.width, availableSpace.height) / 2 * self.buttonRelativePosition
    }

}

//struct ControlPadView_Previews: PreviewProvider {
//    static var previews: some View {
//        ControlPadView(fillColor: .red)
//    }
//}
