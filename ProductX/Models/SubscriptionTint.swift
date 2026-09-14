//
//  SubscriptionTint.swift
//  ProductX
//
//  Created by Akram on 14/9/26.
//

import SwiftUI

enum SubscriptionTint: String, Codable, CaseIterable, Identifiable {
    case red, orange, yellow, green, teal, blue, indigo, pink

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .red: .red
        case .orange: .orange
        case .yellow: .yellow
        case .green: .green
        case .teal: .teal
        case .blue: .blue
        case .indigo: .indigo
        case .pink: .pink
        }
    }
}
