//
//  Exercise.swift
//  WorkoutTracker
//
//  Created by Evan King on 2025-12-30.
//

import Foundation

// Represents an exercise in the workout tracker
struct Exercise: Identifiable, Codable, Hashable {
    // Unique identifier for the exercise
    let id: UUID
    // Name of the exercise (e.g., "Bench Press")
    let name: String
    // Primary muscle group targeted by the exercise
    let muscleGroup: MuscleGroup
    // Type of equipment required for the exercise
    let equipmentType: EquipmentType
    
    // Initializer for creating an Exercise instance
    // - Parameters:
    //   - id: Unique identifier (default is a new UUID)
    //   - name: Name of the exercise
    //   - muscleGroup: Muscle group targeted
    //   - equipmentType: Equipment type (default is .bodyweight)
    init(
        id: UUID = UUID(),
        name: String,
        muscleGroup: MuscleGroup,
        equipmentType: EquipmentType = .bodyweight
    ) {
        self.id = id
        self.name = name
        self.muscleGroup = muscleGroup
        self.equipmentType = equipmentType
    }
}

// Enum representing the primary muscle groups targeted by exercises
enum MuscleGroup: String, Codable, CaseIterable {
    case chest, back, legs, shoulders, arms, core
}

// Enum representing the types of equipment used for exercises
enum EquipmentType: String, Codable, CaseIterable {
    case bodyweight, barbell, dumbbell, machine, cable
}
