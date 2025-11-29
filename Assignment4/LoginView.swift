import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isAdminLogin = false
    @State private var message: String?
    
    private func validString(_ value: String) -> Bool {
        !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var isFormValid: Bool {
        validString(username) && validString(password)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Login type")) {
                    Toggle(isOn: $isAdminLogin) {
                        Text("Admin Login")
                    }
                }
                
                Section(header: Text("Credentials")) {
                    TextField("Username", text: $username)
                        .autocapitalization(.none)
                    SecureField("Password", text: $password)
                }
                
                Section {
                    Button("Login") {
                        handleLogin()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .disabled(!isFormValid)
                }
                
                if let message = message {
                    Section {
                        Text(message)
                            .foregroundColor(message.contains("does not exist") ? .red : .green)
                    }
                }
            }
            .navigationTitle("Login")
            .onAppear {
                CoreDataHelper.createAdmins()
            }
            .onChange(of: username) {
                message = nil
            }
            .onChange(of: password) {
                message = nil
            }
            .onChange(of: isAdminLogin) {
                message = nil
            }
        }
    }
    
    private func handleLogin() {
        let trimmedUser = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPass = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isAdminLogin {
            if CoreDataHelper.validateAdmin(username: trimmedUser, password: trimmedPass) {
                message = "Admin access"
                print("Admin access")
            } else {
                message = "Admin with these credentials does not exist."
            }
        } else {
            if CoreDataHelper.validateCustomer(username: trimmedUser, password: trimmedPass) {
                message = "Customer access"
                print("Customer")
            } else {
                message = "Customer with these credentials does not exist."
            }
        }
    }
}
