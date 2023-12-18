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
    
    func getWidgetColor() -> OriginalColor {
        let colorList = ReadData().colors
        return colorList.first {
            $0.hex == savedThemeColor
        } ?? colorList[Int.random(in: 0..<colorList.count)]
    }
}