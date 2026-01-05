//
//  TemplatePickerView.swift
//  WorkoutTracker
//
//  Created by Claude on 2026-01-04.
//

import SwiftUI

struct TemplatePickerView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingCreateTemplate = false

    var body: some View {
        NavigationView {
            Group {
                if viewModel.workoutTemplates.isEmpty {
                    emptyState
                } else {
                    templateList
                }
            }
            .navigationTitle("Start from Template")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingCreateTemplate = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingCreateTemplate) {
                CreateTemplateView(viewModel: viewModel)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "doc.text")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            Text("No Templates Yet")
                .font(.title2)
                .foregroundColor(.secondary)
            Text("Create a template to get started")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button(action: {
                showingCreateTemplate = true
            }) {
                Label("Create Template", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            Spacer()
        }
        .padding()
    }

    private var templateList: some View {
        List(viewModel.workoutTemplates) { template in
            Button(action: {
                viewModel.startWorkout(from: template)
                dismiss()
            }) {
                TemplateRowView(template: template)
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Template Row Component
struct TemplateRowView: View {
    let template: WorkoutTemplate

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(template.name)
                .font(.headline)

            HStack(spacing: 16) {
                Label("\(template.exercises.count)", systemImage: "list.bullet")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Label("\(template.totalSets)", systemImage: "checkmark.circle")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            if !template.exercises.isEmpty {
                Text(template.exercises.map { $0.exercise.name }.joined(separator: ", "))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    TemplatePickerView(viewModel: WorkoutViewModel())
}
