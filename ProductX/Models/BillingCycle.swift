//
//  BillingCycle.swift
//  ProductX
//
//  Created by Akram on 14/9/26.
//

import Foundation

enum BillingCycle: String, Codable, CaseIterable, Identifiable {
    case weekly
    case monthly
    case quarterly
    case yearly

    var id: String { rawValue }

    var label: String {
        switch self {
        case .weekly: "Weekly"
        case .monthly: "Monthly"
        case .quarterly: "Quarterly"
        case .yearly: "Yearly"
        }
    }

    /// How many of this cycle fit into one month.
    /// Multiply a subscription's price by this to get its monthly cost.
    var monthlyFactor: Double {
        switch self {
        case .weekly: 52.0 / 12.0   // 52 weeks a year, not 4 a month
        case .monthly: 1
        case .quarterly: 1.0 / 3.0
        case .yearly: 1.0 / 12.0
        }
    }

    /// The calendar unit and step used to jump from one renewal to the next.
    var component: Calendar.Component {
        switch self {
        case .weekly: .day
        case .monthly, .quarterly: .month
        case .yearly: .year
        }
    }

    var step: Int {
        switch self {
        case .weekly: 7
        case .monthly: 1
        case .quarterly: 3
        case .yearly: 1
        }
    }
}
