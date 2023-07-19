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
    @State var showFab: Bool = false
    @State var scrollOffset: CGFloat = 0.00
    @State var showFilter: Bool = false
    @AppStorage("vibration：") var vibration: Bool = false
    let generator = UINotificationFeedbackGenerator()
    @AppStorage("fabColor") var fabColor: String = ""
    
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
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(viewModel.filterColorList, id: \.name) { color in
                                ColorItemView(color: color)
                            }
                        }
                        // Hide Fab when scrolling
                        .background(GeometryReader {
                            return Color.clear.preference(
                                key: ViewOffsetKey.self,
                                value: -$0.frame(in: .named("scroll")).origin.y)
                        })
                        .onPreferenceChange(ViewOffsetKey.self) { offset in
                            withAnimation {
                                showFab = offset > 50 ? offset < scrollOffset : true
                            }
                            scrollOffset = offset
                        }
                    }
                    .safeAreaInset(edge: .bottom, alignment: .trailing) {
                        showFab ? Fab(showFilter: $showFilter) : nil
                    }
                    .padding(.horizontal)
                    .navigationTitle("原色")
                    .navigationBarItems(
                        leading: Image("random.cube")
                            .foregroundColor(colorScheme == .light ? .black : .white)
                            .onTapGesture {
                                let count = viewModel.filterColorList.count
                                if count == 0 {
                                    return
                                }
                                if vibration {
                                    generator.notificationOccurred(.success)
                                }
                                proxy.scrollTo(
                                    viewModel.filterColorList[Int.random(in: 0..<count)].name,
                                    anchor: .top
                                )
                            },
                        trailing: NavigationLink(
                            destination: SettingsScreen(), label: {
                                Image(systemName: "gear")
                                    .foregroundColor(
                                        colorScheme == .light ? .black : .white)
                            })
                        )
                }
            }
        }
        .sheet(isPresented: $showFilter) {
            FilterView(viewmodel: viewModel)
        }
    }
}

struct Fab: View {
    
    @Binding var showFilter: Bool
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: {
            showFilter.toggle()
        }, label: {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .padding(20)
        })
        .foregroundColor(.white)
        .background(
            colorScheme == .light ?
            Color(red: 140 / 255, green: 194 / 255, blue: 105 / 255)
            : Color(red: 26 / 255, green: 104 / 255, blue: 64 / 255)
        )
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
