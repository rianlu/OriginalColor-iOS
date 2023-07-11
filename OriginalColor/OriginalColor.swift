//
//  OriginalColor.swift
//  OriginalColor
//
//  Created by Lu on 2023/7/4.
//

import Foundation

struct OriginalColor: Codable {
    // CMYK 四色
    var CMYK: [Int] = [0, 0, 0, 0]
    var RGB: [Int] = [0, 0, 0]
    var hex: String = "#000000"
    var name: String = ""
    // 中文拼音
    var pinyin: String = ""
    
//    static let allColors: [OriginalColor] = Bundle.main.decode(file: "colors.json")
}

//extension Bundle {
//    func decode<T: Decodable>(file: String) -> T {
//        guard let url = self.url(forResource: file, withExtension: nil) else {
//            fatalError("Could not found  \(file)")
//        }
//        guard let data = try? Data(contentsOf: url) else {
//            fatalError("Could not found  \(file)")
//        }
//        guard let loadedData = try? JSONDecoder().decode(T.self, from: data) else {
//            fatalError("Could not found  \(file)")
//        }
//        return loadedData
//    }
//}

extension Bundle {
    func decode<T: Decodable>(file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Could not decode \(file) from bundle.")
        }
        
        return loadedData
    }
}
