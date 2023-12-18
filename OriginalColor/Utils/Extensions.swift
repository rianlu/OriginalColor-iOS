//
//  ColorUtils.swift
//  OriginalColor
//
//  Created by Lu on 2023/7/7.
//

import Foundation
import SwiftUI

public extension Color {
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
    
    static func blend(color1: UIColor, intensity1: CGFloat = 0.5, color2: UIColor, intensity2: CGFloat = 0.5) -> Color {
            let total = intensity1 + intensity2
            let l1 = intensity1/total
            let l2 = intensity2/total
            guard l1 > 0 else { return Color(color2)}
            guard l2 > 0 else { return Color(color1)}
            var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)

            color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
            color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

            return Color(UIColor(red: l1*r1 + l2*r2, green: l1*g1 + l2*g2, blue: l1*b1 + l2*b2, alpha: l1*a1 + l2*a2))
        }
    
    init(hex:String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            self.init(red: 0, green: 0, blue: 0)
        }
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            opacity: CGFloat(1.0)
        )
    }
}
