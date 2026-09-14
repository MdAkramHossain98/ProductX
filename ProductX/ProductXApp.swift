//
//  ProductXApp.swift
//  ProductX
//
//  Created by Akram on 14/9/26.
//

import SwiftUI

@main
struct ProductXApp: App {
    @State private var store = SubscriptionStore()
    var body: some Scene {
        WindowGroup {
            SubscriptionListView()
                .environment(store)        }
    }
}
