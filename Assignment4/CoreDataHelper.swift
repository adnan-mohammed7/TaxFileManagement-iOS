//
//  CoreDataHelper.swift
//  Assignment-4
//
//  Created by user278021 on 11/28/25.
//

import Foundation
internal import CoreData

class CoreDataHelper {
    static var context: NSManagedObjectContext { PersistenceController.shared.container.viewContext }
    
    static func isAdminEmpty() -> Bool{
        let fetchRequest = Admin.fetchRequest()
        do {
            let count = try context.count(for: fetchRequest)
            return count == 0
        } catch {
            return true
        }
    }
    
    static func createAdmins(){
        if(isAdminEmpty()){
            let newAdmin = Admin(context: context)
            
            newAdmin.username = "adnan7"
            newAdmin.password = "test123"
            
            try? context.save()
        }
    }
    
    static func saveCustomerToCoreData(customer: CustomerInputModel){
        let newCustomer = Customer(context: context)
        let geoCord = Geo(context: context)
        let newAddress = Address(context: context)
        let newCompany = Company(context: context)
        
        geoCord.lat = customer.lat
        geoCord.lng = customer.lng
        
        newAddress.street = customer.street
        newAddress.suite = customer.suite
        newAddress.city = customer.city
        newAddress.zipcode = customer.zipcode
        newAddress.geo = geoCord
        
        newCompany.name = customer.companyName
        newCompany.catchPhrase = customer.companyCatchPhrase
        newCompany.bs = customer.companyBs
        
        newCustomer.id = Int64(customer.id)
        newCustomer.name = customer.name
        newCustomer.username = customer.username
        newCustomer.email = customer.email
        newCustomer.password = customer.password
        newCustomer.phone = customer.phone
        newCustomer.website = customer.website
        newCustomer.address = newAddress
        newCustomer.company = newCompany
        newCustomer.status = "AWAITED"
        
        do {
            try context.save()
            print("Saved")
        } catch {
            print(error)
        }
    }
    
    static func nextCustomerId() -> Int64 {
        let request = Customer.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        request.fetchLimit = 1
        
        if let last = try? context.fetch(request).first {
            return last.id + 1
        } else {
            return 1
        }
    }
    
    
    static func validateAdmin(username: String, password: String) -> Bool {
        let request = Admin.fetchRequest()
        
        do {
            let admins = try context.fetch(request)
            for admin in admins {
                let adminUsername = admin.username ?? ""
                let adminPassword = admin.password ?? ""
                
                if adminUsername.caseInsensitiveCompare(username) == .orderedSame &&
                    adminPassword == password {
                    return true
                }
            }
            return false
        } catch {
            print(error)
            return false
        }
    }
    
    static func validateCustomer(username: String, password: String) -> Bool {
        let request = Customer.fetchRequest()
        
        do {
            let customers = try context.fetch(request)
            for customer in customers {
                let customerUsername = customer.username ?? ""
                let customerPassword = customer.password ?? ""
                
                if customerUsername.caseInsensitiveCompare(username) == .orderedSame &&
                    customerPassword == password {
                    return true
                }
            }
            return false
        } catch {
            print(error)
            return false
        }
    }
    
    static func updateCustomer(customer: Customer){
        do {
            try context.save()
            print("Customer updated from CustomerHomeView")
        } catch {
            print(error)
        }
    }
    
    static func getCustomer(username: String, password: String) -> Customer? {
        let request = Customer.fetchRequest()
        
        do {
            let customers = try context.fetch(request)
            for customer in customers {
                let customerUsername = customer.username ?? ""
                let customerPassword = customer.password ?? ""
                
                if customerUsername.caseInsensitiveCompare(username) == .orderedSame &&
                    customerPassword == password {
                    return customer
                }
            }
            return nil
        } catch {
            print(error)
            return nil
        }
    }
    
    static func getAllCustomers() -> [Customer] {
            let request = Customer.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

            do {
                return try context.fetch(request)
            } catch {
                print(error)
                return []
            }
        }
    
    static func deleteCustomer(_ customer: Customer) {
            context.delete(customer)
            do {
                try context.save()
            } catch {
                print(error)
            }
        }

}
