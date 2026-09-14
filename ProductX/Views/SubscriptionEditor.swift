//
//  SubscriptionEditor.swift
//  ProductX
//
//  Created by Akram on 14/9/26.
//

import SwiftUI

struct SubscriptionEditor: View {
    @Environment(SubscriptionStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    /// A local copy. Nothing is saved until you tap Save.
    @State private var draft: Subscription

    private let isNew: Bool

    init(subscription: Subscription) {
        _draft = State(initialValue: subscription)
        self.isNew = subscription.name.isEmpty
    }

    private var canSave: Bool {
        !draft.name.trimmingCharacters(in: .whitespaces).isEmpty && draft.price > 0
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $draft.name)
                    TextField("Price", value: $draft.price, format: .currency(code: currencyCode))
                        .keyboardType(.decimalPad)
                    Picker("Billing", selection: $draft.cycle) {
                        ForEach(BillingCycle.allCases) { cycle in
                            Text(cycle.label).tag(cycle)
                        }
                    }
                    DatePicker(
                        "Next bill",
                        selection: $draft.anchorDate,
                        displayedComponents: .date
                    )
                }

                Section("Colour") {
                    HStack(spacing: 12) {
                        ForEach(SubscriptionTint.allCases) { tint in
                            Circle()
                                .fill(tint.color.gradient)
                                .frame(width: 28, height: 28)
                                .overlay {
                                    if tint == draft.tint {
                                        Image(systemName: "checkmark")
                                            .font(.caption.bold())
                                            .foregroundStyle(.white)
                                    }
                                }
                                .onTapGesture { draft.tint = tint }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }

                Section("Reminder") {
                    Toggle("Remind me before it renews", isOn: $draft.remindersOn)
                    if draft.remindersOn {
                        Stepper(
                            "\(draft.remindDaysBefore) day\(draft.remindDaysBefore == 1 ? "" : "s") before",
                            value: $draft.remindDaysBefore,
                            in: 0...14
                        )
                    }
                }

                if canSave {
                    Section {
                        LabeledContent(
                            "Costs you per year",
                            value: draft.yearlyCost,
                            format: .currency(code: currencyCode)
                        )
                    }
                }

                if !isNew {
                    Section {
                        Button("Delete subscription", role: .destructive) {
                            store.delete(draft)
                            dismiss()
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle(isNew ? "New subscription" : draft.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        draft.name = draft.name.trimmingCharacters(in: .whitespaces)
                        store.save(draft)
                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }
}

#Preview {
    SubscriptionEditor(subscription: Subscription())
        .environment(SubscriptionStore())
}
