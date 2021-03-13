//
//  ContentView.swift
//  Memorize
//
//  Created by David Burghoff on 31.07.20.
//

import SwiftUI

struct EmojiMemoryGameView: View {

    @ObservedObject var viewModel: EmojiMemoryGame
//    var themeColor: Color{
//        Color(UIColor.RGB(red: CGFloat(viewModel.theme.colorRGB.red),
//                          green: CGFloat(viewModel.theme.colorRGB.green),
//                          blue: CGFloat(viewModel.theme.colorRGB.blue),
//                          alpha: CGFloat(viewModel.theme.colorRGB.alpha)))
//    }

    var body: some View {
        NavigationView{
            VStack{
                Grid(viewModel.cards){ card in
                    CardView(card: card)
                            .onTapGesture {
                                withAnimation(.linear(duration: 0.5)){
                                    viewModel.chooseCard(card: card)
                                }
                           }
                            .aspectRatio(2/3, contentMode: .fit)
                            .padding(5)
                }
                .padding()
                .foregroundColor(viewModel.theme.color)
                Button("New Game") {
                    withAnimation(.easeInOut(duration: 0.5)){
                        viewModel.newGame()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle(viewModel.theme.name, displayMode: .inline)
            .navigationBarItems(trailing: Text("Score: \(viewModel.score)"))
        }
    }
}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        EmojiMemoryGameView(viewModel: EmojiMemoryGame(theme: MemoryTheme())
//    }
//}


struct CardView: View {
    var card: MemoryGame<String>.Card
    private let fontScaleFactor: CGFloat = 0.6

    @State private var animatedBonusRemaining: Double = 0

    private func startBonusTimeAnimation(){
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)){
            animatedBonusRemaining = 0
        }
    }

    @ViewBuilder
    var body: some View {
        GeometryReader{ gemoetry in
            if card.isFaceUp || !card.isMatched{
                ZStack{
                    Group {
                        if card.isConsumingBonusTime{
                            Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusRemaining*360-90), clockWise: true)
                                .onAppear{
                                    startBonusTimeAnimation()
                                }
                        }else{
                            Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-card.bonusRemaining*360-90), clockWise: true)

                        }
                    }
                    .padding(5)
                    .opacity(0.4)
                    .transition(.identity)

                    Text(card.content)
                        .font(Font.system(size: fontSize(for: gemoetry.size)))
                        .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                        .animation(card.isMatched ?  Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)

                }
                .cardify(isFaceUp: card.isFaceUp)
                .transition(AnyTransition.scale)
                }
            }
        
    }

    func fontSize (for size: CGSize) -> CGFloat {
        min(size.width, size.height) * fontScaleFactor
    }


}



