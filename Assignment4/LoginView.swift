import SwiftUI

enum AdminRoute: Hashable {
    case adminHome
}

enum AuthRoute: Hashable {
    case signUp
}

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isAdminLogin = false
    @State private var message: String?
    
    @State private var path = NavigationPath()
    
    private func validString(_ value: String) -> Bool {
        !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var isFormValid: Bool {
        validString(username) && validString(password)
    }
    
    var body: some View {
        NavigationStack(path: $path) {
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
                    
                    Button("Sign Up") {
                        path.append(AuthRoute.signUp)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
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
            .navigationDestination(for: Customer.self) { customer in
                CustomerHomeView(customer: customer)
            }
            .navigationDestination(for: AdminRoute.self) { route in
                switch route {
                case .adminHome:
                    AdminHomeView()
                }
            }
            .navigationDestination(for: AuthRoute.self) { route in
                switch route {
                case .signUp:
                    RegistrationView()
                }
            }
        }
    }
    
    private func handleLogin() {
        let trimmedUser = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPass = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isAdminLogin {
            if CoreDataHelper.validateAdmin(username: trimmedUser, password: trimmedPass) {
                print("Admin access")
                path.append(AdminRoute.adminHome)
            } else {
                message = "Admin with these credentials does not exist."
            }
        } else {
            if let customer = CoreDataHelper.getCustomer(username: trimmedUser, password: trimmedPass) {
                print("Customer")
                path.append(customer)
                
            } else {
                message = "Customer with these credentials does not exist."
            }
        }
    }
}
