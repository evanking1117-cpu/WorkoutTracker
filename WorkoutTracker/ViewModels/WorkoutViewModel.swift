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
    @Published var workoutTemplates: [WorkoutTemplate] = []
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
        loadTemplates()
    }
    
    // MARK: - Workout Lifecycle
    func startWorkout() {
        currentWorkout = Workout()
        repCounter.startCounting()
    }

    /// Starts a new workout from a template
    func startWorkout(from template: WorkoutTemplate) {
        var workout = Workout()

        // Add all exercises from template
        for templateExercise in template.exercises {
            let session = ExerciseSession(exercise: templateExercise.exercise)
            workout.exercises.append(session)
        }

        currentWorkout = workout
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
        // Ensure there is an active workout
        guard currentWorkout != nil else { return }
        // Remove the set at the specified index from the exercise session
        currentWorkout?.exercises[exerciseIndex].sets.remove(at: setIndex)
    }
    
    // MARK: - Data Loading
    // Loads the workout history from the data store
    private func loadWorkoutHistory() {
        isLoading = true // Set loading state to true
        workoutHistory = dataStore.loadWorkouts() // Load workouts from the data store
        isLoading = false // Set loading state to false
    }
    
    // Deletes a workout from the history and the data store
    // - Parameter workout: The workout to be deleted
    func deleteWorkout(_ workout: Workout) {
        dataStore.deleteWorkout(workout) // Delete the workout from the data store
        workoutHistory.removeAll { $0.id == workout.id } // Remove the workout from the history
    }

    // MARK: - Template Management

    /// Loads all templates from the data store
    private func loadTemplates() {
        workoutTemplates = dataStore.loadTemplates()
    }

    /// Saves a workout template
    func saveTemplate(_ template: WorkoutTemplate) {
        dataStore.save(template)
        loadTemplates()
    }

    /// Deletes a template from the data store
    func deleteTemplate(_ template: WorkoutTemplate) {
        dataStore.deleteTemplate(template)
        workoutTemplates.removeAll { $0.id == template.id }
    }

    /// Saves the current workout as a template
    func saveCurrentWorkoutAsTemplate(name: String) -> WorkoutTemplate? {
        guard let workout = currentWorkout, !workout.exercises.isEmpty else { return nil }

        let templateExercises = workout.exercises.map { session in
            TemplateExercise(
                exercise: session.exercise,
                targetSets: session.sets.count
            )
        }

        let template = WorkoutTemplate(name: name, exercises: templateExercises)
        saveTemplate(template)
        return template
    }
}
