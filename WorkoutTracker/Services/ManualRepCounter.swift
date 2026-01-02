//
//  ManualRepCounter.swift
//  WorkoutTracker
//
//  Created by Evan King on 2025-12-30.
//

import Foundation
import Combine

final class ManualRepCounter: RepCountingService, ObservableObject {
    @Published private var currentReps: Int = 0
    
    var repCount: AnyPublisher<Int, Never> {
        $currentReps.eraseToAnyPublisher()
    }
    
    var sourceType: RepCountSource { .manual }
    
    func startCounting() {
        // No-op for manual, but Bluetooth will need this
    }
    
    func stopCounting() {
        // No-op for manual, but Bluetooth will need this
    }
    
    func reset() {
        currentReps = 0
    }
    
    // V0.1 specific: manual controls
    func incrementRep() {
        currentReps += 1
    }
    
    func decrementRep() {
        guard currentReps > 0 else { return }
        currentReps -= 1
    }
}
