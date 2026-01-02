//
//  WorkoutDataStore.swift
//  WorkoutTracker
//
//  Created by Evan King on 2025-12-30.
//

import Foundation

final class WorkoutDataStore {
    private let userDefaults = UserDefaults.standard
    private let workoutsKey = "savedWorkouts"
    
    func save(_ workout: Workout) {
        var workouts = loadWorkouts()
        workouts.append(workout)
        
        // Saves the updated list of workouts to UserDefaults
        if let encoded = try? JSONEncoder().encode(workouts) {
            userDefaults.set(encoded, forKey: workoutsKey)
        }
    }
    
    // Loads all saved workouts from UserDefaults
    // - Returns: An array of workouts, sorted by start time in descending order
    func loadWorkouts() -> [Workout] {
        // Retrieve the data for the workouts key
        guard let data = userDefaults.data(forKey: workoutsKey),
              // Decode the data into an array of Workout objects
              let workouts = try? JSONDecoder().decode([Workout].self, from: data) else {
            // Return an empty array if no data is found or decoding fails
            return []
        }
        // Return the workouts sorted by start time (most recent first)
        return workouts.sorted { $0.startTime > $1.startTime }
    }
    
    // Deletes a specific workout from the data store
    // - Parameter workout: The workout to be deleted
    func deleteWorkout(_ workout: Workout) {
        // Load existing workouts
        var workouts = loadWorkouts()
        // Remove the workout with the matching ID
        workouts.removeAll { $0.id == workout.id }
        
        // Save the updated list of workouts back to UserDefaults
        if let encoded = try? JSONEncoder().encode(workouts) {
            userDefaults.set(encoded, forKey: workoutsKey)
        }
    }
    
    // Clears all saved workouts from UserDefaults
    func clearAll() {
        // Remove the workouts key from UserDefaults
        userDefaults.removeObject(forKey: workoutsKey)
    }
}
