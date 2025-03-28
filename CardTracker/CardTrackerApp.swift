//
//  CardTrackerApp.swift
//  CardTracker
//
//  Created by Andrew Haglund on 3/28/25.
//

import SwiftUI
import SwiftData

@main
struct CardTrackerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Deck.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
