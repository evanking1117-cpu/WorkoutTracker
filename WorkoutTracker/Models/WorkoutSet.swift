//
//  Untitled.swift
//  WorkoutTracker
//
//  Created by Evan King on 2025-12-30.
//

import Foundation

struct WorkoutSet: Identifiable, Codable {
    let id: UUID
    let reps: Int
    let weight: Double?
    let timestamp: Date
    let source: RepCountSource
    
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

enum RepCountSource: String, Codable {
    case manual
    case bluetooth
    case aiVision
}
