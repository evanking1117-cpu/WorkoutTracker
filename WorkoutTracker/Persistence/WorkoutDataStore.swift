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
        
        if let encoded = try? JSONEncoder().encode(workouts) {
            userDefaults.set(encoded, forKey: workoutsKey)
        }
    }
    
    func loadWorkouts() -> [Workout] {
        guard let data = userDefaults.data(forKey: workoutsKey),
              let workouts = try? JSONDecoder().decode([Workout].self, from: data) else {
            return []
        }
        return workouts.sorted { $0.startTime > $1.startTime }
    }
    
    func deleteWorkout(_ workout: Workout) {
        var workouts = loadWorkouts()
        workouts.removeAll { $0.id == workout.id }
        
        if let encoded = try? JSONEncoder().encode(workouts) {
            userDefaults.set(encoded, forKey: workoutsKey)
        }
    }
    
    func clearAll() {
        userDefaults.removeObject(forKey: workoutsKey)
    }
}
