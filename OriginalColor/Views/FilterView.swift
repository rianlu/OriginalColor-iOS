//
//  SearchFilterView.swift
//  OriginalColor
//
//  Created by Lu on 2023/7/7.
//

import SwiftUI

struct FilterView: View {
    
    @ObservedObject var viewmodel: ColorViewModel
    @State private var searchText = ""
    var colorStringList: [String] = ["全部", "白", "灰", "红", "橙", "黄", "绿","青", "蓝", "紫", "其他"]
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(colorStringList, id: \.self) { item in
                    HStack {
                        Text(item)
                        Spacer()
                        if item == viewmodel.filter {
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewmodel.filter = item
                        viewmodel.filterColorList(filter: item)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .searchable(text: $searchText)
        .onSubmit(of: .search) {
            viewmodel.searchColorList(keyword: searchText)
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct SearchFilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(viewmodel: ColorViewModel())
    }
}
