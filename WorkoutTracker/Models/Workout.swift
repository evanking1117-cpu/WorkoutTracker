//
//  Workout.swift
//  WorkoutTracker
//
//  Created by Evan King on 2025-12-30.
//

import Foundation

// Represents a workout session
struct Workout: Identifiable, Codable {
    // Unique identifier for the workout
    let id: UUID
    // Start time of the workout
    let startTime: Date
    // End time of the workout (optional, nil if the workout is ongoing)
    var endTime: Date?
    // List of exercises performed during the workout
    var exercises: [ExerciseSession]
    
    // Computed property to calculate the duration of the workout
    // Returns nil if the workout is still active
    var duration: TimeInterval? {
        guard let end = endTime else { return nil }
        return end.timeIntervalSince(startTime)
    }
    
    // Computed property to check if the workout is still active
    var isActive: Bool {
        endTime == nil
    }
    
    // Computed property to calculate the total number of sets in the workout
    var totalSets: Int {
        exercises.reduce(0) { $0 + $1.sets.count }
    }
    
    // Initializer for creating a Workout instance
    // - Parameters:
    //   - id: Unique identifier (default is a new UUID)
    //   - startTime: Start time of the workout (default is the current date)
    //   - endTime: End time of the workout (optional, default is nil)
    //   - exercises: List of exercises performed (default is an empty array)
    init(
        id: UUID = UUID(),
        startTime: Date = Date(),
        endTime: Date? = nil,
        exercises: [ExerciseSession] = []
    ) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.exercises = exercises
    }
}

// Represents a session of a specific exercise within a workout
struct ExerciseSession: Identifiable, Codable {
    // Unique identifier for the exercise session
    let id: UUID
    // The exercise being performed
    let exercise: Exercise
    // List of sets performed for this exercise
    var sets: [WorkoutSet]
    // Timestamp when the exercise session was added
    let addedAt: Date
    
    // Initializer for creating an ExerciseSession instance
    // - Parameters:
    //   - id: Unique identifier (default is a new UUID)
    //   - exercise: The exercise being performed
    //   - sets: List of sets performed (default is an empty array)
    //   - addedAt: Timestamp when the session was added (default is the current date)
    init(
        id: UUID = UUID(),
        exercise: Exercise,
        sets: [WorkoutSet] = [],
        addedAt: Date = Date()
    ) {
        self.id = id
        self.exercise = exercise
        self.sets = sets
        self.addedAt = addedAt
    }
}
