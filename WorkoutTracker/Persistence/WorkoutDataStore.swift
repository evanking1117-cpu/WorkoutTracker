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
    private let templatesKey = "workoutTemplates"
    private let customExercisesKey = "customExercises"
    
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

    // MARK: - Template Management

    /// Saves a workout template to UserDefaults
    func save(_ template: WorkoutTemplate) {
        var templates = loadTemplates()

        // Update existing template or add new one
        if let index = templates.firstIndex(where: { $0.id == template.id }) {
            templates[index] = template
        } else {
            templates.append(template)
        }

        if let encoded = try? JSONEncoder().encode(templates) {
            userDefaults.set(encoded, forKey: templatesKey)
        }
    }

    /// Loads all saved templates from UserDefaults
    func loadTemplates() -> [WorkoutTemplate] {
        guard let data = userDefaults.data(forKey: templatesKey),
              let templates = try? JSONDecoder().decode([WorkoutTemplate].self, from: data) else {
            return []
        }
        return templates.sorted { $0.name < $1.name }
    }

    /// Deletes a specific template from the data store
    func deleteTemplate(_ template: WorkoutTemplate) {
        var templates = loadTemplates()
        templates.removeAll { $0.id == template.id }

        if let encoded = try? JSONEncoder().encode(templates) {
            userDefaults.set(encoded, forKey: templatesKey)
        }
    }

    /// Clears all saved templates from UserDefaults
    func clearAllTemplates() {
        userDefaults.removeObject(forKey: templatesKey)
    }

    // MARK: - Custom Exercise Management

    /// Saves a custom exercise to UserDefaults
    func save(_ exercise: Exercise) {
        var exercises = loadCustomExercises()

        // Update existing exercise or add new one
        if let index = exercises.firstIndex(where: { $0.id == exercise.id }) {
            exercises[index] = exercise
        } else {
            exercises.append(exercise)
        }

        if let encoded = try? JSONEncoder().encode(exercises) {
            userDefaults.set(encoded, forKey: customExercisesKey)
        }
    }

    /// Loads all custom exercises from UserDefaults
    func loadCustomExercises() -> [Exercise] {
        guard let data = userDefaults.data(forKey: customExercisesKey),
              let exercises = try? JSONDecoder().decode([Exercise].self, from: data) else {
            return []
        }
        return exercises.sorted { $0.name < $1.name }
    }

    /// Deletes a custom exercise from the data store
    func deleteCustomExercise(_ exercise: Exercise) {
        var exercises = loadCustomExercises()
        exercises.removeAll { $0.id == exercise.id }

        if let encoded = try? JSONEncoder().encode(exercises) {
            userDefaults.set(encoded, forKey: customExercisesKey)
        }
    }

    /// Clears all custom exercises from UserDefaults
    func clearAllCustomExercises() {
        userDefaults.removeObject(forKey: customExercisesKey)
    }
}
