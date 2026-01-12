//
//  WorkoutTrackerApp.swift
//  WorkoutTracker
//
//  Created by Evan King on 2025-12-30.
//

import SwiftUI

/// Main entry point for the WorkoutTracker application
/// This is the root of the app that initializes the SwiftUI scene
@main
struct WorkoutTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            // Sets WorkoutListView as the initial view shown when the app launches
            WorkoutListView()
        }
    }
}
