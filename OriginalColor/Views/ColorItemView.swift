//
//  ColorItemView.swift
//  OriginalColor
//
//  Created by Lu on 2023/7/7.
//

import SwiftUI

struct ColorItemView: View {
    
    @State var color: OriginalColor
    @Environment(\.colorScheme) var colorScheme
    @Environment (\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        let cornerRadius = 16.0
        let cardColor = color.getRGBColor()
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(
                    LinearGradient(gradient: Gradient(stops: [
                        .init(color: colorScheme == .light ? cardColor.opacity(0.7) : cardColor.adjust(brightness: 0.2), location: 0.3),
                        .init(color: cardColor, location: 1)
                    ]), startPoint: .top, endPoint: .bottom)
                )
            VStack(alignment: .leading) {
                Text(color.pinyin.uppercased())
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(cardColor).opacity(0.6)
                    .brightness(cardColor.isLight() ? -0.3 : -0.1)
                Text(color.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(cardColor)
                    .brightness(cardColor.isLight() ? -0.3 : -0.1)
                    .padding(.top, 2)
            }
            .padding()
        }
        .frame(height: 240)
        .contentShape(Rectangle())
     }
}

struct ColorItemView_Previews: PreviewProvider {
    @State static var changeThemeColor = false
    static var previews: some View {
        ColorItemView(color: ColorViewModel().getCurrentThemeColor())
    }
}
