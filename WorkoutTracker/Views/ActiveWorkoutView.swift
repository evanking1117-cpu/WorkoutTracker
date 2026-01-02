//
//  ActiveWorkoutView.swift
//  WorkoutTracker
//
//  Created by Evan King on 2025-12-31.
//

import SwiftUI

struct ActiveWorkoutView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @State private var showingExercisePicker = false
    @State private var selectedExerciseIndex: Int?
    @State private var showingLogSet = false  // ← Added this
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            workoutHeader
            Divider()
            
            if let workout = viewModel.currentWorkout, !workout.exercises.isEmpty {
                exerciseList
            } else {
                emptyState
            }
        }
        .navigationTitle("Active Workout")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("End Workout") {
                    viewModel.endWorkout()
                    dismiss()
                }
                .foregroundColor(.red)
            }
        }
        .sheet(isPresented: $showingExercisePicker) {
            ExercisePickerView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingLogSet) {  // ← Fixed this
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
    
    private var workoutHeader: some View {
        VStack(spacing: 12) {
            if let workout = viewModel.currentWorkout {
                Text(timeString(from: workout.startTime))
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .monospacedDigit()
                
                HStack(spacing: 24) {
                    StatView(value: "\(workout.exercises.count)", label: "Exercises")
                    StatView(value: "\(workout.totalSets)", label: "Sets")
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
    }
    
    private var exerciseList: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(Array(viewModel.currentWorkout!.exercises.enumerated()), id: \.element.id) { index, session in
                    ExerciseSessionCard(
                        session: session,
                        onAddSet: {
                            selectedExerciseIndex = index
                            showingLogSet = true  // ← Added this
                        },
                        onDeleteSet: { setIndex in
                            viewModel.deleteSet(exerciseIndex: index, setIndex: setIndex)
                        }
                    )
                }
                
                addExerciseButton
            }
            .padding()
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 80))
                .foregroundColor(.gray.opacity(0.5))
            Text("No exercises yet")
                .font(.title2)
                .foregroundColor(.secondary)
            Text("Add your first exercise to start tracking")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            addExerciseButton
            Spacer()
        }
        .padding()
    }
    
    private var addExerciseButton: some View {
        Button(action: {
            showingExercisePicker = true
        }) {
            Label("Add Exercise", systemImage: "plus.circle.fill")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
        }
    }
    
    private func timeString(from date: Date) -> String {
        let elapsed = Date().timeIntervalSince(date)
        let minutes = Int(elapsed) / 60
        let seconds = Int(elapsed) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Stat View Component
struct StatView: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .bold()
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Exercise Session Card
struct ExerciseSessionCard: View {
    let session: ExerciseSession
    let onAddSet: () -> Void
    let onDeleteSet: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(session.exercise.name)
                        .font(.headline)
                    Text(session.exercise.muscleGroup.rawValue.capitalized)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text("\(session.sets.count) sets")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if !session.sets.isEmpty {
                ForEach(Array(session.sets.enumerated()), id: \.element.id) { index, set in
                    HStack {
                        Text("Set \(index + 1)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(set.reps) reps")
                            .font(.subheadline)
                        if let weight = set.weight {
                            Text("@ \(Int(weight)) lbs")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Button(action: {
                            onDeleteSet(index)
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red.opacity(0.7))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.vertical, 4)
                }
            }
            
            Button(action: onAddSet) {
                Label("Add Set", systemImage: "plus.circle")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    NavigationView {
        ActiveWorkoutView(viewModel: WorkoutViewModel())
    }
}
