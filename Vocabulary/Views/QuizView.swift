//
//  QuizView.swift
//  Vocabulary
//
//  Multiple-choice quiz view using mastered words.
//

import SwiftUI

struct QuizView: View {
    @StateObject private var viewModel: QuizViewModel

    init(
        year: YearGroup,
        repository: VocabularyRepository,
        progressStore: ProgressStore
    ) {
        _viewModel = StateObject(
            wrappedValue: QuizViewModel(
                year: year,
                repository: repository,
                progressStore: progressStore
            )
        )
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header & simple progress bar (inspired by flashcard_quiz_screen)
                VStack(spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Flashcard Quiz")
                                .font(.system(size: 20, weight: .heavy, design: .rounded))
                                .foregroundColor(Color(.label))
                            if !viewModel.questions.isEmpty {
                                Text("Question \(viewModel.currentIndex + 1) of \(viewModel.questions.count)")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                        }
                        Spacer()
                    }

                    if !viewModel.questions.isEmpty {
                        GeometryReader { proxy in
                            let progress = CGFloat(viewModel.currentIndex + 1) / CGFloat(max(viewModel.questions.count, 1))
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.secondary.opacity(0.2))
                                    .frame(height: 8)
                                Capsule()
                                    .fill(Color(red: 0.17, green: 0.68, blue: 0.93))
                                    .frame(width: proxy.size.width * progress, height: 8)
                            }
                        }
                        .frame(height: 8)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)

                Spacer(minLength: 8)

                if viewModel.questions.isEmpty {
                    Text("You need to memorize some words first in flashcards.")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                } else if let question = viewModel.currentQuestion {
                    VStack(spacing: 20) {
                        Text("What does this word mean?")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)

                        VStack(spacing: 12) {
                            Text(question.prompt)
                                .font(.system(size: 32, weight: .heavy, design: .rounded))
                                .foregroundColor(Color(.label))
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 6)
                        )
                        .padding(.horizontal)

                        VStack(spacing: 12) {
                            ForEach(question.options.indices, id: \.self) { index in
                                Button {
                                    viewModel.answer(optionIndex: index)
                                } label: {
                                    HStack {
                                        Text(question.options[index])
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(Color(.label))
                                        Spacer()
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .fill(Color(.systemBackground))
                                            .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 16)
                }

                if viewModel.isFinished {
                    VStack(spacing: 8) {
                        Text("Great job!")
                            .font(.system(size: 20, weight: .bold))
                        Text("Score: \(viewModel.correctCount)/\(viewModel.questions.count)")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(Color(red: 0.17, green: 0.68, blue: 0.93))
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 16)
                }

                Spacer()
            }
        }
        .task {
            await viewModel.load()
        }
    }
}
