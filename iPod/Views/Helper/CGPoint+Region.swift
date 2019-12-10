//
//  CGPoint+Region.swift
//  iPod
//
//  Created by Fernando Moya de Rivas on 09/12/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import CoreGraphics

extension CGPoint {

    func isContained(in region: Region) -> Bool {
        region.lookUp(self)
    }

}
