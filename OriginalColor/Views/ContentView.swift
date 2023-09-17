//
//  ContentView.swift
//  OriginalColor
//
//  Created by Lu on 2023/7/4.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel: ColorViewModel = ColorViewModel()
    @Environment(\.colorScheme) var colorScheme
    @Environment (\.horizontalSizeClass) var horizontalSizeClass

    @State var searchOrTop: Bool = true
    @State var scrollOffset: CGFloat = 0.00
    @State var showFilter: Bool = false
    @AppStorage("vibration：") var vibration: Bool = true
    let primartColor = Color("primaryColor")
    // 随机按钮旋转动画（角度）
    @State var randomAngle = 0.0
    @State var isPad = false
    
    @AppStorage("themeColor") var themeColor: String = ""
    // 用于重新创建标题栏
    @State private var force = UUID()

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
    
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color(hex: themeColor))]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color(hex: themeColor))]
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.filterColorList.count == 0 {
                    VStack {
                        Image("empty_list_placeholder")
                        Text("EmptyListHint")
                            .foregroundColor(Color(hex: themeColor))
                    }
                }
                ScrollViewReader { reader in
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(viewModel.filterColorList, id: \.name) { color in
                                ColorItemView(color: color)
                            }
                        }
//                        .background(GeometryReader {
//                            return Color.clear.preference(
//                                key: ViewOffsetKey.self,
//                                value: -$0.frame(in: .named("scroll")).origin.y)
//                        })
                        .coordinateSpace(name: "scroll")
                        .onPreferenceChange(ViewOffsetKey.self) { value in
                             print("offset: %d", value)
                         }
//                        .onPreferenceChange(ViewOffsetKey.self) { offset in
//                            searchOrTop = offset > 50 ? offset < scrollOffset : true
//                            scrollOffset = offset
//                            print(searchOrTop)
//                        }
                    }
                    .onAppear {
                        self.reader = reader
                    }
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
                        destination: SettingsScreen(localThemeColor: Color(hex: themeColor)), label: {
                            Image(systemName: "gear")
                        })
                }
            }
//            .navigationBarItems(
//                leading: navigationLeadingVIew,
//                trailing: NavigationLink(
//                    destination: SettingsScreen(localThemeColor: Color(hex: themeColor)), label: {
//                        Image(systemName: "gear")
//                    })
//                )
        }
        .accentColor(Color(hex: themeColor))
        .sheet(isPresented: $showFilter) {FilterView(viewmodel: viewModel)}
        .environmentObject(viewModel)
        .transition(AnyTransition.opacity.combined(with: .slide))
        .id(themeColor)
    }
    
    var navigationLeadingVIew: some View {
        Image("random.cube")
            .foregroundColor(Color(hex: themeColor))
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
    @AppStorage("themeColor") var themeColor: String = ""

    var body: some View {
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
        })
        .foregroundColor(.white)
        .background(Color(hex: themeColor))
        .cornerRadius(35)
        .transition(.scale)
        .scaleEffect(showFilter ? 0 : 1)
        .animation(.linear(duration: 0.1), value: showFilter)
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
                    .environment(\.locale, .init(identifier: "zh-Hans"))
//                        .environment(\.locale, .init(identifier: "en"))
    }
}
