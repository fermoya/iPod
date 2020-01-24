//
//  SpinnableRing.swift
//  iPod
//
//  Created by Fernando Moya de Rivas on 07/12/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

extension View {
    func spinnable(onChanged: ((Rotation) -> Void)? = nil, onEnded: ((Rotation) -> Void)? = nil) -> some View {
        self.modifier(SpinnableViewModifier(onChanged: onChanged,
                                            onEnded: onEnded))
    }
}

struct SpinnableViewModifier: ViewModifier {

    fileprivate var onChanged: ((Rotation) -> Void)?
    fileprivate var onEnded: ((Rotation) -> Void)?

    @State private var rotation: Rotation = .none
    @State private var finishedSpinning = false

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .gesture(
                    DragGesture()
                        .onChanged({ (value) in
                            guard !self.finishedSpinning else { return }

                            let location = value.location.convert(to: CGPoint(x: geometry.size.width / 2,
                                                                              y: geometry.size.height / 2))

//                            let radius = min(geometry.size.width, geometry.size.height) / 2
//                            let outerCircle: Region = .circle(radius * 1.1)
//                            let innerCircle: Region = .circle(radius * self.content.ratio * 0.9)
//                            let ring = outerCircle.substract(region: innerCircle)
//
//                            self.finishedSpinning = !location.isContained(in: ring)
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
