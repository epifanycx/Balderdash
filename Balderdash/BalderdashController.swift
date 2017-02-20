//
//  BalderdashController.swift
//  Balderdash
//
//  Created by Dirk Smith on 2/20/17.
//  Copyright © 2017 Dirk. All rights reserved.
//

import Foundation

public class BalderdashController: NSObject {
    var model = [[Double]]()
    var threshold: Double?

    public override init() {
        super.init()
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
                self.model = object["mat"] as! [[Double]]
                self.threshold = object["thresh"] as? Double
            } else {
                fatalError("File not in correct format")
            }
        } catch {
            fatalError("File not found")
        }
    }

    public func isGiberrish(string: String) -> Bool {
        var logProbability = 0.0
        var transitionCount = 0.0
        let acceptedChars = "abcdefghijklmnopqrstuvwxyz ".characters.map{String($0)}

        for ngram in string.lowercased().ngrams(2) {
            //skip ngrams that don't contain our accepted characters
            if let firstIndex = acceptedChars.index(of: ngram[0]), let secondIndex = acceptedChars.index(of: ngram[1]) {
                let firstArray = model[firstIndex]
                let prob = firstArray[secondIndex]
                logProbability += prob
                transitionCount += 1
            } else {
                //ngram contains an unusual character, so we skip it.
            }
        }

        let avgLogProb = logProbability / transitionCount
        return exp(avgLogProb) > self.threshold!
    }

}
