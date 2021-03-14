//
//  MemoryGame.swift
//  Memorize
//
//  Created by David Burghoff on 31.07.20.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    private(set) var score: Int = 0
    private(set) var numberOfMismatchedCards = 0
    private(set) var gameWon: Bool = false

    private var indexOfTheOneAndOnlyFaceUpCard: Int?{
        get {
            cards.indices.filter { cards[$0].isFaceUp}.only
        }
        set{
            for index in cards.indices{
                cards[index].isFaceUp = index == newValue
            }
        }
    }

    mutating func choose(card: Card){
        if let chosenIndex = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched{
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard{
                if cards[chosenIndex].content == cards[potentialMatchIndex].content{
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 10 - numberOfMismatchedCards
                    numberOfMismatchedCards = 0
                }else {
                    numberOfMismatchedCards += 2
                }
                cards[chosenIndex].isFaceUp = true
            }else{
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
        if !cards.map({$0.isMatched}).contains(false){
            gameWon = true
        }
    }

    init(numberOfMemoryPairs: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()

        for pairIndex in 0..<numberOfMemoryPairs {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(id: pairIndex * 2, content: content))
            cards.append(Card(id: pairIndex * 2 + 1, content: content))
        }
        cards.shuffle()
    }

    

    struct Card: Identifiable {
        var id: Int
        var isFaceUp = false {
            didSet{
                if isFaceUp{
                    startUsingBonusTime()
                }else{
                    stopBonusTime()
                }
            }
        }
        var isMatched = false{
            didSet{
                stopBonusTime()
            }
        }
        var content: CardContent


        //MARK: - Bonus Time

        //gives user bonus time, if user matches a card before a certain amount of time passed

        var bonusTimeLimit: TimeInterval = 6

        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            }else{
                return pastFaceUpTime
            }
        }
        var lastFaceUpDate: Date?
        var pastFaceUpTime: TimeInterval = 0
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        var bonusRemaining: Double{
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }

        var hasEarnedBonus: Bool{
            isMatched && bonusTimeRemaining > 0
        }

        var isConsumingBonusTime: Bool{
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        private mutating func stopBonusTime(){
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }

        private mutating func startUsingBonusTime(){
            if isConsumingBonusTime, lastFaceUpDate == nil{
                lastFaceUpDate = Date()
            }
        }

    }




}

