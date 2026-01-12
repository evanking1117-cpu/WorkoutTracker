//
//  CreateExerciseView.swift
//  WorkoutTracker
//
//  Created by Claude on 2026-01-05.
//

import SwiftUI

/// View for creating a custom exercise
/// Allows users to define a new exercise with a name, muscle group, and equipment type
struct CreateExerciseView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @Environment(\.dismiss) private var dismiss

    // State for the exercise name input
    @State private var exerciseName: String = ""
    // State for the selected muscle group
    @State private var selectedMuscleGroup: MuscleGroup = .chest
    // State for the selected equipment type
    @State private var selectedEquipmentType: EquipmentType = .barbell

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Exercise Info")) {
                    TextField("Exercise Name", text: $exerciseName)
                        .autocapitalization(.words)
                }

                Section(header: Text("Muscle Group")) {
                    Picker("Muscle Group", selection: $selectedMuscleGroup) {
                        ForEach(MuscleGroup.allCases, id: \.self) { group in
                            Text(group.rawValue.capitalized).tag(group)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section(header: Text("Equipment Type")) {
                    Picker("Equipment", selection: $selectedEquipmentType) {
                        ForEach(EquipmentType.allCases, id: \.self) { equipment in
                            HStack {
                                Image(systemName: equipment.icon)
                                Text(equipment.rawValue.capitalized)
                            }
                            .tag(equipment)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            .navigationTitle("New Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveExercise()
                    }
                    .disabled(exerciseName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func saveExercise() {
        let exercise = Exercise(
            name: exerciseName.trimmingCharacters(in: .whitespaces),
            muscleGroup: selectedMuscleGroup,
            equipmentType: selectedEquipmentType
        )

        viewModel.saveCustomExercise(exercise)
        dismiss()
    }
}

#Preview {
    CreateExerciseView(viewModel: WorkoutViewModel())
}
