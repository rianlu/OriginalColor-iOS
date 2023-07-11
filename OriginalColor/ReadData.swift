//
//  ReadData.swift
//  OriginalColor
//
//  Created by Lu on 2023/7/5.
//

import Foundation

class ReadData: ObservableObject {
    
    @Published var colors = [OriginalColor]()
    
    init() {
        loadData()
    }
    
    func loadData() {
        guard let file = Bundle.main.url(forResource: "colors", withExtension: "json")
            else {
                print("Json file not found")
                return
            }
        let data = try? Data(contentsOf: file)
        let colors = try? JSONDecoder().decode([OriginalColor].self, from: data!)
        self.colors = colors!
    }
}
