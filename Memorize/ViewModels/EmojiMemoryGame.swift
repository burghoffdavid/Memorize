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

    init(theme: MemoryTheme) {
 
        self.theme = theme
        self.model = EmojiMemoryGame.createMemoryGame(with: theme)
    }

    // static: ability call a function form the TYPE, not an Instance!
    private static func createMemoryGame (with theme: MemoryTheme) -> MemoryGame<String>{
        let emojis = theme.emojis.shuffled()
        return MemoryGame<String>(numberOfMemoryPairs: theme.numberOfPairsToShow){pairIndex in
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
    var gameWon: Bool{
        model.gameWon
    }
  

    //MARK: - Intents
    func chooseCard(card: MemoryGame<String>.Card){
        model.choose(card: card)
    }

    func newGame(){
        model = Self.createMemoryGame(with: theme)
    }

}
