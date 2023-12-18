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
    @EnvironmentObject var viewModel: ColorViewModel
    @State var ietmScaleAnimation = false
    
    var body: some View {
        let cornerRadius = 16.0
        let cardColor = color.getRGBColor()
        let cardHeight = 240.0
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
        .frame(height: cardHeight)
        .contentShape(Rectangle())
        .scaleEffect(
            x: ietmScaleAnimation ? 1.05 : 1.0,
            y: ietmScaleAnimation ? 1.1 : 1.0
        )
        .onAppear {
            withAnimation(.spring(duration: 0.15, bounce: 0.5)) {
                ietmScaleAnimation = color.name == viewModel.randomColorName
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(duration: 0.2, bounce: 0.8)) {
                    ietmScaleAnimation = false
                }
            }
        }
        .onDisappear {
            ietmScaleAnimation = false
        }
        .overlay(alignment: .bottomTrailing) {
            let symbol = if color.name.contains("星") {
                "star"
            } else if color.name.contains("鱼") {
                "fish"
            } else if color.name.contains("叶") {
                "leaf"
            }
            else {
                ""
            }
            if !symbol.isEmpty {
                Image(systemName: symbol)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .foregroundColor(cardColor).opacity(0.6)
                    .offset(x: 20, y: 20)
                    .clipped()
            }
        }
     }
}

struct ColorItemView_Previews: PreviewProvider {
    @State static var changeThemeColor = false
    static var previews: some View {
        let viewModel = ColorViewModel()
        ColorItemView(color: viewModel.getCurrentThemeColor())
            .environmentObject(viewModel)
    }
}
