//
//  Sequence+Hashable.swift
//  Memorize
//
//  Created by David Burghoff on 13.03.21.
//

import Foundation
extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
