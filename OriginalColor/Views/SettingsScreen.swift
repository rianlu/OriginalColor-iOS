//
//  SettingsScreen.swift
//  OriginalColor
//
//  Created by Lu on 2023/7/7.
//

import SwiftUI

struct SettingsScreen: View {
    
    @State var currentColor: OriginalColor
    @AppStorage("vibration") var vibration: Bool = true
    @Environment(\.colorScheme) var colorScheme
    @State var isPressed = false
    @Environment (\.horizontalSizeClass) var horizontalSizeClass

    let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? NSLocalizedString("UnknownVersion", comment: "")
    
    var body: some View {
        let themeColor = currentColor.getRGBColor()
        NavigationStack {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("About")
                                .foregroundColor(themeColor)
                        }
                    }
                VStack {
                    Form {
                        Section("") {
                            HStack {
                                Text("Version")
                                Spacer()
                                Text(appVersion)
                                    .opacity(0.5)
                            }
                            HStack {
                                Text("CurrentThemeColor")
                                Spacer()
                                Text(currentColor.name)
                                    .foregroundColor(themeColor)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                isPressed.toggle()
                            }
                            HStack {
                                Toggle(isOn: $vibration) {
                                    Text("Vibration")
                                }
                                .tint(themeColor)
                            }
                            HStack {
                                Text("RateApp")
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                goToAppStore()
                            }
                        }
                        HStack {
                            VStack(alignment: .center, content: {
                                Group {
                                    Text(.init("Copyright © 2013 by [Perchouli](http://dmyz.org/) Shanzhai to [Nipponcolors](http://nipponcolors.com/)"))
                                        .multilineTextAlignment(.center)
                                    Text("参看: 色谱 中科院科技情报编委会名词室.科学出版社,1957. Adobe RGB / CMYK FOGRA39, Dot Gain 15%")
                                        .multilineTextAlignment(.center)
                                }
                                .foregroundColor(.gray)
                                .font(.subheadline)
                            })
                            .padding(16)
                        }
                        .listRowBackground(
                            Color(UIColor.systemGroupedBackground)
                            )
                    }
                    Text("Developed by 禄眠")
                        .foregroundColor(themeColor)
                        .font(.headline)
                        .fontWeight(.bold)
                        .opacity(0.8)
                }
            }
            .sheet(isPresented: $isPressed, content: {
                switch horizontalSizeClass {
                case .regular:
                    IPadColorDetailItem(color: currentColor)
                default:
                    ColorDetailItem(color: currentColor)
                }
            })
        }
    }
}

private func goToAppStore() {
    let urlString = "https://apps.apple.com/cn/app/%E5%8E%9F%E8%89%B2-%E9%A2%9C%E8%89%B2%E6%9F%A5%E8%AF%A2/id6465685086"
    if let url = URL(string: urlString) {
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:],
              completionHandler: {
                (success) in
            })
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        let color = ColorViewModel().getCurrentThemeColor()
        NavigationStack {
            SettingsScreen(currentColor: color)
                .environment(\.locale, .init(identifier: "zh-Hans"))
//                .environment(\.locale, .init(identifier: "en"))
        }
    }
}
