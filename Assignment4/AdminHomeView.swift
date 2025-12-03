//
//  AdminHomeView.swift
//  Assignment4
//
//  Created by user278021 on 12/2/25.
//

import SwiftUI

struct AdminHomeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var customers: [Customer] = []
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Customers")) {
                    ForEach(customers, id: \.objectID) { customer in
                        NavigationLink {
                            AdminCustomerDetailView(customer: customer)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(customer.name ?? "Unknown")
                                        .font(.headline)
                                    Spacer()
                                    Text(customer.status ?? "AWAITED")
                                        .font(.caption)
                                        .padding(4)
                                        .background(Color.black.opacity(0.1))
                                        .cornerRadius(4)
                                }
                                Text(customer.phone ?? "-")
                                    .font(.subheadline)
                                
                                HStack {
                                    Text(customer.address?.city ?? "-")
                                }
                                .foregroundColor(.secondary)
                            }
                        }
                        .listRowBackground(backgroundColor(for: customer.status))
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            CoreDataHelper.deleteCustomer(customers[index])
                        }
                    }
                }
                
                Section {
                    Button("Logout") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Admin Home")
            .onAppear {
                customers = CoreDataHelper.getAllCustomers()
            }
        }
    }
    
    private func backgroundColor(for status: String?) -> Color {
        switch status?.uppercased() {
        case "AWAITED":        return Color.yellow.opacity(0.4)
        case "FAILEDTOREACH":  return Color.red.opacity(0.3)
        case "ONBOARDED":      return Color.green.opacity(0.3)
        case "INPROCESS":      return Color.green.opacity(0.6)
        case "COMPLETED":      return Color.green
        case "DENIED":         return Color.red
        default:               return Color.gray.opacity(0.2)
        }
    }
    
}

