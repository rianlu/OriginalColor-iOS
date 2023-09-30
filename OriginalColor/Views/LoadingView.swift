//
//  LoadingView.swift
//  OriginalColor
//
//  Created by lu on 2023/9/29.
//

import SwiftUI

struct LoadingView: View {
    
    @Binding var isLoading: Bool
    var currentColor: OriginalColor
    var endAction: () -> ()
    
    var body: some View {
        let themeColor = currentColor.getRGBColor()
        ZStack {
            themeColor.opacity(0.4)
                .ignoresSafeArea()
                .blur(radius: 5)
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(themeColor, lineWidth: 10)
                .frame(width: 200, height: 200)
                .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                .onAppear {
                    withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                        isLoading.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        isLoading.toggle()
                        endAction()
                    }
                }
            Text(currentColor.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .foregroundColor(themeColor)
                .frame(width: 160, height: 160)
        }
    }
}

#Preview {
    @State var isLoading = true
    return LoadingView(isLoading: $isLoading, currentColor: ColorViewModel().getCurrentThemeColor()) {
        
    }
}
