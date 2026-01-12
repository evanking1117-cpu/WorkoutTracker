//
//  ExercisePickerView.swift
//  WorkoutTracker
//
//  Created by Evan King on 2025-12-31.
//

import SwiftUI

/// View for selecting exercises to add to the current workout
/// Provides search, filtering by muscle group, and the ability to create custom exercises
struct ExercisePickerView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @Environment(\.dismiss) private var dismiss

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
        Exercise(name: "Plank", muscleGroup: .core, equipmentType: .bodyweight),
    ]

    // State for search text input
    @State private var searchText = ""
    // State for the currently selected muscle group filter
    @State private var selectedMuscleGroup: MuscleGroup?
    // State to control the visibility of the create exercise sheet
    @State private var showingCreateExercise = false

    /// Combines built-in exercises with user-created custom exercises
    var allExercises: [Exercise] {
        builtInExercises + viewModel.customExercises
    }

    /// Filters exercises based on search text and selected muscle group
    var filteredExercises: [Exercise] {
        allExercises.filter { exercise in
            let matchesSearch = searchText.isEmpty ||
                exercise.name.localizedCaseInsensitiveContains(searchText)
            let matchesMuscleGroup = selectedMuscleGroup == nil ||
                exercise.muscleGroup == selectedMuscleGroup
            return matchesSearch && matchesMuscleGroup
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Muscle group filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        FilterChip(
                            title: "All",
                            isSelected: selectedMuscleGroup == nil,
                            action: { selectedMuscleGroup = nil }
                        )
                        
                        ForEach(MuscleGroup.allCases, id: \.self) { group in
                            FilterChip(
                                title: group.rawValue.capitalized,
                                isSelected: selectedMuscleGroup == group,
                                action: { selectedMuscleGroup = group }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                
                // Exercise list
                List(filteredExercises) { exercise in
                    Button(action: {
                        viewModel.addExercise(exercise)
                        dismiss()
                    }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(exercise.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text(exercise.muscleGroup.rawValue.capitalized)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: exercise.equipmentType.icon)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingCreateExercise = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search exercises")
            .sheet(isPresented: $showingCreateExercise) {
                CreateExerciseView(viewModel: viewModel)
            }
        }
    }
}

// MARK: - Filter Chip Component
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

// MARK: - Equipment Type Extension
// Extension to provide additional functionality for the EquipmentType enum
extension EquipmentType {
    // Returns an icon name (SF Symbol) representing the equipment type
    var icon: String {
        switch self {
        case .bodyweight: return "figure.walk" // Icon for bodyweight exercises
        case .barbell: return "arrow.left.and.right" // Icon for barbell exercises
        case .dumbbell: return "dumbbell" // Icon for dumbbell exercises
        case .machine: return "gearshape" // Icon for machine-based exercises
        case .cable: return "cable.connector" // Icon for cable-based exercises
        }
    }
}

// Preview provider for SwiftUI previews
#Preview {
    ExercisePickerView(viewModel: WorkoutViewModel()) // Preview the ExercisePickerView
}
