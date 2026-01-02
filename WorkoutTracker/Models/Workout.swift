//
//  Workout.swift
//  WorkoutTracker
//
//  Created by Evan King on 2025-12-30.
//

import Foundation

struct Workout: Identifiable, Codable {
    let id: UUID
    let startTime: Date
    var endTime: Date?
    var exercises: [ExerciseSession]
    
    var duration: TimeInterval? {
        guard let end = endTime else { return nil }
        return end.timeIntervalSince(startTime)
    }
    
    var isActive: Bool {
        endTime == nil
    }
    
    var totalSets: Int {
        exercises.reduce(0) { $0 + $1.sets.count }
    }
    
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

struct ExerciseSession: Identifiable, Codable {
    let id: UUID
    let exercise: Exercise
    var sets: [WorkoutSet]
    let addedAt: Date
    
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
