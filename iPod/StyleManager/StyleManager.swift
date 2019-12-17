//
//  StyleManager.swift
//  iPod
//
//  Created by Fernando Moya de Rivas on 12/12/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

class StyleManager: ObservableObject {

    enum ColorScheme {
        case red
        case green
        case purple
    }

    var colorScheme: ColorScheme

    public init(colorScheme: ColorScheme) {
        self.colorScheme = colorScheme
    }

}

extension StyleManager.ColorScheme {

    var primaryColor: Color {
        switch self {
        case .red:
            return .red
        case .green:
            return .green
        case .purple:
            return .purple
        }
    }

    var secondaryColor: Color {
        switch self {
        case .red:
            return Color(.sRGB, red: 0.75, green: 0.20, blue: 0.15, opacity: 1)
        case .green:
            return Color(.sRGB, red: 0.1, green: 1, blue: 0, opacity: 1)
        case .purple:
            return Color(.sRGB, red: 1, green: 0.1, blue: 1, opacity: 1)
        }
    }

    var shadowColor: Color {
        switch self {
        case .red, .green, .purple:
            return .gray
        }
    }

    var highlightColor: Color {
        switch self {
        case .red, .green, .purple:
            return .white
        }
    }

}
