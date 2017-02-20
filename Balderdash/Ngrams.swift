//
//  Ngrams.swift
//  Balderdash
//
//  Created by Dirk Smith on 2/20/17.
//  Copyright © 2017 Dirk. All rights reserved.
//

import Foundation

public extension String {

    public func ngrams(_ n: Int) -> Array<Array<String>> {
        let items: [String] = characters.map{String($0)}
        var ngrams: [[String]] = []

        for (index, _) in items.enumerated() {
            if index > items.count - n {
                continue
            } else {
                let ngram = Array(items[index...(index + n - 1)])
                ngrams.append(ngram)
            }
        }
        return ngrams

    }

}
