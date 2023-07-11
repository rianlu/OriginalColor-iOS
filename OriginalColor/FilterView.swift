//
//  SearchFilterView.swift
//  OriginalColor
//
//  Created by Lu on 2023/7/7.
//

import SwiftUI

struct FilterView: View {
    
    @State var filter: String
    @State private var searchText = ""
    var colorStringList: [String] = ["全部", "白", "灰", "红", "橙", "黄", "绿","青", "蓝", "紫", "其他"]
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            HStack {
//                ForEach(colorStringList, id: \.self) { colorString in
//                    Button(action: {}, label: {
//                        Text("哈哈哈")
//                    })
//                    .padding()
//                    .foregroundColor(.white)
//                    .background(Color.red)
//                }
            }
        }
        .searchable(text: $searchText)
        .onSubmit({
            filter = searchText
            presentationMode.wrappedValue.dismiss()
        })
    }
}

struct SearchFilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(filter: "")
    }
}
