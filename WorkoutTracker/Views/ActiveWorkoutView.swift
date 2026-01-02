//
//  ActiveWorkoutView.swift
//  WorkoutTracker
//
//  Created by Evan King on 2025-12-31.
//

import SwiftUI

struct ActiveWorkoutView: View {
    // ViewModel to manage the workout state and interactions
    @ObservedObject var viewModel: WorkoutViewModel
    // State to control the visibility of the exercise picker sheet
    @State private var showingExercisePicker = false
    // State to track the selected exercise index for logging sets
    @State private var selectedExerciseIndex: Int?
    // State to control the visibility of the log set sheet
    @State private var showingLogSet = false
    // Environment variable to dismiss the current view
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Header section for the workout
            workoutHeader
            Divider()
            
            // Display the list of exercises if the workout has exercises
            if let workout = viewModel.currentWorkout, !workout.exercises.isEmpty {
                exerciseList
            } else {
                // Display an empty state if no exercises are added
                emptyState
            }
        }
        .navigationTitle("Active Workout") // Set the navigation title
        .navigationBarTitleDisplayMode(.inline) // Display the title inline
        .toolbar {
            // Toolbar button to end the workout
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("End Workout") {
                    viewModel.endWorkout() // End the workout session
                    dismiss() // Dismiss the view
                }
                .foregroundColor(.red) // Set the button color to red
            }
        }
        // Sheet for selecting an exercise
        .sheet(isPresented: $showingExercisePicker) {
            ExercisePickerView(viewModel: viewModel)
        }
        // Sheet for logging a set for a specific exercise
        .sheet(isPresented: $showingLogSet) {
            if let index = selectedExerciseIndex,
               let workout = viewModel.currentWorkout,
               index < workout.exercises.count {
                LogSetView(
                    viewModel: viewModel,
                    exerciseIndex: index,
                    exercise: workout.exercises[index].exercise
                )
            }
        }
    }
    
    // Header section for the workout view
    private var workoutHeader: some View {
        // Add header content here (e.g., workout details, timer, etc.)
    }
}
