//
//  ViewModel.swift
//  WorkoutTracker
//
//  Created by Evan King on 2025-12-30.
//

import Foundation
import Combine

final class WorkoutViewModel: ObservableObject {
    // MARK: - Published State
    @Published var currentWorkout: Workout?
    @Published var workoutHistory: [Workout] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Dependencies
    private let repCounter: RepCountingService
    private let dataStore: WorkoutDataStore
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(
        repCounter: RepCountingService = ManualRepCounter(),
        dataStore: WorkoutDataStore = WorkoutDataStore()
    ) {
        self.repCounter = repCounter
        self.dataStore = dataStore
        loadWorkoutHistory()
    }
    
    // MARK: - Workout Lifecycle
    func startWorkout() {
        currentWorkout = Workout()
        repCounter.startCounting()
    }
    
    func endWorkout() {
        guard var workout = currentWorkout else { return }
        workout.endTime = Date()
        
        dataStore.save(workout)
        workoutHistory.insert(workout, at: 0)
        currentWorkout = nil
        
        repCounter.stopCounting()
    }
    
    func addExercise(_ exercise: Exercise) {
        guard currentWorkout != nil else { return }
        let session = ExerciseSession(exercise: exercise)
        currentWorkout?.exercises.append(session)
    }
    
    // MARK: - Set Management
    func completeSet(
        exerciseIndex: Int,
        reps: Int,
        weight: Double?
    ) {
        guard currentWorkout != nil else { return }
        
        let set = WorkoutSet(
            reps: reps,
            weight: weight,
            source: repCounter.sourceType
        )
        
        currentWorkout?.exercises[exerciseIndex].sets.append(set)
        repCounter.reset()
    }
    
    func deleteSet(exerciseIndex: Int, setIndex: Int) {
        guard currentWorkout != nil else { return }
        currentWorkout?.exercises[exerciseIndex].sets.remove(at: setIndex)
    }
    
    // MARK: - Data Loading
    private func loadWorkoutHistory() {
        isLoading = true
        workoutHistory = dataStore.loadWorkouts()
        isLoading = false
    }
    
    func deleteWorkout(_ workout: Workout) {
        dataStore.deleteWorkout(workout)
        workoutHistory.removeAll { $0.id == workout.id }
    }
}
