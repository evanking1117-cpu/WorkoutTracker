//
//  ManualRepCounter.swift
//  WorkoutTracker
//
//  Created by Evan King on 2025-12-30.
//

import Foundation
import Combine

// A manual implementation of the RepCountingService
// Allows users to manually increment or decrement the rep count
final class ManualRepCounter: RepCountingService, ObservableObject {
    // Published property to track the current number of reps
    @Published private var currentReps: Int = 0
    
    // Publisher to expose the current rep count to subscribers
    var repCount: AnyPublisher<Int, Never> {
        $currentReps.eraseToAnyPublisher()
    }
    
    // The source type for this rep counter (manual entry)
    var sourceType: RepCountSource { .manual }
    
    // Starts the rep counting process (no-op for manual counting)
    func startCounting() {
        // No-op for manual, but Bluetooth will need this
    }
    
    // Stops the rep counting process (no-op for manual counting)
    func stopCounting() {
        // No-op for manual, but Bluetooth will need this
    }
    
    // Resets the rep count to zero
    func reset() {
        currentReps = 0
    }
    
    // Increments the rep count by 1
    func incrementRep() {
        currentReps += 1
    }
    
    // Decrements the rep count by 1, ensuring it doesn't go below zero
    func decrementRep() {
        guard currentReps > 0 else { return }
        currentReps -= 1
    }
}
