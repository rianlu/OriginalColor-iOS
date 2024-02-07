//
//  ColorWidget.swift
//  ColorWidget
//
//  Created by lu on 2023/9/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    let data = DataService()

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), color: data.getWidgetColor())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), color: data.getWidgetColor())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, color: data.getWidgetColor())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let color: OriginalColor
}

struct ColorWidgetEntryView : View {

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.widgetFamily) var family

    var entry: Provider.Entry
    var body: some View {
        let cornerRadius = 16.0
        let cardColor = entry.color.getRGBColor()
        let colorName = entry.color.name
        let url = URL(string: "widget-deeplink://color")
        
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(
                    LinearGradient(gradient: Gradient(stops: [
                        .init(color: colorScheme == .light ? cardColor.opacity(0.7) : cardColor.adjust(brightness: 0.2), location: 0.3),
                        .init(color: cardColor, location: 1)
                    ]), startPoint: .top, endPoint: .bottom)
                )
            switch family {
            case .systemSmall:
                SmallContentView(entry: entry)
            case .systemMedium:
                MediumContentView(entry: entry)
            case .systemLarge:
                LargeContentView(entry: entry)
            default:
                MediumContentView(entry: entry)
            }
        }.widgetURL(
            url?.appending(
                queryItems: [
                    URLQueryItem(name: "name", value: colorName),
                    URLQueryItem(name: "hex", value: entry.color.hex)
                ]
            )
        )
    }
}

struct SmallContentView: View {
    
    @Environment(\.widgetFamily) var family
    var entry: SimpleEntry

    var body: some View {
        let cardColor = entry.color.getRGBColor()
        VStack(alignment: .leading) {
            Spacer()
            HStack() {
                Spacer()
                Text(entry.color.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(cardColor)
                    .brightness(cardColor.isLight() ? -0.3 : -0.1)
                    .padding(.top, 2)
                Spacer()
            }
            Spacer()
        }
        .padding()
    }
}

struct MediumContentView: View {
    
    @Environment(\.widgetFamily) var family
    var entry: SimpleEntry

    var body: some View {
        let cardColor = entry.color.getRGBColor()
        VStack(alignment: .leading) {
            Text(entry.color.pinyin.uppercased())
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(cardColor).opacity(0.6)
                .brightness(cardColor.isLight() ? -0.3 : -0.1)
            Text(entry.color.name)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(cardColor)
                .brightness(cardColor.isLight() ? -0.3 : -0.1)
        }
        .padding()
    }
}

struct LargeContentView: View {
    
    @Environment(\.widgetFamily) var family
    var entry: SimpleEntry

    var body: some View {
        let cardColor = entry.color.getRGBColor()
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text(entry.color.pinyin.uppercased())
                        .font(.system(size: 70, weight: .bold, design: .rounded))
                        .lineLimit(3)
                        .multilineTextAlignment(.center)
                        .scaleEffect(1.5)
                        .foregroundColor(cardColor).opacity(0.2)
                        .brightness(cardColor.isLight() ? -0.3 : -0.1)
                        .blur(radius: 3)
                    Spacer()
                }
                Spacer()
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text(entry.color.name)
                        .font(.system(size: 55, weight: .bold, design: .rounded))
                        .foregroundColor(cardColor)
                        .brightness(cardColor.isLight() ? -0.3 : -0.1)
                        .minimumScaleFactor(0.5)
                    Spacer()
                }
                Spacer()
            }
        }
        .padding()
    }
}

struct ColorWidget: Widget {
    let kind: String = "ColorWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                ColorWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                ColorWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .contentMarginsDisabled()
        .configurationDisplayName("CFBundleDisplayName")
        .description("ColorWidget")
    }
}

#Preview(as: .systemSmall) {
    ColorWidget()
} timeline: {
    let data = DataService()
    SimpleEntry(date: .now, color: data.getWidgetColor())
    SimpleEntry(date: .now, color: OriginalColor(RGB: [23, 129, 181], name: "釉蓝", pinyin: "youlan"))
}

#Preview(as: .systemMedium) {
    ColorWidget()
} timeline: {
    let data = DataService()
    SimpleEntry(date: .now, color: data.getWidgetColor())
    SimpleEntry(date: .now, color: OriginalColor(RGB: [23, 129, 181], name: "釉蓝", pinyin: "youlan"))
}

#Preview(as: .systemLarge) {
    ColorWidget()
} timeline: {
    let data = DataService()
    SimpleEntry(date: .now, color: data.getWidgetColor())
    SimpleEntry(date: .now, color: OriginalColor(RGB: [23, 129, 181], name: "釉蓝", pinyin: "youlan"))
}
