//
//  SubscriptionStore.swift
//  ProductX
//
//  Created by Akram on 14/9/26.
//

import Foundation
import Observation

@Observable
final class SubscriptionStore {
    private(set) var subscriptions: [Subscription] = []

    private let fileURL: URL = {
        URL.documentsDirectory.appending(path: "subscriptions.json")
    }()

    init() {
        load()
    }

    // MARK: - Derived values

    /// Soonest renewal first.
    var sorted: [Subscription] {
        subscriptions.sorted { $0.nextRenewalDate < $1.nextRenewalDate }
    }

    var totalMonthly: Double {
        subscriptions.reduce(0) { $0 + $1.monthlyCost }
    }

    var totalYearly: Double {
        totalMonthly * 12
    }

    // MARK: - Editing

    func save(_ subscription: Subscription) {
        if let index = subscriptions.firstIndex(where: { $0.id == subscription.id }) {
            subscriptions[index] = subscription
        } else {
            subscriptions.append(subscription)
        }
        persist()
    }

    func delete(_ subscription: Subscription) {
        subscriptions.removeAll { $0.id == subscription.id }
        persist()
    }

    // MARK: - Disk

    private func persist() {
        do {
            let data = try JSONEncoder().encode(subscriptions)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Couldn't save subscriptions: \(error)")
        }
    }

    private func load() {
        do {
            let data = try Data(contentsOf: fileURL)
            subscriptions = try JSONDecoder().decode([Subscription].self, from: data)
        } catch {
            subscriptions = []   // First launch, nothing saved yet.
        }
    }
}
