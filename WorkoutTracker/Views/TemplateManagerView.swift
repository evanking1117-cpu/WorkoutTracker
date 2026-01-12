//
//  TemplateManagerView.swift
//  WorkoutTracker
//
//  Created by Claude on 2026-01-04.
//

import SwiftUI

/// View for managing workout templates
/// Displays all saved templates and allows users to create, view, and delete them
struct TemplateManagerView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @Environment(\.dismiss) private var dismiss
    // State to control the visibility of the create template sheet
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
            .navigationTitle("Templates")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
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
            Image(systemName: "doc.text")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            Text("No Templates Yet")
                .font(.title2)
                .foregroundColor(.secondary)
            Text("Tap + to create your first template")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    private var templateList: some View {
        List {
            ForEach(viewModel.workoutTemplates) { template in
                NavigationLink(destination: TemplateDetailView(template: template, viewModel: viewModel)) {
                    TemplateRowView(template: template)
                }
            }
            .onDelete { indexSet in
                indexSet.forEach { index in
                    let template = viewModel.workoutTemplates[index]
                    viewModel.deleteTemplate(template)
                }
            }
        }
    }
}

#Preview {
    TemplateManagerView(viewModel: WorkoutViewModel())
}
