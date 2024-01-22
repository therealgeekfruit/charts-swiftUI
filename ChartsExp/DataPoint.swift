//
//  DataPoint.swift
//  ChartsExp
//
//  Created by Sudeep Rao on 22/01/24.
//

import Foundation

struct ScreenTimeData: Identifiable {
    
    var id = UUID().uuidString
    var category: String
    var startTime: Int
    var duration: Int
}

struct ScreenTimeDataDonut: Identifiable {
    
    var id = UUID().uuidString
    var category: String
    var duration: Int
    
}
