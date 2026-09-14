//
//  SubscriptionListView.swift
//  ProductX
//
//  Created by Akram on 14/9/26.
//

import SwiftUI

struct SubscriptionListView: View {
    @Environment(SubscriptionStore.self) private var store
    @State private var editing: Subscription?

    var body: some View {
        NavigationStack {
            Group {
                if store.subscriptions.isEmpty {
                    ContentUnavailableView {
                        Label("Nothing tracked yet", systemImage: "creditcard")
                    } description: {
                        Text("Add your first subscription to see what it costs you each year.")
                    } actions: {
                        Button("Add subscription") { editing = Subscription() }
                            .buttonStyle(.borderedProminent)
                    }
                } else {
                    List {
                        Section {
                            TotalsHeader(
                                monthly: store.totalMonthly,
                                yearly: store.totalYearly
                            )
                        }

                        Section("Upcoming") {
                            ForEach(store.sorted) { subscription in
                                Button {
                                    editing = subscription
                                } label: {
                                    SubscriptionRow(subscription: subscription)
                                }
                                .buttonStyle(.plain)
                                .swipeActions {
                                    Button("Delete", role: .destructive) {
                                        store.delete(subscription)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Subscriptions")
            .toolbar {
                Button {
                    editing = Subscription()
                } label: {
                    Label("Add subscription", systemImage: "plus")
                }
            }
            .sheet(item: $editing) { subscription in
                SubscriptionEditor(subscription: subscription)
            }
        }
    }
}

#Preview {
    SubscriptionListView()
        .environment(SubscriptionStore())
}
