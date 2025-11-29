//
//  RegistrationView.swift
//  Assignment4
//
//  Created by user278021 on 11/28/25.
//

import SwiftUI

struct RegistrationView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var geocoder = GeocodingManager()
    
    @State private var name = ""
    @State private var username = ""
    @State private var email = ""
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
        validString(email) &&
        validString(password) &&
        validString(phone) &&
        validString(street) &&
        validString(city) &&
        validString(zipcode) &&
        validString(companyName)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Login info")) {
                    TextField("Name", text: $name)
                    TextField("Username", text: $username)
                        .autocapitalization(.none)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
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
                            Text("Validating info")
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            Text("Create Account")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .disabled(!isFormValid || geocoder.isLoading)
                }
            }
            .navigationTitle("Register")
            .onChange(of: geocoder.result) { oldValue, newValue in
                guard let geo = newValue else { return }

                let customerInput = CustomerInputModel(
                    id: CoreDataHelper.nextCustomerId(),
                    name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                    username: username.trimmingCharacters(in: .whitespacesAndNewlines),
                    email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                    password: password.trimmingCharacters(in: .whitespacesAndNewlines),
                    phone: phone.trimmingCharacters(in: .whitespacesAndNewlines),
                    website: website.trimmingCharacters(in: .whitespacesAndNewlines),
                    street: street.trimmingCharacters(in: .whitespacesAndNewlines),
                    suite: suite.trimmingCharacters(in: .whitespacesAndNewlines),
                    city: city.trimmingCharacters(in: .whitespacesAndNewlines),
                    zipcode: zipcode.trimmingCharacters(in: .whitespacesAndNewlines),
                    lat: geo.lat,
                    lng: geo.lng,
                    companyName: companyName.trimmingCharacters(in: .whitespacesAndNewlines),
                    companyCatchPhrase: companyCatchPhrase.trimmingCharacters(in: .whitespacesAndNewlines),
                    companyBs: companyBs.trimmingCharacters(in: .whitespacesAndNewlines)
                )

                CoreDataHelper.saveCustomerToCoreData(customer: customerInput)
                dismiss()
            }
        }
    }
}

#Preview {
    RegistrationView()
}
