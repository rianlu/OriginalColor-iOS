//
//  ReadData.swift
//  OriginalColor
//
//  Created by Lu on 2023/7/5.
//

import Foundation

class ReadData: ObservableObject {
    
    @Published var colors: [OriginalColor] = []
    
    init() {
        loadData()
    }
    
    func loadData() {
        self.colors = loadJson(fileName: "colors") + loadJson(fileName: "cfs-color")
    }
    
    func loadJson(fileName: String) -> [OriginalColor] {
        guard let file = Bundle.main.url(forResource: fileName, withExtension: "json")
            else {
                print("Json file not found")
                return []
            }
        let data = try? Data(contentsOf: file)
        return (try? JSONDecoder().decode([OriginalColor].self, from: data!)) ?? []
    }
}
