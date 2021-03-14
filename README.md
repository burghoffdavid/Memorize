# Memory Game 
Small Demo Project, App that lets you play Memory using different (custom) Themes.

Assignments 1, 2, 5,  6 of the [Stanford CS193p iOS development course](https://cs193p.sites.stanford.edu/).

## Features
* Select Theme to play Memory 
* Create new Themes
* Customize Theme
    * Emojis to display on Pairs
    * Color of Cards
    * Number of Pairs to play with
    * Title
* Score Tracking
* Persistent Storage of Themes

## Tasks and Solutions 

### Assignment 1

The goal of this assignment is to recreate the demonstration given in the first two lectures and then make some small enhancements. 

#### Required Tasks

1. [x] Get the Memorize game working as demonstrated in lectures 1 and 2. Type in all the code. Do not copy/paste from anywhere. 

2. [x] Currently the cards appear in a predictable order (the matches are always side-by-side, making the game very easy). Shuffle the cards.

  ```swift
  init(numberOfMemoryPairs: Int, cardContentFactory: (Int) -> CardContent) {
          cards = Array<Card>()
  
          for pairIndex in 0..<numberOfMemoryPairs {
              let content = cardContentFactory(pairIndex)
              cards.append(Card(id: pairIndex * 2, content: content))
              cards.append(Card(id: pairIndex * 2 + 1, content: content))
          }
          cards.shuffle()
      }
  ```

3. [x] Our cards are currently arranged in a single row (we’ll fix that next week). That’s making our cards really tall and skinny (especially in portrait) which doesn’t look very good. Force each card to have a width to height ratio of 2:3 (this will result in empty space above and/or below your cards, which is fine).

  ```swift
  .aspectRatio(2/3, contentMode: .fit)
  ```

4. [x] Have your game start up with a random number of pairs of cards between 2 pairs and 5 pairs. 5. When your game randomly shows 5 pairs, the font we are using for the emoji will be too large (in portrait) and will start to get clipped. Have the font adjust in the 5 pair case (only) to use a smaller font than .largeTitle. Continue to use .largeTitle when there are 4 or fewer pairs in the game. 

  ​	--> additional memory game themes implemented, see assignment 2

5. [x] Your UI should work in portrait or landscape on any iOS device. In landscape your cards will be larger (but still 2:3 aspect ratio). This probably will not require any work on your part (that’s part of the power of SwiftUI), but be sure to experiment with running on different simulators in Xcode to be sure. 

------



### Assignment 2

The goal of this assignment is to continue to recreate the demonstrations given in the next two lectures (first four lectures in total) and then make some bigger enhancements. 

#### Required Tasks

1. [x] Get the Memorize game working as demonstrated in lectures 1 through 4. Type in all the code. Do not copy/paste from anywhere. 

2. [x] Your game should still shuffle the cards. 

3. [x] Architect the concept of a “theme” into your game. A theme consists of a name for the theme, a set of emoji to use, a number of cards to show (which, for at least one, but not all themes, should be random), and an appropriate color to use to draw (e.g. orange would be appropriate for a Halloween theme). 

  ```swift
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
          case lightblue
          case yellow
          case green
          case gray
      }
  }
  ```

  

4. [x] Support at least 6 different themes in your game. 

  --> see above

5. [x] A new theme should be able to be added to your game with a single line of code.

  ```swift
  init() {
          self.theme = MemoryTheme.themes.randomElement()!
          self.model = EmojiMemoryGame.createMemoryGame(with: theme)
      }
  ```

6. [x] Add a “New Game” button to your UI which begins a brand new game. This new game should have a randomly chosen theme. You can put this button anywhere you think looks best in your UI. 

  ```swift
  Button("New Game") {
                      withAnimation(.easeInOut(duration: 0.5)){
                          viewModel.newGame()
                      }
  ```

7. [x] Show the theme’s name somewhere in your UI. 8. Keep score in your game by giving 2 points for every match and penalizing 1 point for every previously seen card that is involved in a mismatch. 

  ```swift
  .navigationBarTitle(viewModel.theme.name, displayMode: .inline)
  ```

  ```swift
  mutating func choose(card: Card){
          if let chosenIndex = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched{
              if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard{
                  if cards[chosenIndex].content == cards[potentialMatchIndex].content{
                      cards[chosenIndex].isMatched = true
                      cards[potentialMatchIndex].isMatched = true
                      score += 2 - numberOfMismatchedCards
                      numberOfMismatchedCards = 0
                  }else {
                      numberOfMismatchedCards += 2
                  }
                  cards[chosenIndex].isFaceUp = true
              }else{
                  indexOfTheOneAndOnlyFaceUpCard = chosenIndex
              }
          }
      }
  ```

8. [x] Display the score in your UI in whatever way you think looks best. 

  ```swift
  .navigationBarItems(trailing: Text("Score: \(viewModel.score)"))
  ```

9. [x] Your UI should work in portrait or landscape on any iOS device. The cards can have any aspect ratio you’d like. This probably will not require any work on your part (that’s part of the power of SwiftUI), but be sure to continue to experiment with running on different simulators in Xcode to be sure.



#### Extra Credit

1. [ ] Support a gradient as the “color” for a theme. Hint: fill() can take a gradient as its argument rather than a color. 
2. [ ] Modify the scoring system to give more points for choosing cards more quickly. For example, maybe you get max(10 - (number of seconds since last card was chosen), 1) x (the number of points you would have otherwise earned or been penalized with). (This is just an example, be creative!). You will definitely want to familiarize yourself with the Date struct.

### Assignment 5

The goal of this assignment is to add some simple, yet important functionality to Memorize that you will need in Assignment 6 while the concept (making a custom struct persistent) is still fresh in your mind from Lecture 7. 

#### Required Tasks
1. [x] Remove the “random number of cards” theme option from your Memorize game.
Each theme will now have its own specific, pre-defined number of cards. In other
words, how many cards are in a game is part of the theme for that game and it can no
longer be “random”. 
    
 * new var in MemoryTheme model to keep track of Number of cards to play with
 
  ```swift
   var numberOfPairsToShow: Int
  ```
  * adjisted init to have an optional numberOfPairsToShow parameter, if nil it will be set to max pairs available
  
  ```swift
   init(name: String, emojis: [String], colorRGB: UIColor.RGB, numberOfPairsToShow : Int? = nil) {
        self.name = name
        self.emojis = emojis
        self.colorRGB = colorRGB
        self.numberOfPairsToShow = numberOfPairsToShow ?? emojis.count
    }
```

2. [x] Every time a new game starts, print a JSON representation of the theme being used
for that game out to the console. All elements of the theme (its name, the emojis to
choose from, how many pairs of cards to show and the color of the theme) must be
included. 
    * added json var to MemoryTheme Model
    ```swift
       var json: Data?{
        return try? JSONEncoder().encode(self)
    }
    ````
    
### Assignment 6

#### Required Tasks

1. [x] Your Memorize application should now show a “theme chooser” UI when it launches. See attached images for examples, but you can be creative with how you show each theme.
2. [x] Use a List to display themes.
2. [x] Each row in the List shows the name of the theme, the color of the theme, how many cards in the theme and some sampling of the emoji in the theme.
2. [x] Touching on a theme in the List navigates (i.e. the List is in a NavigationView) to playing a game with that theme.
2. [x] While playing a game, the name of the theme should be on screen somewhere and you should also continue to support existing functionality like score, new game, etc. (but you may rearrange the UI if you wish).
2. [x] It is okay if going from playing a game back to the chooser and then back to the game in progress restarts the game, though savvy implementations would probably not do that (except when the theme in question is modiﬁed (see below) since that would almost certainly want to restart the game).
2. [x] Provide some UI to add a new theme to the List in your chooser.
2. [x] The chooser must support an Edit Mode where you can delete themes and where you can access some UI (i.e. a button or image in each row) which will bring up a Theme Editor UI for that theme modally (i.e. via sheet or popover).
2. [x] The Theme Editor must use a Form.
2. [x] In the Theme Editor, allow the user to edit the name of the theme, to add emoji to the theme, to remove emoji from the theme and to specify how many cards are in the theme. (It is Extra Credit to be able to edit the color of the theme.)
2. [x] The themes must be persistent (i.e. relaunching your app should not cause all the theme editing you’ve done to be lost).
2. [x] Your UI should work and look nice on both iPhone and iPad.
2. [x] Get your application work on a physical iOS device of your choice.

#### Extra Credit
1. [x] Support choosing a theme's color in the Theme Editor
2. [ ] Keep track of any emoji that a user removes from a theme as a “removed” or “not included” emoji. Then enhance your Theme Editor to allow them to put removed emoji back if they change their mind. Remember these removed emoji forever (i.e. you will have to add state to your theme struct).









