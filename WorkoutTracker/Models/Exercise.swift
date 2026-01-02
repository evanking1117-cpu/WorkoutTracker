//
//  Exercise.swift
//  WorkoutTracker
//
//  Created by Evan King on 2025-12-30.
//

import Foundation

struct Exercise: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let muscleGroup: MuscleGroup
    let equipmentType: EquipmentType
    
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

enum MuscleGroup: String, Codable, CaseIterable {
    case chest, back, legs, shoulders, arms, core
}

enum EquipmentType: String, Codable {
    case bodyweight, barbell, dumbbell, machine, cable
}
