//
//  BalderdashController.swift
//  Balderdash
//
//  Created by Dirk Smith on 2/20/17.
//  Copyright © 2017 Dirk. All rights reserved.
//

import Foundation

public class BalderdashController: NSObject {
    private var model = [String : Double]()
    private var threshold: Double?
    public var minimumUniqueCharacters: Int?
     let pattern = try? NSRegularExpression(pattern: ".*(.)\\1{2}.*", options: .caseInsensitive)

    public override init() {
        super.init()
    }

    public convenience init(modelName: String, minimumUniqueCharacters: Int) {
        self.init(modelName: modelName)
        self.minimumUniqueCharacters = minimumUniqueCharacters
    }

    public init(modelName: String) {
        super.init()

        if let url = Bundle.main.url(forResource: modelName, withExtension: "json") {
            self.loadFile(url: url)
        }
    }

    public func loadFile(url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            if let object = json as? [String: Any] {
                // json is a dictionary
                self.model = object["probabilities"] as! [String: Double]
                self.threshold = object["threshold"] as? Double
            } else {
                fatalError("File not in correct format")
            }
        } catch {
            fatalError("File not found")
        }
    }

    public func isGiberrish(string: String) -> Bool {
        return !(self.isTransitionallyProbable(string: string) && self.hasMinimumUniqueCharacters(string: string)) || self.hasRepetition(string: string)
    }

    private func isTransitionallyProbable(string: String) -> Bool {
        var logProbability = 0.0
        var transitionCount = 0.0

        for ngram in string.lowercased().ngrams(2) {
            if let probability = self.model[ngram.joined()] {
                logProbability += probability
                transitionCount += 1
            }
        }
        let avgLogProb = logProbability / transitionCount
        return exp(avgLogProb) > self.threshold!
    }

    private func hasMinimumUniqueCharacters(string: String) -> Bool {
        var characterDictionary = [Character: Int]()
        for character in string {
            if let value = characterDictionary[character] {
                characterDictionary.updateValue(value + 1, forKey: character)
            } else {
                characterDictionary[character] = 1
            }
        }

        if let minimumCharacterCount = self.minimumUniqueCharacters {
            if characterDictionary.count >= minimumCharacterCount {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }

    func hasRepetition(string: String) -> Bool {
        let results = pattern?.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
        return results!.count > 0
    }
}
