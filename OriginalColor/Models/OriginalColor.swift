//
//  OriginalColor.swift
//  OriginalColor
//
//  Created by Lu on 2023/7/4.
//

import Foundation
import SwiftUI

struct OriginalColor: Codable {
    // CMYK 四色
    var CMYK: [Int] = [0, 0, 0, 0]
    var RGB: [Int] = [0, 0, 0]
    var hex: String = "#000000"
    var name: String = ""
    // 中文拼音
    var pinyin: String = ""
    
    func getRGBColor() -> Color {
        return Color(red: getR(), green: getG(), blue: getB())
    }
    
    func getRGB() -> (Double, Double, Double) {
        return (getR(), getG(), getB())
    }
    
    func getR() -> Double {
        if RGB.count != 3 {
            return 0.0
        } else {
            return Double(RGB[0]) / 255
        }
    }
    
    func getG() -> Double {
        if RGB.count != 3 {
            return 0.0
        } else {
            return Double(RGB[1]) / 255
        }
    }
    
    func getB() -> Double {
        if RGB.count != 3 {
            return 0.0
        } else {
            return Double(RGB[2]) / 255
        }
    }
    
    func getRGBString() -> String {
        if RGB.count != 3 {
            return "0, 0, 0"
        } else {
            return "\(RGB[0]) | \(RGB[1]) | \(RGB[2])"
        }
    }
    
    func getCMYKString() -> String {
        if CMYK.count != 4 {
            return "0, 0, 0, 0"
        } else {
            return "\(CMYK[0]) | \(CMYK[1]) | \(CMYK[2]) | \(CMYK[3])"
        }
    }
}
