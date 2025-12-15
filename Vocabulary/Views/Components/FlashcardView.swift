//
//  FlashcardView.swift
//  Vocabulary
//
//  Flashcard with front (word + speaker) and back (meaning + antonyms).
//

import SwiftUI

struct FlashcardView: View {
    let item: VocabularyItem
    let tts: TextToSpeechService
    var onMemorized: (() -> Void)?

    @State private var isFlipped: Bool = false

    var body: some View {
        ZStack {
            // Front side
            cardFront
                .opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))

            // Back side (pre-rotated so it appears correct when card is flipped)
            cardBack
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
        }
        .frame(maxWidth: 420, maxHeight: 360)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("flashcard-\(item.id)")
        .animation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.2), value: isFlipped)
        .onTapGesture {
            isFlipped.toggle()
        }
    }

    // MARK: - Front Side

    private var cardFront: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.15), radius: 16, x: 0, y: 10)

            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(Color.secondary.opacity(0.15), lineWidth: 1)

            VStack(spacing: 20) {
                VStack(spacing: 16) {
                    Text(item.word)
                        .font(.system(size: 34, weight: .heavy, design: .rounded))
                        .foregroundColor(Color(.label))
                        .multilineTextAlignment(.center)
                        .accessibilityIdentifier("flashcard-word")

                    Button {
                        tts.speak(word: item.word)
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Hear the word")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundColor(Color(red: 0.17, green: 0.68, blue: 0.93))
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(Color(red: 0.17, green: 0.68, blue: 0.93).opacity(0.12))
                        )
                    }
                }

                Text("Tap card to flip")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
            }
            .padding(24)
        }
    }

    // MARK: - Back Side

    private var cardBack: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(red: 0.17, green: 0.68, blue: 0.93))
                .shadow(color: Color.black.opacity(0.15), radius: 16, x: 0, y: 10)

            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(Color.white.opacity(0.6), lineWidth: 1)

            VStack(spacing: 20) {
                VStack(spacing: 10) {
                    Text(item.word)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .accessibilityIdentifier("flashcard-word-back")

                    Capsule()
                        .fill(Color.white.opacity(0.35))
                        .frame(width: 80, height: 3)

                    Text(item.meaning)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.white.opacity(0.95))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 12)
                }

                if let first = item.antonyms.first,
                   let second = item.antonyms.dropFirst().first {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.left.and.right")
                                .font(.system(size: 13, weight: .bold))
                            Text("Antonyms")
                                .font(.system(size: 13, weight: .bold))
                        }
                        .foregroundColor(.white.opacity(0.9))

                        HStack(spacing: 10) {
                            Text(first)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(Color(red: 0.17, green: 0.68, blue: 0.93))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(Color.white)
                                )

                            Text(second)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(Color(red: 0.17, green: 0.68, blue: 0.93))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(Color.white)
                                )
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                }

                Button {
                    onMemorized?()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Mark as memorized")
                            .font(.system(size: 15, weight: .bold))
                    }
                    .foregroundColor(Color(red: 0.17, green: 0.68, blue: 0.93))
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(Color.white)
                    )
                }
                .padding(.top, 4)
            }
            .padding(24)
        }
    }
}

#Preview {
    let item = VocabularyItem(
        year: .year3,
        word: "Bright",
        meaning: "Giving out or reflecting much light; shining.",
        antonyms: ["Dark", "Dull"],
        exampleSentences: ["The bright sun lit up the sky."]
    )
    FlashcardView(item: item, tts: DefaultTextToSpeechService())
}

