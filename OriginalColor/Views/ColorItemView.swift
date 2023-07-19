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
                        .init(color: colorScheme == .light ?
                              color.getRGBColor().opacity(0.6) :
                                color.getRGBColor().opacity(0.9),
                              location: 0),
                        .init(color: color.getRGBColor(), location: 0.4)
                    ]), startPoint: .top, endPoint: .bottom)
                )
            VStack{
                Text(color.pinyin.uppercased())
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(color.getRGBColor()).opacity(0.6)
                    .brightness(colorScheme == .light ? -0.1 : 0.3)
                Text(color.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(color.getRGBColor()).opacity(1)
                    .brightness(colorScheme == .light ? -0.1 : 0.3)
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
        ColorItemView(color: OriginalColor(RGB: [23, 129, 181], name: "哈哈哈", pinyin: "hahaha"))
    }
}
