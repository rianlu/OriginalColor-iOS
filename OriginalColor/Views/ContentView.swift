//
//  ContentView.swift
//  OriginalColor
//
//  Created by Lu on 2023/7/4.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    
    @StateObject var viewModel: ColorViewModel = ColorViewModel()
    @Environment(\.colorScheme) var colorScheme
    @Environment (\.horizontalSizeClass) var horizontalSizeClass

    // FAB
    @State var searchOrTop: Bool = true
    // 搜索&筛选
    @State var showFilter: Bool = false
    // 震动反馈
    @AppStorage("vibration：") var vibration: Bool = true
    // 随机按钮旋转动画（角度）
    @State var randomAngle = 0.0
    // 屏幕尺寸
    @State var isPad = false

    // 用于重新创建标题栏
    @State private var force = UUID()
    
    // 更新界面
    @State var isRefreshing = true
    @State var isLoading = false

    var columns: [GridItem] {
        switch horizontalSizeClass {
        case .compact:
            return [GridItem()]
        case .regular:
            isPad = true
            return [GridItem(), GridItem()]
        default:
            return [GridItem()]
        }
    }
    
    @State private var reader: ScrollViewProxy?
    
    var body: some View {
        let themeColor = viewModel.themeColor
        let currentColor = viewModel.getCurrentThemeColor()
        ZStack {
            if isRefreshing {
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
                            reader?.scrollTo(
                                currentColor.pinyin,
                                anchor: .top
                            )
//                            isRefreshing.toggle()
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
            if !isRefreshing {
                NavigationStack {
                    ZStack {
                        if viewModel.filterColorList.count == 0 {
                            VStack {
                                Image("empty_list_placeholder")
                                Text("EmptyListHint")
                                    .foregroundColor(themeColor)
                            }
                        }
                        ScrollViewReader { reader in
                            ScrollView {
                                LazyVGrid(columns: columns) {
                                    ForEach(viewModel.filterColorList, id: \.pinyin) { color in
                                        ColorItemView(color: color)
                                            .onLongPressGesture {
                                                withAnimation(.linear(duration: 0.1)) {
                                                    isRefreshing.toggle()
                                                }
                                                viewModel.updateThemeColor(hex: color.hex)
                                                let uiColor = UIColor(themeColor)
                                                UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
                                                UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
                                                WidgetCenter.shared.reloadTimelines(ofKind: "ColorWidget")
                                            }
                                    }
                                }
                                .coordinateSpace(name: "scroll")
                            }
                            .onAppear {
                                self.reader = reader
                                // 与切换主题时的 Loading 联动
                                if isLoading {
                                    isLoading.toggle()
                                    reader.scrollTo(currentColor.pinyin,
                                        anchor: .top
                                    )
                                    searchOrTop = false
                                }
                            }
                            .simultaneousGesture(
                                   DragGesture().onChanged({
                                       let isScrollDown = 0 < $0.translation.height
                                       searchOrTop = isScrollDown
                                   }))
                        }
                    }
                    .safeAreaInset(edge: .bottom, alignment: .trailing) {
                        Fab(
                            showFilter: $showFilter, searchOrTop: $searchOrTop, reader: $reader
                        )
                    }
                    .padding(.horizontal)
                    .navigationTitle("CFBundleDisplayName")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            navigationLeadingVIew
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(
                                destination: SettingsScreen(themeColor: themeColor), label: {
                                    Image(systemName: "gear")
                                })
                        }
                    }
                }
                .transition(.opacity)
                .accentColor(themeColor)
                .sheet(isPresented: $showFilter) {FilterView(viewmodel: viewModel)}
                .environmentObject(viewModel)
                .transition(AnyTransition.opacity.combined(with: .slide))
                .onAppear {
                    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(themeColor)]
                    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(themeColor)]
                }
                .id(themeColor)
                .onOpenURL(perform: { url in
                    let linkData = url.host() ?? ""
                    if !linkData.isEmpty {
                        reader?.scrollTo(linkData, anchor: .top)
                    }
                })
            }
        }
    }
    
    var navigationLeadingVIew: some View {
        let themeColor = viewModel.themeColor
        return Image("random.cube")
            .foregroundColor(themeColor)
            .rotationEffect(.degrees(randomAngle))
            .animation(.spring(), value: randomAngle)
            .onTapGesture {
                let count = viewModel.filterColorList.count
                if count == 0 {
                    return
                }
                let randomPosition = Int.random(in: 0..<count)
                if randomPosition == 0 || (randomPosition == 1 && isPad) {
                    return
                }
                if vibration {
                    HapticManager.instance.impact(style: .soft)
                }
                randomAngle += 360.0
                reader?.scrollTo(
                    viewModel.filterColorList[randomPosition].pinyin,
                    anchor: .top
                )
                searchOrTop = false
            }
    }
}

struct Fab: View {
    
    @Binding var showFilter: Bool
    @Binding var searchOrTop: Bool
    @Binding var reader: ScrollViewProxy?
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: ColorViewModel

    var body: some View {
        let themeColor = viewModel.themeColor
        Button(action: {
            if searchOrTop {
                showFilter.toggle()
            } else {
                let count = viewModel.filterColorList.count
                if count == 0 {
                    return
                }
                reader?.scrollTo(
                    viewModel.filterColorList[0].pinyin,
                    anchor: .top
                )
                searchOrTop = true
            }
        }, label: {
            Image(systemName: searchOrTop ? "magnifyingglass" : "arrow.up")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .padding(20)
                .foregroundColor(themeColor.isLight() ? themeColor.adjust(brightness: -0.5) : themeColor.adjust(brightness: 0.5))
        })
        .foregroundColor(.white)
        .background(themeColor)
        .cornerRadius(35)
        .transition(.scale)
        .scaleEffect(showFilter ? 0 : 1)
        .animation(.spring(), value: showFilter)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
                    .environment(\.locale, .init(identifier: "zh-Hans"))
//                        .environment(\.locale, .init(identifier: "en"))
    }
}
