//
//  Cardify.swift
//  Memorize
//
//  Created by David Burghoff on 01.08.20.
//

import SwiftUI

struct Cardify: AnimatableModifier { 

    // MARK: - Drawing Constants
    private let cornerRadius: CGFloat = 10.0
    private let edgeLineWidth: CGFloat = 3
    private let fontScaleFactor: CGFloat = 0.6
    var isFaceUp: Bool{
        rotation < 90
    }
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 :180
    }
    var rotation: Double

    

    var animatableData: Double{ // name the animation system looks for, rotation is used internally
        get {return rotation}
        set {rotation = newValue}
    }

    func body(content: Content) -> some View {
        ZStack{
            Group{
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: edgeLineWidth)
                    .foregroundColor(.gray)
                content
            }
                .opacity(isFaceUp ? 1 : 0)
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill()
                .opacity(isFaceUp ? 0 : 1)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (x: 0, y: 1, z: 0))

    }
}


extension View {
    func cardify (isFaceUp:Bool) -> some View{
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
