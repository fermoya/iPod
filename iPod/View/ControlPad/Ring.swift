//
//  Ring.swift
//  iPod
//
//  Created by Fernando Moya de Rivas on 04/12/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

struct Ring: View {

    var strokeColor: Color
    var fillColor: Color
    var ratio: CGFloat

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                self.ring(center: CGPoint(x: geometry.size.width / 2,
                                          y: geometry.size.height / 2),
                          radius: min(geometry.size.width, geometry.size.height) / 2,
                          ratio: self.ratio)
                    .fill(self.fillColor)
            }
        }
    }
}

extension Ring {

    func ring(center: CGPoint, radius: CGFloat, ratio: CGFloat) -> Path {
        Path { path in
            path.addArc(center: center,
                        radius: radius,
                        startAngle: .zero,
                        endAngle: .init(radians: .pi * 2),
                        clockwise: true)

            path.addArc(center: center,
                        radius: radius * ratio,
                        startAngle: .zero,
                        endAngle: .init(radians: .pi * 2),
                        clockwise: false)

        }
    }

}

//struct Ring_Previews: PreviewProvider {
//    static var previews: some View {
//        Ring()
//    }
//}
