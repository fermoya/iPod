//
//  SpinnableRing.swift
//  iPod
//
//  Created by Fernando Moya de Rivas on 07/12/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

struct SpinnableRing: View {

    var strokeColor: Color
    var fillColor: Color
    var ratio: CGFloat

    fileprivate var onChanged: ((Rotation) -> Void)?
    fileprivate var onEnded: ((Rotation) -> Void)?

    @State private var rotation: Rotation = .none
    @State private var finishedSpinning = false

    init(strokeColor: Color, fillColor: Color, ratio: CGFloat) {
        self.strokeColor = strokeColor
        self.fillColor = fillColor
        self.ratio = ratio
    }

    var body: some View {
        GeometryReader { geometry in
            Ring(strokeColor: self.strokeColor,
                 fillColor: self.fillColor,
                 ratio: self.ratio)
                .gesture(
                    DragGesture()
                        .onChanged({ (value) in
                            guard !self.finishedSpinning else { return }

                            let location = value.location.convert(to: CGPoint(x: geometry.size.width / 2,
                                                                              y: geometry.size.height / 2))

                            let radius = min(geometry.size.width, geometry.size.height) / 2
                            let outerCircle: Region = .circle(radius * 1.1)
                            let innerCircle: Region = .circle(radius * self.ratio * 0.9)
                            let ring = outerCircle.substract(region: innerCircle)

                            self.finishedSpinning = !location.isContained(in: ring)
                            self.rotation = self.rotation.addNewEntry(angle: location.angle, time: value.time)
                            self.onChanged?(self.rotation)
                        }).onEnded({ value in
                            self.onEnded?(self.rotation)
                            self.rotation = .none
                            self.finishedSpinning = false
                        })
            )
        }

    }
}

// MARK: Builder

extension SpinnableRing: Buildable {

    func onChanged(_ onChanged: @escaping (Rotation) -> Void) -> Self {
        self.mutate(keyPath: \.onChanged, value: onChanged)
    }

    func onEnded(_ onEnded: @escaping (Rotation) -> Void) -> Self {
        self.mutate(keyPath: \.onEnded, value: onEnded)
    }

}


// MARK: Helper

extension SpinnableRing {

    private func angle(at location: CGPoint, coordinateSpace: CGPoint) -> Angle {
        let location = location
            .applying(CGAffineTransform(translationX: -coordinateSpace.x,
                                        y: -coordinateSpace.y)
                .concatenating(CGAffineTransform(scaleX: 1,
                                                 y: -1)))
        var angle = atan(location.y / location.x) * 180 / .pi
        angle = (location.x < 0 && location.y < 0) ? angle + 180 : angle
        angle = angle < 0 ? (location.y < 0 ? 360 + angle : 180 + angle) : angle
        return .init(degrees: Double(angle))
    }

}
