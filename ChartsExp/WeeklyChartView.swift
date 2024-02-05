//
//  WeeklyChartView.swift
//  ChartsExp
//
//  Created by Sudeep Rao on 05/02/24.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")

        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}

struct WeeklyChartView: View {
    let screenTimeData: [ScreenTime] = [
        ScreenTime(day: "Mon", hours: 1.5),
        ScreenTime(day: "Tue", hours: 3.0),
        ScreenTime(day: "Wed", hours: 2.0),
        ScreenTime(day: "Thu", hours: 4.5),
        ScreenTime(day: "Fri", hours: 3.5),
        ScreenTime(day: "Sat", hours: 2.0),
        ScreenTime(day: "Sun", hours: 0.0)
    ]
    
    @State private var selectedDay: String? = "Thu"
    
    var body: some View {
        GeometryReader { geometry in
            let rectangleWidth: CGFloat = (geometry.size.width - 30) / 11.2
            let totalWidthOfRectangles = rectangleWidth * CGFloat(screenTimeData.count)
            let spacing = (geometry.size.width - totalWidthOfRectangles) / CGFloat(screenTimeData.count - 1)
            HStack(alignment: .bottom, spacing: spacing) {
                ForEach(screenTimeData, id: \.day) { data in
                    VStack {
                        if selectedDay == data.day {
                            Text("\(data.hours, specifier: "%.1fh")")
                                .foregroundColor(.white)
                                .padding(4)
                                .background(Color.black)
                                .cornerRadius(5)
                                .frame(width: 40)
                                .font(.system(size: 12, weight: .regular))
                                .animation(.easeInOut(duration: 0.3), value: data.day)
                        } else {
                            Text("\(data.hours, specifier: "%.1fh")")
                                .foregroundColor(.white)
                                .padding(4)
                                .cornerRadius(5)
                                .font(.system(size: 8, weight: .regular))
                        }
                        Rectangle()
                            .fill(selectedDay == data.day ? Color(hex: "A5B4FC") : Color(hex: "18181B"))
                            .frame(width: (geometry.size.width - 30) / 14, height: CGFloat(data.hours) * 40.0)
                            .cornerRadius(50)
                            .animation(.easeInOut(duration: 0.3), value: selectedDay)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    self.selectedDay = data.day
                                }
                            }
                        Text(data.day)
                            .font(.caption)
                    }
                }
            }
            .padding(.horizontal, 15)
        }
    }
}

struct ScreenTime {
    let day: String
    let hours: Double
}

struct WeeklyChartPreview: PreviewProvider {
    static var previews: some View {
        WeeklyChartView()
    }
}
