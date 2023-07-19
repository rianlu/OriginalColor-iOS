//
//  CopyListView.swift
//  OriginalColor
//
//  Created by Lu on 2023/7/11.
//

import SwiftUI

struct CopyListView: View {
    
    @State var color: OriginalColor
    @State var withMark: Bool = true
    @State var smallFont: Bool = false
    @State var hideCopyIcon: Bool = false
    
    var body: some View {
        VStack {
            CopyItemView(colorString: "\(withMark ? "HEX : " : "")" + color.hex, smallFont: smallFont, hideCopyIcon: hideCopyIcon)
            CopyItemView(colorString: "\(withMark ? "RGB : " : "")" + color.getRGBString(), smallFont: smallFont, hideCopyIcon: hideCopyIcon)
            CopyItemView(colorString: "\(withMark ? "CMYK: " : "")" + color.getCMYKString(), smallFont: smallFont, hideCopyIcon: hideCopyIcon)
        }
        .padding([.leading, .trailing], 8)
        .background(color.getRGBColor().opacity(0.1))
        .cornerRadius(16)
    }
}

struct CopyItemView: View {
    
    @State var colorString: String
    @State var isCopied = false
    @State var smallFont: Bool = false
    @State var hideCopyIcon: Bool = false
    
    var body: some View {
        HStack {
            Text(colorString.uppercased())
                .font(smallFont ? .headline : .title3)
            Spacer()
            if !hideCopyIcon {
                Image(systemName: !isCopied ? "clipboard" : "checkmark")
            }
        }
        .frame(height: 50)
        .contentShape(Rectangle())
        .onTapGesture {
            if let content = colorString.uppercased().components(separatedBy: ": ").last {
                UIPasteboard.general.string = content
            }
            withAnimation {
                isCopied.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    isCopied.toggle()
                }
            }
        }
    }
}


struct CopyListView_Previews: PreviewProvider {
    static var previews: some View {
        CopyListView(color: OriginalColor(RGB: [23, 129, 181], hex: "#ff00ff", name: "哈哈哈", pinyin: "houmaohui"))
    }
}
