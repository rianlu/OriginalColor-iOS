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

    let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "获取失败"
    var body: some View {
        ZStack {
            Color.white
            .navigationTitle("关于")
            VStack {
                Form {
                    Section("") {
                        HStack {
                            Text("版本")
                            Text(appVersion)
                        }
                        HStack {
                            Image(systemName: "iphone.radiowaves.left.and.right")
                            Toggle(isOn: $vibration) {
                                Text("震动")
                            }
                            .padding(.leading, 6)
                        }
    //                    ShareLink(item: "原色——一款轻量简洁的配色APP，快去AppStore下载吧！") {
    //                        Label("分享APP", systemImage: "square.and.arrow.up")
    //                    }
    //                    Label("给应用评分", systemImage: "hand.thumbsup")
    //                        .foregroundColor(colorScheme == .light ? .black : .white)
    //                        .onTapGesture {
    //                            goToAppStore()
    //                        }
                    }
                    HStack {
                        Spacer()
                        VStack(alignment: .center, content: {
                            Text("App Developed by 禄眠")
                            Text(.init("Copyright © 2013 by [Perchouli](http://dmyz.org/) Shanzhai to [Nipponcolors](http://nipponcolors.com/)"))
                                .multilineTextAlignment(.center)
                            Text("参看: 色谱 中科院科技情报编委会名词室.科学出版社,1957. Adobe RGB / CMYK FOGRA39, Dot Gain 15%")
                                .multilineTextAlignment(.center)
                        })
                        Spacer()
                    }
                        .listRowBackground(
                            Color(UIColor.systemGroupedBackground))
                }
            }
//                     Copyright © 2013 by <a href="http://dmyz.org/">Perchouli</a> Shanzhai to <a href="http://nipponcolors.com/">Nipponcolors</a>\n参看: 色谱 中科院科技情报编委会名词室.科学出版社,1957. Adobe RGB / CMYK FOGRA39, Dot Gain 15% <img src="http://zhongguose.com/img/share.jpg" width="1" alt="Screenshot" /><a href="https://beian.miit.gov.cn/">沪ICP备17025116号-2</a></p>
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
        SettingsScreen()
    }
}
