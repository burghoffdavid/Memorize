//
//  MemoryTheme.swift
//  Memorize
//
//  Created by David Burghoff on 13.08.20.
//

import Foundation

struct MemoryTheme {
    var name: String
    var color: ThemeColor
    var emojis: [String]

    static let halloween  = MemoryTheme(name: "Halloween", color: .orange, emojis: ["👻", "🎃", "🕷", "🧙", "💀"].shuffled())
    static let christmas = MemoryTheme(name: "Christmas", color: .red, emojis: ["🎄", "🤶", "🎅", "🎁"].shuffled())
    static let winter = MemoryTheme(name: "Winter", color: .lightblue, emojis: ["🥶", "❄️", "☃️", "🧦", "🌨", "⛸", "🏂"].shuffled())
    static let beach = MemoryTheme(name: "Beach", color: .yellow, emojis:  ["👙", "🏝", "⛱", "🩳", "🩱", "🗿"].shuffled())
    static let anmimals = MemoryTheme(name: "Animals", color: .green, emojis: ["🐶", "🐱", "🐷", "🐵", "🐔", "🦇", "🐍", ""].shuffled())
    static let alcohol = MemoryTheme(name: "Alcohol!", color: .gray, emojis:  ["🥃", "🥂", "🍷", "🍺", "🍶", "🍸", "🍹", "🍾"].shuffled())

    static let themes = [halloween, christmas, winter, beach, anmimals, alcohol]

    enum ThemeColor {
        case orange
        case red
        case required
        case lightblue
        case yellow
        case green
        case gray
    }


}
