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
    
    // 更新界面
    @State var isRefreshing = false
    @State var isLoading = false
    
    // 选中的 Item
    @State var selectedItem: OriginalColor?
    
    var columns: [GridItem] {
        switch horizontalSizeClass {
        case .regular:
            isPad = true
            return [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
        default:
            return [GridItem(.flexible())]
        }
    }
    
    @State private var mReader: ScrollViewProxy?
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        let currentColor = viewModel.getCurrentThemeColor()
        let themeColor = currentColor.getRGBColor()
        
        ZStack {
            if isRefreshing {
                LoadingView(isLoading: $isLoading, currentColor: currentColor, endAction: {
                    isRefreshing.toggle()
                })
            } else {
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
                                LazyVGrid(columns: columns, spacing: 16) {
                                    ForEach(viewModel.filterColorList, id: \.name) { color in
                                        ColorItemView(color: color)
                                            .onTapGesture {
                                                selectedItem = color
                                            }
                                            .onLongPressGesture {
                                                changeTheme(color: color)
                                            }
                                    }
                                    .sheet(item: $selectedItem) { item in
                                        switch horizontalSizeClass {
                                        case .regular:
                                            IPadColorDetailItem(color: item)
                                        default:
                                            ColorDetailItem(color: item)
                                        }
                                    }
                                }
                                .coordinateSpace(name: "scroll")
                            }
                            .onAppear {
                                self.mReader = reader
                                // 与切换主题时的 Loading 联动
                                if isLoading {
                                    isLoading.toggle()
                                    reader.scrollTo(currentColor.name,anchor: .top)
                                }
                            }
                            .simultaneousGesture(
                                DragGesture().onChanged({
                                    let isScrollDown = 0 < $0.translation.height
                                    searchOrTop = isScrollDown
                                }))
                            .onOpenURL(perform: { url in
                                guard let query = url.query() else { return }
                                let index = query.index(query.startIndex, offsetBy: 5)
                                let name = query.suffix(from: index)
                                    .removingPercentEncoding
                                if (name != nil && viewModel.filterColorList.contains {
                                    $0.name == name
                                }) {
                                    reader.scrollTo(name!, anchor: .top)
                                }
                            })
                        }
                    }
                    .safeAreaInset(edge: .bottom, alignment: .trailing) {
                        Fab(
                            showFilter: $showFilter, searchOrTop: $searchOrTop, reader: $mReader
                        )
                    }
                    .padding(.horizontal, 16)
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
                .sheet(isPresented: $showFilter) {FilterView()}
                .environmentObject(viewModel)
                .transition(AnyTransition.opacity.combined(with: .slide))
                .onAppear {
                    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(themeColor)]
                    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(themeColor)]
                }
                .id(themeColor)
            }
        }
    }
    
    func changeTheme(color: OriginalColor) {
        withAnimation(.linear(duration: 0.1)) {
            isRefreshing.toggle()
        }
        viewModel.updateThemeColor(hex: color.hex)
        let uiColor = UIColor(color.getRGBColor())
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
        // 修改 Widget 颜色
        WidgetCenter.shared.reloadTimelines(ofKind: "ColorWidget")
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
                mReader?.scrollTo(
                    viewModel.filterColorList[randomPosition].name,
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
                    viewModel.filterColorList[0].name,
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

extension URL {
    func valueOf(_ queryParameterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParameterName })?.value
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.locale, .init(identifier: "zh-Hans"))
        //                        .environment(\.locale, .init(identifier: "en"))
    }
}
