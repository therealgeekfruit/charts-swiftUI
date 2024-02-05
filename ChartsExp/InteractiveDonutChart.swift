//
//  InteractiveDonutChart.swift
//  ChartsExp
//
//  Created by Sudeep Rao on 30/01/24.
//

import Foundation
import SwiftUI
import Charts

struct IncomeData: Identifiable, Equatable {
    var category: String
    var amount: Int
    var id = UUID()
}


let donationsIncomeData: [IncomeData] = [
    .init(category: "Legacies", amount: 2),
    .init(category: "Other national campaigns and donations", amount: 5),
    .init(category: "Daffodil Day", amount: 4),
    .init(category: "Philanthropy and corporate partnerships", amount: 4),
    .init(category: "Individual giving", amount: 3)
]

let chartColors: [Color] = [
    Color(red: 0.55, green: 0.83 , blue: 0.78),
    Color(red: 1.00, green: 1.00 , blue: 0.70),
    Color(red: 0.75, green: 0.73 , blue: 0.85),
    Color(red: 0.98, green: 0.50 , blue: 0.45),
    Color(red: 0.50, green: 0.69 , blue: 0.83),
    Color(red: 0.99, green: 0.71 , blue: 0.38),
    Color(red: 0.70, green: 0.87 , blue: 0.41),
    Color(red: 0.99, green: 0.80 , blue: 0.90),
    Color(red: 0.85, green: 0.85 , blue: 0.85),
    Color(red: 0.74, green: 0.50 , blue: 0.74),
    Color(red: 0.80, green: 0.92 , blue: 0.77),
    Color(red: 1.00, green: 0.93 , blue: 0.44)
]

var data = [
    ScreenTimeData(category: "Social", startTime: 2, duration: 10),
    ScreenTimeData(category: "Entertainment", startTime: 2, duration: 25),
    ScreenTimeData(category: "Social", startTime: 8, duration: 15),
    ScreenTimeData(category: "Games", startTime: 8, duration: 30),
    ScreenTimeData(category: "Productivity", startTime: 9, duration: 25),
    ScreenTimeData(category: "Social", startTime: 9, duration: 20),
    ScreenTimeData(category: "Entertainment", startTime: 10, duration: 40),
    ScreenTimeData(category: "Education", startTime: 10, duration: 10),
    ScreenTimeData(category: "Health", startTime: 11, duration: 15),
    ScreenTimeData(category: "Social", startTime: 11, duration: 20),
    ScreenTimeData(category: "Games", startTime: 12, duration: 30),
    ScreenTimeData(category: "Productivity", startTime: 12, duration: 10),
    ScreenTimeData(category: "Education", startTime: 13, duration: 15),
    ScreenTimeData(category: "Entertainment", startTime: 13, duration: 20),
    ScreenTimeData(category: "Social", startTime: 14, duration: 15),
    ScreenTimeData(category: "Productivity", startTime: 15, duration: 35),
    ScreenTimeData(category: "Education", startTime: 17, duration: 45),
    ScreenTimeData(category: "Health", startTime: 18, duration: 30),
    ScreenTimeData(category: "Entertainment", startTime: 23, duration: 35)
]


struct InteractiveDonutView: View {
    @State private var selectedDuration: Int? = nil
    let cumulativeDurations: [(category: String, range: Range<Int>)]

    init() {
        var cumulative = 0
        self.cumulativeDurations = Dictionary(grouping: data, by: { $0.category })
            .mapValues { $0.reduce(0) { $0 + $1.duration } }
            .map { category, duration in
                let newCumulative = cumulative + duration
                let result = (category: category, range: cumulative ..< newCumulative)
                cumulative = newCumulative
                return result
            }
            .sorted { $0.range.lowerBound < $1.range.lowerBound }
    }

    var selectedCategoryData: (category: String, duration: Int)? {
        if let selectedDuration,
           let selectedIndex = cumulativeDurations
            .firstIndex(where: { $0.range.contains(selectedDuration) }) {
            let category = cumulativeDurations[selectedIndex].category
            let duration = cumulativeDurations[selectedIndex].range.upperBound - cumulativeDurations[selectedIndex].range.lowerBound
            print(cumulativeDurations)
            return (category, duration)
        }
        return nil
    }

    var body: some View {
        VStack {
            GroupBox("Screen Time ") {
                Chart(cumulativeDurations, id: \.category) {
                    SectorMark(
                        angle: .value("Duration", $0.range.upperBound - $0.range.lowerBound),
                        innerRadius: .ratio(selectedCategoryData?.category == $0.category ? 0.5 : 0.6),
                        outerRadius: .ratio(selectedCategoryData?.category == $0.category ? 1.0 : 0.9),
                        angularInset: 3.0
                    )
                    .cornerRadius(6.0)
                    .foregroundStyle(by: .value("category", $0.category))
                    .opacity(selectedCategoryData?.category == $0.category ? 1.0 : 0.9)
                }
                .chartForegroundStyleScale(
                    domain: cumulativeDurations.map { $0.category },
                    range: chartColors
                )
                .chartLegend(position: .bottom, alignment: .center)
                .chartAngleSelection(value: $selectedDuration)
                .chartBackground {_ in 
                    if let selectedCategoryData = selectedCategoryData {
                        VStack {
                            Text(selectedCategoryData.category)
                                .font(.headline)
                                .padding(.bottom, 1)
                            Text("\(selectedCategoryData.duration) minutes")
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                    }
                }
            }
            .frame(height: 500)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    InteractiveDonutView()
}
