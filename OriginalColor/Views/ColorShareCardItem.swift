//
//  ColorShareCardItem.swift
//  OriginalColor
//
//  Created by Lu on 2023/7/19.
//

import SwiftUI

struct ColorShareCardItem: View {
    @State var color: OriginalColor
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        let cardColor = color.getRGBColor()
        ZStack {
            cardColor.brightness(0.5)
            VStack(alignment: .leading) {
                Text(color.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(cardColor)
                    .brightness(-0.1)
                    .padding([.top], 8)
                HStack(alignment: .center, content: {
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: .infinity, height: 150)
                        .foregroundColor(cardColor)
                        .shadow(
                            color: cardColor,
                            radius: 5
                        )
                    VStack {
                        CopyItemView(colorString: color.hex, smallFont: true, hideCopyIcon: true)
                        CopyItemView(colorString: color.getRGBString(), smallFont: true, hideCopyIcon: true)
                        CopyItemView(colorString: color.getCMYKString(), smallFont: true, hideCopyIcon: true)
                    }
                    .padding([.leading], 16)
                })
            }
            .padding()
            .cornerRadius(16)
        }
        .frame(width: 400, height: 249)
    }
}

struct ColorShareCardItem_Previews: PreviewProvider {
    static var previews: some View {
        ColorShareCardItem(
            color: ColorViewModel().getCurrentThemeColor()
        )
    }
}
