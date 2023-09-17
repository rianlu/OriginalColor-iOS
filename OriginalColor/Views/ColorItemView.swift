//
//  ColorItemView.swift
//  OriginalColor
//
//  Created by Lu on 2023/7/7.
//

import SwiftUI

struct ColorItemView: View {
    
//    @State var isSHowDetails: Bool = false
    @State var color: OriginalColor
    @Environment(\.colorScheme) var colorScheme
    @Environment (\.horizontalSizeClass) var horizontalSizeClass
    @State var isSHowDetails: Bool = false
    @AppStorage("themeColor") var themeColor: String = ""
    
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
        .frame(width: .infinity, height: 240)
        .padding(4)
        .onTapGesture {
            isSHowDetails.toggle()
        }
        .onLongPressGesture {
            themeColor = color.hex
            let uiColor = UIColor(Color(hex: themeColor))
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
        }
        .sheet(isPresented: $isSHowDetails, content: {
            switch horizontalSizeClass {
            case .regular:
                IPadColorDetailItem(color: color)
                    .presentationDragIndicator(.visible)
            default:
                ColorDetailItem(color: color)
                    .presentationDetents([.height(249)])
                    .presentationDragIndicator(.visible)
            }
        })
    }
}

struct ColorItemView_Previews: PreviewProvider {
    @State static var changeThemeColor = false
    static var previews: some View {
        ColorItemView(color: OriginalColor(RGB: [222, 28, 49], name: "唐菖蒲红", pinyin: "tangchangpuhong"))
    }
}
