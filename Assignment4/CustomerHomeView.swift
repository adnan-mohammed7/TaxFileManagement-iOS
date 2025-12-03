//
//  CustomerHomeView.swift
//  Assignment4
//
//  Created by user278021 on 12/2/25.
//

import SwiftUI

struct CustomerHomeView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var customer: Customer
    @StateObject private var geocoder = GeocodingManager()

    @State private var name = ""
    @State private var username = ""
    @State private var password = ""
    @State private var phone = ""
    @State private var website = ""

    @State private var street = ""
    @State private var suite = ""
    @State private var city = ""
    @State private var zipcode = ""

    @State private var companyName = ""
    @State private var companyCatchPhrase = ""
    @State private var companyBs = ""

    private func validString(_ value: String) -> Bool {
        !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var isFormValid: Bool {
        validString(name) &&
        validString(username) &&
        validString(password) &&
        validString(phone) &&
        validString(street) &&
        validString(city) &&
        validString(zipcode) &&
        validString(companyName)
    }

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Process status")) {
                    Text(customer.status ?? "Unknown")
                }

                Section(header: Text("Login info")) {
                    TextField("Name", text: $name)
                    TextField("Username", text: $username)
                        .autocapitalization(.none)

                    Text(customer.email ?? "")
                        .foregroundColor(.secondary)

                    SecureField("Password", text: $password)
                }

                Section(header: Text("Contact")) {
                    TextField("Phone", text: $phone)
                    TextField("Website", text: $website)
                        .autocapitalization(.none)
                }

                Section(header: Text("Address")) {
                    TextField("Street", text: $street)
                    TextField("Suite", text: $suite)
                    TextField("City", text: $city)
                    TextField("Zipcode", text: $zipcode)
                }

                Section(header: Text("Company")) {
                    TextField("Company name", text: $companyName)
                    TextField("Catch phrase", text: $companyCatchPhrase)
                    TextField("Business", text: $companyBs)
                }

                Section {
                    Button {
                        geocoder.fetchCoordinates(
                            street: street.trimmingCharacters(in: .whitespacesAndNewlines),
                            suite: suite.trimmingCharacters(in: .whitespacesAndNewlines),
                            city: city.trimmingCharacters(in: .whitespacesAndNewlines),
                            zipcode: zipcode.trimmingCharacters(in: .whitespacesAndNewlines)
                        )
                    } label: {
                        if geocoder.isLoading {
                            Text("Saving changes…")
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            Text("Save Changes")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .disabled(!isFormValid || geocoder.isLoading)
                    
                    Button("Logout") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
            }
            .navigationTitle("Home")
            .onAppear {
                name = customer.name ?? ""
                username = customer.username ?? ""
                password = customer.password ?? ""
                phone = customer.phone ?? ""
                website = customer.website ?? ""

                street = customer.address?.street ?? ""
                suite = customer.address?.suite ?? ""
                city = customer.address?.city ?? ""
                zipcode = customer.address?.zipcode ?? ""

                companyName = customer.company?.name ?? ""
                companyCatchPhrase = customer.company?.catchPhrase ?? ""
                companyBs = customer.company?.bs ?? ""
            }
            .onChange(of: geocoder.result) { oldValue, newValue in
                guard let geo = newValue else { return }

                let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
                let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
                let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
                let trimmedPhone = phone.trimmingCharacters(in: .whitespacesAndNewlines)
                let trimmedWebsite = website.trimmingCharacters(in: .whitespacesAndNewlines)
                let trimmedStreet = street.trimmingCharacters(in: .whitespacesAndNewlines)
                let trimmedSuite = suite.trimmingCharacters(in: .whitespacesAndNewlines)
                let trimmedCity = city.trimmingCharacters(in: .whitespacesAndNewlines)
                let trimmedZip = zipcode.trimmingCharacters(in: .whitespacesAndNewlines)
                let trimmedCompanyName = companyName.trimmingCharacters(in: .whitespacesAndNewlines)
                let trimmedCatch = companyCatchPhrase.trimmingCharacters(in: .whitespacesAndNewlines)
                let trimmedBs = companyBs.trimmingCharacters(in: .whitespacesAndNewlines)

                customer.name = trimmedName
                customer.username = trimmedUsername
                customer.password = trimmedPassword
                customer.phone = trimmedPhone
                customer.website = trimmedWebsite

                customer.address?.street = trimmedStreet
                customer.address?.suite = trimmedSuite
                customer.address?.city = trimmedCity
                customer.address?.zipcode = trimmedZip

                customer.address?.geo?.lat = geo.lat
                customer.address?.geo?.lng = geo.lng

                customer.company?.name = trimmedCompanyName
                customer.company?.catchPhrase = trimmedCatch
                customer.company?.bs = trimmedBs

                CoreDataHelper.updateCustomer(customer: customer)
            }
        }
    }
}
