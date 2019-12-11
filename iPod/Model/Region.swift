//
//  Region.swift
//  iPod
//
//  Created by Fernando Moya de Rivas on 09/12/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import CoreGraphics

struct Region {
    var lookUp: (CGPoint) -> Bool
}

extension Region {

    static func circle(_ radius: CGFloat) -> Region {
        Region { $0.length <= radius }
    }

    func substract(region: Region) -> Region {
        Region {
            self.lookUp($0) && !region.lookUp($0)
        }
    }

}

extension CGPoint {
    var length: CGFloat {
        sqrt(x * x + y * y)
    }
}
