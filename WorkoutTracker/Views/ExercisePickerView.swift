//
//  ExercisePickerView.swift
//  WorkoutTracker
//
//  Created by Evan King on 2025-12-31.
//

import SwiftUI

struct ExercisePickerView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @Environment(\.dismiss) private var dismiss
    
    // Sample exercises (V0.1 - hardcoded, V0.2 - load from database)
    private let exercises = [
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
    
    @State private var searchText = ""
    @State private var selectedMuscleGroup: MuscleGroup?
    
    var filteredExercises: [Exercise] {
        exercises.filter { exercise in
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
            }
            .searchable(text: $searchText, prompt: "Search exercises")
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
extension EquipmentType {
    var icon: String {
        switch self {
        case .bodyweight: return "figure.walk"
        case .barbell: return "arrow.left.and.right"
        case .dumbbell: return "dumbbell"
        case .machine: return "gearshape"
        case .cable: return "cable.connector"
        }
    }
}

#Preview {
    ExercisePickerView(viewModel: WorkoutViewModel())
}
