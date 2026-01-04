//
//  WorkoutTemplate.swift
//  WorkoutTracker
//
//  Created by Claude on 2026-01-04.
//

import Foundation

/// A template for creating pre-planned workouts
struct WorkoutTemplate: Identifiable, Codable, Hashable {
    /// Unique identifier for the template
    let id: UUID

    /// Name of the template (e.g., "Push Day", "Leg Day")
    var name: String

    /// List of exercises with target set counts
    var exercises: [TemplateExercise]

    /// Date the template was created
    let createdAt: Date

    /// Date the template was last modified
    var lastModified: Date

    /// Initialize a new workout template
    init(
        id: UUID = UUID(),
        name: String,
        exercises: [TemplateExercise] = [],
        createdAt: Date = Date(),
        lastModified: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.exercises = exercises
        self.createdAt = createdAt
        self.lastModified = lastModified
    }

    /// Total number of sets planned in this template
    var totalSets: Int {
        exercises.reduce(0) { $0 + $1.targetSets }
    }
}

/// An exercise within a template with a target number of sets
struct TemplateExercise: Identifiable, Codable, Hashable {
    /// Unique identifier for this template exercise
    let id: UUID

    /// The exercise to perform
    let exercise: Exercise

    /// Target number of sets to complete
    var targetSets: Int

    /// Optional notes for this exercise (e.g., "3x10", "Drop sets")
    var notes: String?

    /// Initialize a new template exercise
    init(
        id: UUID = UUID(),
        exercise: Exercise,
        targetSets: Int,
        notes: String? = nil
    ) {
        self.id = id
        self.exercise = exercise
        self.targetSets = targetSets
        self.notes = notes
    }
}
