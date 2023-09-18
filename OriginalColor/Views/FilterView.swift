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
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewmodel.colorStringList, id: \.self) { item in
                    HStack {
                        Text(NSLocalizedString(item, comment: ""))
                        Spacer()
                        if item == viewmodel.filter {
                            Image(systemName: "checkmark")
                                .foregroundColor(viewmodel.themeColor)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
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
            .environment(\.locale, .init(identifier: "zh-Hans"))
                .environment(\.locale, .init(identifier: "en"))
    }
}
