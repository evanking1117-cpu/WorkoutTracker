//
//  Untitled.swift
//  WorkoutTracker
//
//  Created by Evan King on 2025-12-30.
//

import Foundation

// Represents a single set performed during a workout
struct WorkoutSet: Identifiable, Codable {
    // Unique identifier for the workout set
    let id: UUID
    // Number of repetitions performed in the set
    let reps: Int
    // Weight used for the set (optional, nil if bodyweight or unspecified)
    let weight: Double?
    // Timestamp when the set was performed
    let timestamp: Date
    // Source of the rep count (e.g., manual entry, Bluetooth device, AI vision)
    let source: RepCountSource
    
    // Initializer for creating a WorkoutSet instance
    // - Parameters:
    //   - id: Unique identifier (default is a new UUID)
    //   - reps: Number of repetitions performed
    //   - weight: Weight used for the set (optional, default is nil)
    //   - timestamp: Timestamp when the set was performed (default is the current date)
    //   - source: Source of the rep count (default is .manual)
    init(
        id: UUID = UUID(),
        reps: Int,
        weight: Double? = nil,
        timestamp: Date = Date(),
        source: RepCountSource = .manual
    ) {
        self.id = id
        self.reps = reps
        self.weight = weight
        self.timestamp = timestamp
        self.source = source
    }
}

// Enum representing the source of the rep count
enum RepCountSource: String, Codable {
    // Rep count was entered manually by the user
    case manual
    // Rep count was recorded via a Bluetooth device
    case bluetooth
    // Rep count was detected using AI vision
    case aiVision
}
