//
//  ColorUtils.swift
//  OriginalColor
//
//  Created by Lu on 2023/7/7.
//

import Foundation
import SwiftUI

class ColorUtils {
    
}

extension Color {
    func getHsb() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        var hue: CGFloat  = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        let uiColor = UIColor(self)
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return (hue, saturation, brightness, alpha)
    }
    
    func isLight() -> Bool {
        guard let components = cgColor?.components, components.count > 2 else {return false}
        let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
        return (brightness > 0.5)
    }
    
    func adjust(hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, opacity: CGFloat = 1) -> Color {
            let color = UIColor(self)
            var currentHue: CGFloat = 0
            var currentSaturation: CGFloat = 0
            var currentBrigthness: CGFloat = 0
            var currentOpacity: CGFloat = 0

            if color.getHue(&currentHue, saturation: &currentSaturation, brightness: &currentBrigthness, alpha: &currentOpacity) {
                return Color(hue: currentHue + hue, saturation: currentSaturation + saturation, brightness: currentBrigthness + brightness, opacity: currentOpacity + opacity)
            }
            return self
        }
}
