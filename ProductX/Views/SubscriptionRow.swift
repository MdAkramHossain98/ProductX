//
//  SubscriptionRow.swift
//  ProductX
//
//  Created by Akram on 14/9/26.
//

import SwiftUI

struct SubscriptionRow: View {
    let subscription: Subscription

    var body: some View {
        HStack(spacing: 14) {
            Circle()
                .fill(subscription.tint.color.gradient)
                .frame(width: 38, height: 38)
                .overlay {
                    Text(subscription.name.prefix(1).uppercased())
                        .font(.headline)
                        .foregroundStyle(.white)
                }

            VStack(alignment: .leading, spacing: 2) {
                Text(subscription.name)
                    .font(.body.weight(.medium))
                Text(subscription.renewalDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(subscription.price, format: .currency(code: currencyCode))
                    .font(.body.weight(.medium))
                Text(subscription.cycle.label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

/// The user's local currency, falling back to AUD.
let currencyCode = Locale.current.currency?.identifier ?? "AUD"
