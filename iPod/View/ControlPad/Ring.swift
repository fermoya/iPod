//
//  Ring.swift
//  iPod
//
//  Created by Fernando Moya de Rivas on 04/12/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

struct Ring: Shape {
    
    var ratio: CGFloat

    func path(in rect: CGRect) -> Path {
        let radius = min(rect.width, rect.height) / 2
        let center = CGPoint(x: rect.width / 2,
                             y: rect.height / 2)
        var path = Path()
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

        return path
    }
}

struct Ring_Previews: PreviewProvider {
    static var previews: some View {
        Ring(ratio: 0.33)
    }
}
