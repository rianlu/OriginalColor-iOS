//
//  SettingsScreen.swift
//  OriginalColor
//
//  Created by Lu on 2023/7/7.
//

import SwiftUI

struct SettingsScreen: View {
    
    @State var themeColor: Color
    @AppStorage("vibration") var vibration: Bool = true
    @Environment(\.colorScheme) var colorScheme
    let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? NSLocalizedString("UnknownVersion", comment: "")
    
    var body: some View {
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
                            Spacer()
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
                            Spacer()
                        }
                            .listRowBackground(
                                Color(UIColor.systemGroupedBackground))
                    }
                    Text("Developed by 禄眠")
                        .foregroundColor(themeColor)
                        .font(.headline)
                        .fontWeight(.bold)
                        .opacity(0.8)
                }
            }
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
        NavigationStack {
            SettingsScreen(themeColor: Color("primaryColor"))
                .environment(\.locale, .init(identifier: "zh-Hans"))
//                .environment(\.locale, .init(identifier: "en"))
        }
    }
}
