//
//  DataService.swift
//  ColorWidgetExtension
//
//  Created by lu on 2023/9/25.
//

import Foundation
import SwiftUI

struct DataService {
    @AppStorage("themeColor",
                store: UserDefaults(suiteName: "group.com.wzl.originalcolor")) 
    var savedThemeColor: String = "#f86b1d"
    @Environment(\.colorScheme) var colorScheme
    private var colorList: [OriginalColor] = []

    init() {
        colorList = ReadData().colors
    }
    
    func getWidgetColor() -> OriginalColor {
        return colorList.first {
            $0.hex == savedThemeColor
        } ?? getRandomColor()
    }
    
    func getRandomColor() -> OriginalColor {
        return colorList[Int.random(in: 0..<colorList.count)]
    }
}
