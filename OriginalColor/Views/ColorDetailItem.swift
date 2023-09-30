//
//  ColorDetailItem.swift
//  OriginalColor
//
//  Created by Lu on 2023/7/9.
//

import SwiftUI
import MobileCoreServices
import CoreImage

struct ColorDetailItem: View {
    
    @State var color: OriginalColor
    @Environment(\.colorScheme) var colorScheme
    @State var renderedImage = Image(systemName: "photo")
    @Environment(\.displayScale) var displayScale

    var body: some View {
        let themeColor = color.getRGBColor()
        ZStack {
            themeColor.opacity(0.5).ignoresSafeArea()
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    Spacer()
                    HStack {
                        Text(color.name)
                            .font(.title)
                            .foregroundColor(themeColor).opacity(0.9)
                            .brightness(colorScheme == .light ? -0.1 : 0.1)
                        Spacer()
                        ShareLink("",
                          item: renderedImage,
                          preview: SharePreview(color.name, image: renderedImage))
                        .foregroundColor(colorScheme == .light ? .black : .white)
                    }.padding([.top], 8)
                    HStack(alignment: .center, content: {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(themeColor)
                            .frame(height: 160)
                            .padding([.trailing], 4)
                        CopyListView(color: color,withMark: false, smallFont: true)
                    })
                }
                .padding()
            }
        }
        .onAppear { render() }
        .presentationDetents([.height(250)])
        .presentationDragIndicator(.visible)
    }
    
    @MainActor func render() {
        let renderer = ImageRenderer(content: ColorShareCardItem(color: color))
        renderer.scale = displayScale
        if let uiImage = renderer.uiImage {
            renderedImage = Image(uiImage: uiImage)
        }
    }
}

struct IPadColorDetailItem: View {
    
    @State var color: OriginalColor
    @Environment(\.colorScheme) var colorScheme
    @State var renderedImage: Image = Image(systemName: "photo")

    var body: some View {
        ZStack {
            (colorScheme == .light ? color.getRGBColor().opacity(0.5) : color.getRGBColor().opacity(0.75)
            )
            .ignoresSafeArea()
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        ShareLink("",			
                          item: renderedImage,
                          preview: SharePreview(color.name, image: renderedImage))
                        .foregroundColor(colorScheme == .light ? .black : .white)
                    }
                    Text(color.pinyin.uppercased())
                        .padding(.top, 8)
                        .font(.system(size: 88, weight: .semibold, design: .rounded))
                        .foregroundColor(color.getRGBColor().opacity(0.3))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .brightness(colorScheme == .light ? -0.1 : 0.1)
                    Text(color.name)
                        .foregroundColor(color.getRGBColor().opacity(0.9))
                        .font(.system(size: 70, weight: .bold, design: .rounded))
                        .brightness(colorScheme == .light ? -0.1 : 0.1)
                    HStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(color.getRGBColor())
                            .frame(height: 258)
                            .padding([.bottom], 20)
                        if geometry.size.width > geometry.size.height {
                            CopyListView(color: color)
                        }
                    }.padding()
                    if geometry.size.width < geometry.size.height {
                        CopyListView(color: color)
                            .padding()
                    }
                }
                .padding()
            }
        }
        .presentationDragIndicator(.visible)

    }
}

struct ColorDetailItem_Previews: PreviewProvider {
    
    static var previews: some View {
        let color = ColorViewModel().getCurrentThemeColor()
        ColorDetailItem(color: color)
            .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
            .previewDisplayName("iPhone 15 Pro")
        IPadColorDetailItem(color: color)
            .previewDevice(PreviewDevice(rawValue: "iPad mini (6th generation)"))
            .previewDisplayName("iPad mini (6th generation)")
    }
}
