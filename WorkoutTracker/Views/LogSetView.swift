//
//  LogSetView.swift
//  WorkoutTracker
//
//  Created by Evan King on 2025-12-31.
//

import SwiftUI

/// View for logging a set during a workout
/// Allows users to enter reps and weight for a specific exercise
/// Note: This view is not currently used in the app. Set logging is done inline in ActiveWorkoutView.
struct LogSetView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    // Index of the exercise in the current workout
    let exerciseIndex: Int
    // The exercise for which the set is being logged
    let exercise: Exercise

    @Environment(\.dismiss) private var dismiss

    // State for reps input
    @State private var reps: String = ""
    // State for weight input
    @State private var weight: String = ""
    // Focus state to manage keyboard focus between fields
    @FocusState private var focusedField: Field?

    /// Enum to represent the fields that can have keyboard focus
    enum Field {
        case reps, weight
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Set Details")) {
                    HStack {
                        Text("Reps")
                            .frame(width: 80, alignment: .leading)
                        TextField("0", text: $reps)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .reps)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    if exercise.equipmentType != .bodyweight {
                        HStack {
                            Text("Weight (lbs)")
                                .frame(width: 80, alignment: .leading)
                            TextField("0", text: $weight)
                                .keyboardType(.decimalPad)
                                .focused($focusedField, equals: .weight)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                }
                
                Section {
                    Button(action: saveSet) {
                        Text("Save Set")
                            .frame(maxWidth: .infinity)
                            .font(.headline)
                    }
                    .disabled(reps.isEmpty || Int(reps) == nil || Int(reps) == 0)
                }
            }
            .navigationTitle(exercise.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        focusedField = nil
                    }
                }
            }
            .onAppear {
                // Pre-fill with previous set's values if available
                if let workout = viewModel.currentWorkout,
                   exerciseIndex < workout.exercises.count {
                    let session = workout.exercises[exerciseIndex]
                    if let lastSet = session.sets.last {
                        reps = "\(lastSet.reps)"
                        if let lastWeight = lastSet.weight {
                            weight = "\(Int(lastWeight))"
                        }
                    }
                }
                
                // Auto-focus reps field
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    focusedField = .reps
                }
            }
        }
    }
    
    // Function to save the set details entered by the user
    private func saveSet() {
        // Ensure the reps input is valid and greater than 0
        guard let repsInt = Int(reps), repsInt > 0 else { return }
        
        // Determine the weight value based on the exercise type
        let weightDouble: Double? = if exercise.equipmentType == .bodyweight {
            nil // No weight for bodyweight exercises
        } else if let w = Double(weight), w > 0 {
            w // Use the entered weight if valid
        } else {
            nil // Default to nil if weight is invalid
        }
        
        // Notify the ViewModel to complete the set with the provided details
        viewModel.completeSet(
            exerciseIndex: exerciseIndex,
            reps: repsInt,
            weight: weightDouble
        )
        
        // Dismiss the view after saving the set
        dismiss()
    }
}

#Preview {
    LogSetView(
        viewModel: WorkoutViewModel(), // Provide a WorkoutViewModel instance for the preview
        exerciseIndex: 0, // Example exercise index
        exercise: Exercise(name: "Bench Press", muscleGroup: .chest, equipmentType: .barbell) // Example exercise
    )
}
