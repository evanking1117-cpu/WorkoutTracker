//
//  WorkoutListView.swift
//  WorkoutTracker
//
//  Created by Evan King on 2025-12-31.
//

import SwiftUI

/// Main view of the app that displays the list of workout history
/// Provides navigation to start new workouts, use templates, and manage templates
struct WorkoutListView: View {
    // StateObject to create and manage the ViewModel for the entire app
    @StateObject private var viewModel = WorkoutViewModel()
    // State to control the visibility of the template picker sheet
    @State private var showingTemplatePicker = false
    // State to control the visibility of the template manager sheet
    @State private var showingTemplateManager = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Loading workouts...")
                } else {
                    mainContent
                }
            }
            .navigationTitle("Workouts")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingTemplateManager = true
                    }) {
                        Label("Templates", systemImage: "list.bullet.rectangle")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.currentWorkout != nil {
                        NavigationLink(destination: ActiveWorkoutView(viewModel: viewModel)) {
                            Image(systemName: "dumbbell.fill")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingTemplatePicker) {
                TemplatePickerView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingTemplateManager) {
                TemplateManagerView(viewModel: viewModel)
            }
        }
    }
    
    private var mainContent: some View {
        VStack(spacing: 20) {
            // Start Workout Buttons
            if viewModel.currentWorkout == nil {
                VStack(spacing: 12) {
                    // Start Blank Workout
                    Button(action: {
                        viewModel.startWorkout()
                    }) {
                        Label("Start Blank Workout", systemImage: "play.circle.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }

                    // Start from Template
                    Button(action: {
                        showingTemplatePicker = true
                    }) {
                        Label("Start from Template", systemImage: "doc.text.fill")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
            } else {
                // Active workout indicator
                NavigationLink(destination: ActiveWorkoutView(viewModel: viewModel)) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Active Workout")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("\(viewModel.currentWorkout?.exercises.count ?? 0) exercises")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.green)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.top)
            }
            
            // History Section
            if !viewModel.workoutHistory.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("History")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                    
                    List {
                        ForEach(viewModel.workoutHistory) { workout in
                            WorkoutRowView(workout: workout)
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                let workout = viewModel.workoutHistory[index]
                                viewModel.deleteWorkout(workout)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            } else {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "dumbbell")
                        .font(.system(size: 60))
                        .foregroundColor(.gray.opacity(0.5))
                    Text("No workouts yet")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("Start your first workout to begin tracking")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                Spacer()
            }
        }
    }
}

// MARK: - Workout Row Component
struct WorkoutRowView: View {
    let workout: Workout
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(workout.startTime, style: .date)
                    .font(.headline)
                Spacer()
                if let duration = workout.duration {
                    Text(formatDuration(duration))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack(spacing: 16) {
                Label("\(workout.exercises.count)", systemImage: "list.bullet")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Label("\(workout.totalSets)", systemImage: "checkmark.circle")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if !workout.exercises.isEmpty {
                Text(workout.exercises.map { $0.exercise.name }.joined(separator: ", "))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        if minutes < 60 {
            return "\(minutes)m"
        } else {
            let hours = minutes / 60
            let remainingMinutes = minutes % 60
            return "\(hours)h \(remainingMinutes)m"
        }
    }
}

#Preview {
    WorkoutListView()
}
