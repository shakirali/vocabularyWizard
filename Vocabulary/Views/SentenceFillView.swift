//
//  SentenceFillView.swift
//  Vocabulary
//
//  Sentence fill-in-the-blank quiz view.
//

import SwiftUI

struct SentenceFillView: View {
    @StateObject private var viewModel: SentenceFillViewModel
    @State private var feedback: String?
    @State private var isProcessingAnswer = false

    init(
        year: YearGroup,
        repository: VocabularyRepository
    ) {
        _viewModel = StateObject(
            wrappedValue: SentenceFillViewModel(
                year: year,
                repository: repository
            )
        )
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar with simple title + progress
                VStack(spacing: 8) {
                    HStack {
                        Text("Sentence Quiz")
                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                            .foregroundColor(Color(.label))
                        Spacer()
                    }

                    if !viewModel.questions.isEmpty {
                        Text("Question \(viewModel.currentIndex + 1) of \(viewModel.questions.count)")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)

                if viewModel.questions.isEmpty {
                    Spacer()
                    Text("Sentence practice will appear once content is available.")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Spacer()
                } else if viewModel.isFinished {
                    Spacer()
                    VStack(spacing: 8) {
                        Text("Great work!")
                            .font(.system(size: 24, weight: .bold))
                        Text("Score: \(viewModel.correctCount)/\(viewModel.questions.count)")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(red: 0.17, green: 0.68, blue: 0.93))
                        Text("You've completed all sentences.")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                } else if let question = viewModel.currentQuestion {
                    ScrollView {
                        VStack(spacing: 24) {
                            // Question card similar to fill-in-the-blanks_quiz_screen
                            VStack(alignment: .center, spacing: 16) {
                                Text(question.displaySentence)
                                    .font(.system(size: 22, weight: .bold))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(.label))
                                    .padding(.horizontal)
                            }
                            .padding(.vertical, 24)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 6)
                            )
                            .padding(.horizontal)

                            // Options grid (2 columns)
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                                ForEach(question.options.indices, id: \.self) { index in
                                    Button {
                                        handleSelection(index: index, question: question)
                                    } label: {
                                        VStack(spacing: 10) {
                                            Text(question.options[index])
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(Color(.label))
                                                .multilineTextAlignment(.center)
                                                .frame(maxWidth: .infinity)
                                        }
                                        .padding()
                                        .frame(height: 100)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                .fill(Color(.systemBackground))
                                                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 4)
                                        )
                                    }
                                    .buttonStyle(.plain)
                                    .disabled(isProcessingAnswer)
                                }
                            }
                            .padding(.horizontal)

                            if let feedback = feedback {
                                Text(feedback)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.vertical, 16)
                    }
                }
            }
        }
        .task {
            await viewModel.load()
        }
    }

    private func handleSelection(index: Int, question: SentenceQuestion) {
        let selected = question.options[index]
        if selected == question.correctWord {
            feedback = "Nice! \"\(selected)\" fits perfectly."
            viewModel.answer(isCorrect: true)
            isProcessingAnswer = true
            Task {
                try? await Task.sleep(for: .milliseconds(800))
                feedback = nil
                isProcessingAnswer = false
                viewModel.advance()
            }
        } else {
            feedback = "Try again. Think about what word best completes the sentence."
            viewModel.answer(isCorrect: false)
        }
    }
}


