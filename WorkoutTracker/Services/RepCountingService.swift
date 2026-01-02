//
//  RepCountingService.swift
//  WorkoutTracker
//
//  Created by Evan King on 2025-12-30.
//

import Foundation
import Combine

/// Protocol for any source that can count reps
/// V0.1: Manual buttons
/// V0.2: Bluetooth IMU sensor
/// V0.3: AI vision
protocol RepCountingService {
    /// Observable stream of rep count updates
    var repCount: AnyPublisher<Int, Never> { get }
    
    /// Lifecycle methods
    func startCounting()
    func stopCounting()
    func reset()
    
    /// Source type for data tracking
    var sourceType: RepCountSource { get }
}
