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

    var body: some View {
        let cornerRadius = 16.0
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(
                    LinearGradient(gradient: Gradient(stops: [
                        .init(color: color.getRGBColor()
                            .opacity(colorScheme == .light ? 0.7 : 1), location: 0.3),
                        .init(color: color.getRGBColor(), location: 1)
                    ]), startPoint: .top, endPoint: .bottom)
                )
            VStack(alignment: .leading) {
                Text(color.pinyin.uppercased())
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(color.getRGBColor()).opacity(0.6)
                    .brightness(color.getRGBColor().isLight() ? -0.3 :
                        (colorScheme == .light ? 0 : 0.3)
                    )
                Text(color.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(color.getRGBColor())
                    .brightness(color.getRGBColor().isLight() ? -0.3 :
                        (colorScheme == .light ? 0 : 0.3)
                    )
                    .padding(.top, 2)
            }
            .padding()
        }
        .frame(width: .infinity, height: 240)
        .padding(4)
        .onTapGesture {
            isSHowDetails.toggle()
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
    static var previews: some View {
        ColorItemView(color: OriginalColor(RGB: [222, 28, 49], name: "唐菖蒲红", pinyin: "tangchangpuhong"))
    }
}
