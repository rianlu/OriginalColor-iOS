//
//  SearchFilterView.swift
//  OriginalColor
//
//  Created by Lu on 2023/7/7.
//

import SwiftUI

struct FilterView: View {
    
    @EnvironmentObject var viewModel: ColorViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @Binding var searchText: String
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.colorStringList, id: \.self) { item in
                    HStack {
                        Text(NSLocalizedString(item, comment: ""))
                        Spacer()
                        if item == viewModel.filter {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(viewModel.themeColor)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.filterColorList(filter: item)
                        searchText = ""
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .searchable(text: $searchText)
        .onSubmit(of: .search) {
            viewModel.searchColorList(keyword: searchText)
            presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview("English") {
    @State var searchText = ""
    return FilterView(searchText: $searchText)
        .environmentObject(ColorViewModel())
}

#Preview("zh-Hans") {
    @State var searchText = ""
    return FilterView(searchText: $searchText)
        .environmentObject(ColorViewModel())
        .environment(\.locale, .init(identifier: "zh-Hans"))
}
