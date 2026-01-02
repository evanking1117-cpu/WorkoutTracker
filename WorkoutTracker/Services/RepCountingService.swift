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
    /// - Returns: A publisher that emits the current rep count as an integer
    var repCount: AnyPublisher<Int, Never> { get }
    
    /// Starts the rep counting process
    /// - Typically used to initialize sensors or start manual tracking
    func startCounting()
    
    /// Stops the rep counting process
    /// - Typically used to stop sensors or pause manual tracking
    func stopCounting()
    
    /// Resets the rep count to zero
    func reset()
    
    /// Source type for data tracking
    /// - Indicates whether the source is manual, Bluetooth, or AI vision
    var sourceType: RepCountSource { get }
}
