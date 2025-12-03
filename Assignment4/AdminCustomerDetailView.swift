//
//  AdminCustomerDetailView.swift
//  Assignment4
//
//  Created by user278021 on 12/2/25.
//

import SwiftUI
import MapKit

struct AdminCustomerDetailView: View {
    @ObservedObject var customer: Customer
    
    @State private var selectedStatus: String = "AWAITED"
    
    private var coordinate: CLLocationCoordinate2D? {
        if let latStr = customer.address?.geo?.lat,
           let lngStr = customer.address?.geo?.lng,
           let lat = Double(latStr),
           let lng = Double(lngStr) {
            return CLLocationCoordinate2D(latitude: lat, longitude: lng)
        }
        return nil
    }
    
    var body: some View {
        Form {
            Section(header: Text("Customer")) {
                Text(customer.name ?? "-")
                    .font(.headline)
                Text("Email: \(customer.email ?? "-")")
                Text("Phone: \(customer.phone ?? "-")")
                Text("Username: \(customer.username ?? "-")")
            }
            
            Section(header: Text("Address")) {
                Text("Street: \(customer.address?.street ?? "-")")
                Text("Suite: \(customer.address?.suite ?? "")")
                HStack {
                    Text(customer.address?.city ?? "-")
                    Text(customer.address?.zipcode ?? "")
                }
            }
            
            Section(header: Text("Company")) {
                Text("Company: \(customer.company?.name ?? "-")")
                Text("Catch Phrase: \(customer.company?.catchPhrase ?? "")")
                    .font(.subheadline)
                Text("BS: \(customer.company?.bs ?? "")")
                    .font(.footnote)
            }
            
            Section(header: Text("Process Status")) {
                Picker("Status", selection: $selectedStatus) {
                    Text("AWAITED").tag("AWAITED")
                    Text("FAILEDTOREACH").tag("FAILEDTOREACH")
                    Text("ONBOARDED").tag("ONBOARDED")
                    Text("INPROCESS").tag("INPROCESS")
                    Text("COMPLETED").tag("COMPLETED")
                    Text("DENIED").tag("DENIED")
                }
            }
            
            if let coord = coordinate {
                Section(header: Text("Location")) {
                    Map(initialPosition: .region(
                        MKCoordinateRegion(
                            center: coord,
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        )
                    )) {
                        Annotation("Customer", coordinate: coord) {
                            Circle()
                                .fill(Color.red)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 3)
                                )
                                .frame(width: 20, height: 20)
                                .shadow(radius: 3)
                        }
                    }
                    .frame(height: 220)
                }
            }
            
        }
        .navigationTitle("Customer Detail")
        .onAppear {
            selectedStatus = customer.status ?? "AWAITED"
        }
        .onChange(of: selectedStatus) { oldValue, newValue in
            customer.status = newValue
            CoreDataHelper.updateCustomer(customer: customer)
        }
    }
}
