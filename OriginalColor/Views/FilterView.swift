//
//  SearchFilterView.swift
//  OriginalColor
//
//  Created by Lu on 2023/7/7.
//

import SwiftUI

struct FilterView: View {
    
    @EnvironmentObject var viewModel: ColorViewModel
    @State private var searchText = ""
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
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

struct SearchFilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
            .environmentObject(ColorViewModel())
            .environment(\.locale, .init(identifier: "zh-Hans"))
//            .environment(\.locale, .init(identifier: "en"))
    }
}
