//
//  CreateTemplateView.swift
//  WorkoutTracker
//
//  Created by Claude on 2026-01-04.
//

import SwiftUI

struct CreateTemplateView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var templateName: String = ""
    @State private var selectedExercises: [TemplateExerciseBuilder] = []
    @State private var showingExercisePicker = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Template Info")) {
                    TextField("Template Name", text: $templateName)
                        .autocapitalization(.words)
                }

                Section(header: Text("Exercises")) {
                    if selectedExercises.isEmpty {
                        Text("No exercises added")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    } else {
                        ForEach(selectedExercises.indices, id: \.self) { index in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(selectedExercises[index].exercise.name)
                                        .font(.headline)
                                    Text(selectedExercises[index].exercise.muscleGroup.rawValue.capitalized)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()

                                Stepper("\(selectedExercises[index].targetSets) sets",
                                       value: $selectedExercises[index].targetSets,
                                       in: 1...10)
                                    .labelsHidden()

                                Text("\(selectedExercises[index].targetSets)")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                    .frame(width: 60)
                            }
                        }
                        .onDelete { indexSet in
                            selectedExercises.remove(atOffsets: indexSet)
                        }
                    }

                    Button(action: {
                        showingExercisePicker = true
                    }) {
                        Label("Add Exercise", systemImage: "plus.circle.fill")
                    }
                }
            }
            .navigationTitle("New Template")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTemplate()
                    }
                    .disabled(templateName.isEmpty || selectedExercises.isEmpty)
                }
            }
            .sheet(isPresented: $showingExercisePicker) {
                TemplateExercisePickerView(
                    viewModel: viewModel,
                    selectedExercises: $selectedExercises
                )
            }
        }
    }

    private func saveTemplate() {
        let templateExercises = selectedExercises.map { builder in
            TemplateExercise(
                exercise: builder.exercise,
                targetSets: builder.targetSets
            )
        }

        let template = WorkoutTemplate(
            name: templateName,
            exercises: templateExercises
        )

        viewModel.saveTemplate(template)
        dismiss()
    }
}

// MARK: - Template Exercise Builder
struct TemplateExerciseBuilder: Identifiable {
    let id = UUID()
    let exercise: Exercise
    var targetSets: Int = 3
}

#Preview {
    CreateTemplateView(viewModel: WorkoutViewModel())
}
