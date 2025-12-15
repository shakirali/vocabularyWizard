//
//  TextToSpeechService.swift
//  Vocabulary
//
//  Simple wrapper around AVSpeechSynthesizer to speak words aloud.
//

import Foundation
import AVFoundation

protocol TextToSpeechService {
    func speak(word: String)
}

final class DefaultTextToSpeechService: NSObject, TextToSpeechService {
    private let synthesizer = AVSpeechSynthesizer()

    func speak(word: String) {
        let utterance = AVSpeechUtterance(string: word)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        synthesizer.speak(utterance)
    }
}


