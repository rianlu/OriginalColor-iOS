//
//  SettingsScreen.swift
//  OriginalColor
//
//  Created by Lu on 2023/7/7.
//

import SwiftUI

struct SettingsScreen: View {
    
    @AppStorage("vibration") var vibration: Bool = true
    @Environment(\.colorScheme) var colorScheme
    let primartColor = Color("primaryColor")
    let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? NSLocalizedString("UnknownVersion", comment: "")
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(primartColor)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(primartColor)]
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
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
                            .tint(Color("primaryColor"))
                        }
                        // TODO: Click Func
//                        Text("⭐️给应用评分⭐️")
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
                    .foregroundColor(Color("primaryColor"))
                    .font(.headline)
                    .fontWeight(.bold)
                    .opacity(0.8)
            }
        }
    }
}

private func goToAppStore() {
    let urlString = "应用商店的APPID"
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
            SettingsScreen()
                .environment(\.locale, .init(identifier: "zh-Hans"))
//                .environment(\.locale, .init(identifier: "en"))
        }
    }
}
