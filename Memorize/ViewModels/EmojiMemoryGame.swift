//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by David Burghoff on 31.07.20.
//

import Foundation

final class EmojiMemoryGame: ObservableObject{

    @Published private(set) var model: MemoryGame<String>
    var theme : MemoryTheme

    init() {
        self.theme = MemoryTheme.themes.randomElement()!
        if theme.json != nil, let themeDecoded = try? JSONDecoder().decode(MemoryTheme.self, from: theme.json!){
            print(themeDecoded)
            print("JSON PRINTOUT: \(String(data: theme.json!, encoding: .utf8)!)")
        }
        self.model = EmojiMemoryGame.createMemoryGame(with: theme)
    }

    // static: ability call a function form the TYPE, not an Instance!
    private static func createMemoryGame (with theme: MemoryTheme) -> MemoryGame<String>{
        let emojis = theme.emojis.shuffled()
        
        return MemoryGame<String>(numberOfMemoryPairs: emojis.count){pairIndex in
            return emojis[pairIndex]
        }
    }


    //MARK: - Access to the Model
    var cards: Array<MemoryGame<String>.Card>{
        model.cards
    }
    var score: Int {
        model.score
    }

    //MARK: - Intents

    func chooseCard(card: MemoryGame<String>.Card){
        model.choose(card: card)
    }

    func newGame(){
        let oldTheme = theme
        var newTheme = MemoryTheme.themes.randomElement()!
        while oldTheme.name == newTheme.name {
            newTheme = MemoryTheme.themes.randomElement()!
        }
        theme = newTheme
        print("JSON PRINTOUT: \(String(data: theme.json!, encoding: .utf8)!)")
        model = Self.createMemoryGame(with: theme)
    }

}
