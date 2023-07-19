//
//  ColorViewModel.swift
//  OriginalColor
//
//  Created by Lu on 2023/7/9.
//

import Foundation

class ColorViewModel: ObservableObject {
    
    private var colorList: [OriginalColor] = []
    @Published var filterColorList: [OriginalColor] = []
    var colorStringList: [String] = ["全部", "白", "灰", "红", "橙", "黄", "绿","青", "蓝", "紫", "其他"]
    @Published var filter: String = "全部"
    
    init() {
        getJsonData()
        filterColorList = colorList
    }
    
    func getJsonData() {
        
        var tempColorList: [OriginalColor] = []
        ReadData().colors.forEach { color in
            tempColorList.append(color)
        }
        colorList = tempColorList.sorted(by: sortList)
    }
    
    func filterColorList(filter: String = "") {
        if filter == "" {
            return
        }
        if filter == "全部" {
            filterColorList = colorList
        } else if filter != "其他" {
            filterColorList = colorList.filter { color in
                color.name.count < 1 ? true : String(color.name.last!) == filter
            }
        } else {
            filterColorList = colorList.filter { color in
                !colorStringList.contains(String(color.name.last!))
            }
        }
    }
    
    func searchColorList(keyword: String) {
        if keyword == "" {
            return
        } else {
            filterColorList = colorList.filter { color in
                String(color.name.last!).contains(keyword)
            }
        }
    }
    
    func hsv(rgb: [Int]) -> [Float] {
        let r = Float(rgb[0]) / 255
        let g = Float(rgb[1]) / 255
        let b = Float(rgb[2]) / 255
        let max = max(r, g, b), min = min(r, g, b)
        var h = max, v = max
        let d = max - min
        let s = max == 0 ? 0 : d / max
        if max == min {
          h = 0
        } else {
          switch max {
            case r:
              h = (g - b) / d + (g < b ? 6 : 0)
              break
            case g:
              h = (b - r) / d + 2
              break
            case b:
              h = (r - g) / d + 4
              break
          default: break
          }
          h /= 6
        }
        return [h, s, v]
    }
    
    func sortList(this: OriginalColor, that: OriginalColor) -> Bool {
        return hsv(rgb: this.RGB)[0] == hsv(rgb: that.RGB)[0] ?
        hsv(rgb: that.RGB)[1] < hsv(rgb: this.RGB)[1] :
        hsv(rgb: that.RGB)[0] < hsv(rgb: this.RGB)[0]
    }
}
