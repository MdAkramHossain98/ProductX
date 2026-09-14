//
//  Subscription.swift
//  ProductX
//
//  Created by Akram on 14/9/26.
//

import Foundation
import SwiftUI

struct Subscription: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String = ""
    var price: Double = 0
    var cycle: BillingCycle = .monthly
    /// Any known billing date — past or future. Everything else is derived from it.
    var anchorDate: Date = .now
    var tint: SubscriptionTint = .blue
    var remindersOn: Bool = true
    var remindDaysBefore: Int = 2
}

// MARK: - Cost

extension Subscription {
    var monthlyCost: Double {
        price * cycle.monthlyFactor
    }

    var yearlyCost: Double {
        monthlyCost * 12
    }
}

// MARK: - Renewal dates

extension Subscription {
    /// The next billing date on or after today.
    var nextRenewalDate: Date {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let anchor = calendar.startOfDay(for: anchorDate)

        if anchor >= today { return anchor }

        // Always add to the *original* anchor so we never drift.
        for period in 1...600 {
            guard let candidate = calendar.date(
                byAdding: cycle.component,
                value: cycle.step * period,
                to: anchor
            ) else { break }

            if candidate >= today { return candidate }
        }
        return anchor
    }

    var daysUntilRenewal: Int {
        Calendar.current.dateComponents(
            [.day],
            from: Calendar.current.startOfDay(for: .now),
            to: nextRenewalDate
        ).day ?? 0
    }

    var renewalDescription: String {
        switch daysUntilRenewal {
        case 0: "Renews today"
        case 1: "Renews tomorrow"
        default: "Renews in \(daysUntilRenewal) days"
        }
    }

    /// The next `count` billing dates, starting with `nextRenewalDate`.
    func upcomingRenewals(_ count: Int) -> [Date] {
        let calendar = Calendar.current
        let start = nextRenewalDate
        return (0..<count).compactMap { offset in
            calendar.date(
                byAdding: cycle.component,
                value: cycle.step * offset,
                to: start
            )
        }
    }
}

#Preview {
    let netflix = Subscription(
        name: "Netflix",
        price: 22.99,
        cycle: .monthly,
        anchorDate: Calendar.current.date(from: DateComponents(year: 2023, month: 3, day: 31))!
    )
    return VStack(alignment: .leading) {
        Text(netflix.nextRenewalDate.formatted(date: .long, time: .omitted))
        Text(netflix.renewalDescription)
        Text("Yearly: \(netflix.yearlyCost.formatted(.number.precision(.fractionLength(2))))")
    }
}
