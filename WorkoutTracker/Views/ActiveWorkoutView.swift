//
//  ActiveWorkoutView.swift
//  WorkoutTracker
//
//  Created by Evan King on 2025-12-31.
//

import SwiftUI
import Combine

struct ActiveWorkoutView: View {
    // ViewModel to manage the workout state and interactions
    @ObservedObject var viewModel: WorkoutViewModel
    // State to control the visibility of the exercise picker sheet
    @State private var showingExercisePicker = false
    // Environment variable to dismiss the current view
    @Environment(\.dismiss) private var dismiss
    // Timer to force view updates for real-time clock
    @State private var currentTime = Date()
    @State private var timerCancellable: AnyCancellable?

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
        .onAppear {
            // Start the timer when view appears
            timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .sink { _ in
                    currentTime = Date()
                }
        }
        .onDisappear {
            // Cancel the timer when view disappears
            timerCancellable?.cancel()
            timerCancellable = nil
        }
    }

    // Header section for the workout view
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
                        onSaveSet: { reps, weight in
                            viewModel.completeSet(
                                exerciseIndex: index,
                                reps: reps,
                                weight: weight
                            )
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
        let elapsed = currentTime.timeIntervalSince(date)
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
    let onSaveSet: (Int, Double?) -> Void
    let onDeleteSet: (Int) -> Void

    @State private var showingAddSet = false
    @State private var reps: String = ""
    @State private var weight: String = ""
    @FocusState private var focusedField: Field?

    enum Field {
        case reps, weight
    }

    var shouldShowForm: Bool {
        if let target = session.targetSets {
            return session.sets.count < target
        }
        return showingAddSet
    }

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
                if let target = session.targetSets {
                    Text("\(session.sets.count) of \(target) sets")
                        .font(.subheadline)
                        .foregroundColor(session.sets.count >= target ? .green : .secondary)
                } else {
                    Text("\(session.sets.count) sets")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
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

            // Inline form for adding set
            if shouldShowForm {
                VStack(spacing: 8) {
                    // Set header if from template
                    if let target = session.targetSets {
                        HStack {
                            Text("Set \(session.sets.count + 1) of \(target)")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                            Spacer()
                        }
                    }

                    HStack {
                        Text("Reps")
                            .frame(width: 60, alignment: .leading)
                        TextField("0", text: $reps)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .reps)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.trailing)
                    }

                    if session.exercise.equipmentType != .bodyweight {
                        HStack {
                            Text("Weight")
                                .frame(width: 60, alignment: .leading)
                            TextField("0", text: $weight)
                                .keyboardType(.decimalPad)
                                .focused($focusedField, equals: .weight)
                                .textFieldStyle(.roundedBorder)
                                .multilineTextAlignment(.trailing)
                            Text("lbs")
                                .foregroundColor(.secondary)
                        }
                    }

                    HStack(spacing: 8) {
                        Button("Cancel") {
                            showingAddSet = false
                            reps = ""
                            weight = ""
                            focusedField = nil
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.primary)
                        .cornerRadius(8)

                        Button("Save") {
                            saveSet()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(reps.isEmpty || Int(reps) == nil || Int(reps) == 0 ? Color.gray.opacity(0.2) : Color.blue)
                        .foregroundColor(reps.isEmpty || Int(reps) == nil || Int(reps) == 0 ? .secondary : .white)
                        .cornerRadius(8)
                        .disabled(reps.isEmpty || Int(reps) == nil || Int(reps) == 0)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .onAppear {
                    // Pre-fill with previous set's values
                    if let lastSet = session.sets.last {
                        reps = "\(lastSet.reps)"
                        if let lastWeight = lastSet.weight {
                            weight = "\(Int(lastWeight))"
                        }
                    }
                    // Auto-focus reps field when from template
                    if session.targetSets != nil {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            focusedField = .reps
                        }
                    }
                }
            } else if session.targetSets == nil {
                // Only show "Add Set" button if not from template
                Button(action: {
                    showingAddSet = true
                    // Pre-fill with previous set's values
                    if let lastSet = session.sets.last {
                        reps = "\(lastSet.reps)"
                        if let lastWeight = lastSet.weight {
                            weight = "\(Int(lastWeight))"
                        }
                    }
                    // Auto-focus reps field
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        focusedField = .reps
                    }
                }) {
                    Label("Add Set", systemImage: "plus.circle")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }

    private func saveSet() {
        guard let repsInt = Int(reps), repsInt > 0 else { return }

        let weightDouble: Double? = if session.exercise.equipmentType == .bodyweight {
            nil
        } else if let w = Double(weight), w > 0 {
            w
        } else {
            nil
        }

        onSaveSet(repsInt, weightDouble)

        // Reset form
        showingAddSet = false
        reps = ""
        weight = ""
        focusedField = nil

        // If from template and more sets to complete, refocus for next set
        if let target = session.targetSets, session.sets.count + 1 < target {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                focusedField = .reps
            }
        }
    }
}

#Preview {
    NavigationView {
        ActiveWorkoutView(viewModel: WorkoutViewModel())
    }
}
