//
//  Assignment4App.swift
//  Assignment4
//
//  Created by user278021 on 11/28/25.
//

import SwiftUI
internal import CoreData

@main
struct Assignment4App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LoginView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
