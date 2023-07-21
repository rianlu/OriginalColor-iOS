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
    @State var searchOrTop: Bool = false
    @State var scrollOffset: CGFloat = 0.00
    @State var showFilter: Bool = false
    @AppStorage("vibration：") var vibration: Bool = false
    let generator = UINotificationFeedbackGenerator()
    @AppStorage("fabColor") var fabColor: String = ""
    let primartColor = Color("primaryColor")
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(primartColor)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(primartColor)]
    }
    
    @Environment (\.horizontalSizeClass) var horizontalSizeClass
    var columns: [GridItem] {
        switch horizontalSizeClass {
        case .compact:
            return [GridItem()]
        case .regular:
            return [GridItem(), GridItem()]
        default:
            return [GridItem()]
        }
    }
    
    @State private var reader: ScrollViewProxy?
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollViewReader { reader in
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(viewModel.filterColorList, id: \.name) { color in
                                ColorItemView(color: color)
                            }
                        }
                        // Show Search Or Top
                        .background(GeometryReader {
                            return Color.clear.preference(
                                key: ViewOffsetKey.self,
                                value: -$0.frame(in: .named("scroll")).origin.y)
                        })
                        .onPreferenceChange(ViewOffsetKey.self) { offset in
                            searchOrTop = offset > 50 ? offset < scrollOffset : true
                            scrollOffset = offset
                        }
                    }
                    .onAppear {
                        self.reader = reader
                    }
                    .safeAreaInset(edge: .bottom, alignment: .trailing) {
                        Fab(
                            showFilter: $showFilter, searchOrTop: $searchOrTop, reader: $reader
                        )
                    }
                    .padding(.horizontal)
                    .navigationTitle("原色")
                    .navigationBarItems(
                        leading: Image("random.cube")
                            .foregroundColor(primartColor)
                            .onTapGesture {
                                let count = viewModel.filterColorList.count
                                if count == 0 {
                                    return
                                }
                                if vibration {
                                    generator.notificationOccurred(.success)
                                }
                                reader.scrollTo(
                                    viewModel.filterColorList[Int.random(in: 0..<count)].name,
                                    anchor: .top
                                )
                            },
                        trailing: NavigationLink(
                            destination: SettingsScreen(), label: {
                                Image(systemName: "gear")
                                    .foregroundColor(primartColor)
                            })
                        )
                }
            }
        }
        .accentColor(primartColor)
        .sheet(isPresented: $showFilter) {
            FilterView(viewmodel: viewModel)
        }
        .environmentObject(viewModel)
    }
}

struct Fab: View {
    
    @Binding var showFilter: Bool
    @Binding var searchOrTop: Bool
    @Binding var reader: ScrollViewProxy?
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: ColorViewModel
    
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
            }
        }, label: {
            Image(systemName: searchOrTop ? "magnifyingglass" : "arrow.up")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .padding(20)
        })
        .foregroundColor(.white)
        .background(Color("primaryColor"))
        .cornerRadius(35)
        .shadow(radius: 3, x: 3, y: 3)
        .transition(.scale)
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
    }
}
