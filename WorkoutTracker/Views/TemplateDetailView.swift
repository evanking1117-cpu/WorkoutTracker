//
//  TemplateDetailView.swift
//  WorkoutTracker
//
//  Created by Claude on 2026-01-04.
//

import SwiftUI

/// View for displaying details of a specific workout template
/// Shows template information and provides the option to start a workout from the template
struct TemplateDetailView: View {
    // The template to display
    let template: WorkoutTemplate
    @ObservedObject var viewModel: WorkoutViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            Section(header: Text("Template Info")) {
                HStack {
                    Text("Name")
                    Spacer()
                    Text(template.name)
                        .foregroundColor(.secondary)
                }

                HStack {
                    Text("Total Exercises")
                    Spacer()
                    Text("\(template.exercises.count)")
                        .foregroundColor(.secondary)
                }

                HStack {
                    Text("Total Sets")
                    Spacer()
                    Text("\(template.totalSets)")
                        .foregroundColor(.secondary)
                }
            }

            Section(header: Text("Exercises")) {
                ForEach(template.exercises) { templateExercise in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(templateExercise.exercise.name)
                                    .font(.headline)
                                Text(templateExercise.exercise.muscleGroup.rawValue.capitalized)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text("\(templateExercise.targetSets) sets")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }

            Section {
                Button(action: {
                    viewModel.startWorkout(from: template)
                    dismiss()
                }) {
                    Label("Start Workout from Template", systemImage: "play.circle.fill")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.blue)
                }
            }
        }
        .navigationTitle(template.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        TemplateDetailView(
            template: WorkoutTemplate(
                name: "Push Day",
                exercises: [
                    TemplateExercise(
                        exercise: Exercise(name: "Bench Press", muscleGroup: .chest, equipmentType: .barbell),
                        targetSets: 3
                    )
                ]
            ),
            viewModel: WorkoutViewModel()
        )
    }
}
