//
//  DonutChartView.swift
//  ChartsExp
//
//  Created by Sudeep Rao on 18/01/24.
//

import SwiftUI
import Charts

struct DonutChartView: View {
    
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

    
    var aggregatedData: [ScreenTimeData] {
            Dictionary(grouping: data, by: { $0.category })
                .mapValues { $0.reduce(0) { $0 + $1.duration } }
                .map { ScreenTimeData(category: $0.key, startTime: 0, duration: $0.value) }
        }
    
    var body: some View {
        Chart {
            ForEach (aggregatedData) { d in
                SectorMark(angle: .value("Hours", d.duration),
                           innerRadius: .ratio(0.7),
                           angularInset: 2)
                    .foregroundStyle(by: .value("Category", d.category))
                    .cornerRadius(40)
            }
        }.padding(.horizontal, 60)
    }
}

#Preview {
    DonutChartView()
}
