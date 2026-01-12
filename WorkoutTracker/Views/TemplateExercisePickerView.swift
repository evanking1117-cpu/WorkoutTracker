//
//  TemplateExercisePickerView.swift
//  WorkoutTracker
//
//  Created by Claude on 2026-01-04.
//

import SwiftUI

/// View for selecting exercises when creating a workout template
/// Similar to ExercisePickerView but specifically for template creation
struct TemplateExercisePickerView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    // Binding to the list of exercises being added to the template
    @Binding var selectedExercises: [TemplateExerciseBuilder]
    @Environment(\.dismiss) private var dismiss

    // State for search text input
    @State private var searchText = ""
    // State for the currently selected muscle group filter
    @State private var selectedMuscleGroup: MuscleGroup? = nil
    // State to control the visibility of the create exercise sheet
    @State private var showingCreateExercise = false

    // Built-in exercises available by default
    private let builtInExercises = [
        Exercise(name: "Bench Press", muscleGroup: .chest, equipmentType: .barbell),
        Exercise(name: "Squat", muscleGroup: .legs, equipmentType: .barbell),
        Exercise(name: "Deadlift", muscleGroup: .back, equipmentType: .barbell),
        Exercise(name: "Overhead Press", muscleGroup: .shoulders, equipmentType: .barbell),
        Exercise(name: "Barbell Row", muscleGroup: .back, equipmentType: .barbell),
        Exercise(name: "Pull-ups", muscleGroup: .back, equipmentType: .bodyweight),
        Exercise(name: "Push-ups", muscleGroup: .chest, equipmentType: .bodyweight),
        Exercise(name: "Dumbbell Curl", muscleGroup: .arms, equipmentType: .dumbbell),
        Exercise(name: "Tricep Dips", muscleGroup: .arms, equipmentType: .bodyweight),
        Exercise(name: "Plank", muscleGroup: .core, equipmentType: .bodyweight)
    ]

    /// Combines built-in exercises with user-created custom exercises
    var allExercises: [Exercise] {
        builtInExercises + viewModel.customExercises
    }

    var filteredExercises: [Exercise] {
        allExercises.filter { exercise in
            let matchesSearch = searchText.isEmpty || exercise.name.localizedCaseInsensitiveContains(searchText)
            let matchesMuscleGroup = selectedMuscleGroup == nil || exercise.muscleGroup == selectedMuscleGroup
            return matchesSearch && matchesMuscleGroup
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Muscle Group Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        Button(action: { selectedMuscleGroup = nil }) {
                            Text("All")
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedMuscleGroup == nil ? Color.blue : Color.gray.opacity(0.2))
                                .foregroundColor(selectedMuscleGroup == nil ? .white : .primary)
                                .cornerRadius(20)
                        }

                        ForEach(MuscleGroup.allCases, id: \.self) { group in
                            Button(action: { selectedMuscleGroup = group }) {
                                Text(group.rawValue.capitalized)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(selectedMuscleGroup == group ? Color.blue : Color.gray.opacity(0.2))
                                    .foregroundColor(selectedMuscleGroup == group ? .white : .primary)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding()
                }

                // Exercise List
                List(filteredExercises) { exercise in
                    Button(action: {
                        addExercise(exercise)
                    }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(exercise.name)
                                    .font(.headline)
                                Text(exercise.muscleGroup.rawValue.capitalized)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: exercise.equipmentType.icon)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search exercises")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingCreateExercise = true
                    }) {
                        Image(systemName: "plus")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingCreateExercise) {
                CreateExerciseView(viewModel: viewModel)
            }
        }
    }

    private func addExercise(_ exercise: Exercise) {
        // Check if exercise is already added
        if !selectedExercises.contains(where: { $0.exercise.id == exercise.id }) {
            selectedExercises.append(TemplateExerciseBuilder(exercise: exercise))
        }
        dismiss()
    }
}

#Preview {
    TemplateExercisePickerView(
        viewModel: WorkoutViewModel(),
        selectedExercises: .constant([])
    )
}
