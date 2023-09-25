//
//  HapticManager.swift
//  OriginalColor
//
//  Created by Lu on 2023/8/1.
//

import Foundation
import SwiftUI

class HapticManager {
    
    static let instance = HapticManager()
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
