//
//  TotalsHeader.swift
//  ProductX
//
//  Created by Akram on 14/9/26.
//

import SwiftUI

struct TotalsHeader: View {
    let monthly: Double
    let yearly: Double

    var body: some View {
        HStack {
            total("Per month", monthly)
            Divider()
            total("Per year", yearly)
        }
        .padding(.vertical, 8)
    }

    private func total(_ caption: String, _ amount: Double) -> some View {
        VStack(spacing: 4) {
            Text(amount, format: .currency(code: currencyCode))
                .font(.title2.weight(.semibold))
                .contentTransition(.numericText())
            Text(caption)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
