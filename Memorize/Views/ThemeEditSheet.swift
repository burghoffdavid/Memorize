//
//  ThemeEditSheet.swift
//  Memorize
//
//  Created by David Burghoff on 14.03.21.
//

import SwiftUI

struct ThemeEditSheet: View{
    @State private var themeNameInput: String = ""
    @State private var emojiToAddInput: String = ""
    @State private var cardCountInput: Int = 0
    @Binding var editSheetShowing: Bool
    
    
    @EnvironmentObject var store: MemoryThemeStore
    
    var body: some View{
        NavigationView{
            Form{
                TextField("Theme Name", text: $themeNameInput, onEditingChanged: {began in
                    store.changeThemeName(themeNameInput)
                })
                Section(header: Text("Add Emoji")){
                    HStack{
                        TextField("Emoji", text: $emojiToAddInput)
                        Button(action: {
                            store.addThemeEmoji(emojiToAddInput)
                            emojiToAddInput = ""
                        }){
                            Text("Add")
                        }
                    }
                }
                Section(header:
                            HStack{
                                Text("Emojis")
                                Spacer()
                                Text("Tap Emoji to delete")
                                    .font(.footnote)
                            })
                {
                    Grid(store.selectedTheme.emojis.map{String($0)},id: \.self, viewForItem: {emoji in
                        Text(emoji)
                            .font(Font.system(size: fontSize))
                            .onTapGesture{
                                store.removeThemeEmoji(emoji)
                                }
                            })
                    .frame(height: height)
                }
                Section(header: Text("Card Count")){
                    Stepper("\(store.selectedTheme.numberOfPairsToShow) Pairs", onIncrement: {
                        store.changeNumberOfPairsToShow(by: 1)
                    }, onDecrement: {
                        store.changeNumberOfPairsToShow(by: -1)
                    })
                }
                Section(header: Text("Color")){
                    Grid(colorPalette, id: \.self, viewForItem: { color in
                        ZStack{
                            RoundedRectangle(cornerRadius: 5.0)
                                .fill(color)
                                .frame(minWidth: 50, minHeight: 60)
                                .onTapGesture{
                                    store.changeThemeColor(UIColor(color).rgb)
                                }
                                .padding()
                            if UIColor(color).isEqualWithConversion(UIColor(store.selectedTheme.color)){
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(color == .white ? .black : .white)
                                    .imageScale(.large)
                            }
                            
                        }
                        .padding()
                        .onAppear{
                         print("Colors ares same? \(UIColor(color).isEqualWithConversion(UIColor(store.selectedTheme.color)))")
                            print("View Color \(color)")
                            print("VM Color \(store.selectedTheme.color)")
                        }
                    })
                    .frame(height: colorPaletteHeight)
                }
            }
            .navigationBarTitle(store.selectedTheme.name, displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                editSheetShowing = false
            }){
                Text("Done")
            })
        }
        
    }
    //Mark: - Drawing Constants
    private var height: CGFloat{
        CGFloat((store.selectedTheme.emojis.count - 1 )/6) * 70 + 70
    }
    private let fontSize: CGFloat = 40
    
    private var colorPaletteHeight: CGFloat{
        CGFloat((colorPalette.count - 1 )/6) * 90 + 90
    }
    private let colorPalette = [Color.red, Color.purple, Color.blue, Color.black, Color.white, Color.green, Color.yellow, Color.gray, Color.orange]
}
