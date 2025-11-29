//
//  ContentView.swift
//  Assignment-4
//
//  Created by user278021 on 11/28/25.
//

import SwiftUI
internal import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @StateObject private var geocoder = GeocodingManager()
    
    var body: some View {
        VStack {
            Button("Geocode CN Tower") {
                geocoder.fetchCoordinates(
                    street: "290 Bremner Blvd",
                    suite: "",
                    city: "Toronto",
                    zipcode: "M5V 3L9"
                )
            }
            .buttonStyle(.borderedProminent)
            
            if geocoder.isLoading {
                Text("Geocoding...")
            } else if let result = geocoder.result {
                Text("lat: \(result.lat)")
                Text("lng: \(result.lng)")
            }
        }
        .padding()
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
