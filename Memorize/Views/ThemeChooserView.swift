//
//  ThemeChooserView.swift
//  Memorize
//
//  Created by David Burghoff on 13.03.21.
//

import SwiftUI

struct ThemeChooserView: View {
    @ObservedObject var store: MemoryThemeStore
    @State private var editMode: EditMode = .inactive
    @State private var editSheetShowing = false
    
    //@State var chosenTheme: MemoryTheme
    
    var body: some View {
        NavigationView{
            List{
                ForEach(store.themes){ theme in
                    NavigationLink(destination: EmojiMemoryGameView(viewModel: EmojiMemoryGame(theme: theme))){
                        HStack{
                            if editMode == .active{
                                Button(action: {
                                    store.changeTheme(to: theme)
                                    editSheetShowing = true
                                }){
                                    Image(systemName: "pencil.circle.fill")
                                        .imageScale(.large)
                                        .foregroundColor(theme.color)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }else {
                                EmptyView()
                            }
                            VStack(alignment: .leading){
                                Text(theme.name)
                                    .font(Font.system(.title))
                                if theme.numberOfPairsToShow == theme.emojis.count {
                                    Text("All of \(theme.emojis.joined())")
                                }else {
                                    Text("\(theme.numberOfPairsToShow) of \(theme.emojis.joined())")
                                }
                            }
                            .font(.subheadline)
                        }
                    }
                }
                .onDelete(perform: { indexSet in
                    indexSet.map{store.themes[$0]}.forEach{ theme in
                        store.deleteTheme(theme: theme)
                    }
                })
            }
            .navigationBarTitle(Text("Choose Theme"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                store.newTheme()
            }){
                Image(systemName: "plus")
            }, trailing: EditButton())
            .environment(\.editMode, $editMode)
            
        }
        .sheet(isPresented: $editSheetShowing){
            ThemeEditSheet(editSheetShowing: $editSheetShowing)
            .environmentObject(store)
    }
}
}

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
                Section(header: Text("Emojis")){
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
                    })
                    .frame(height: colorPaletteHeight)
                }
            }
            //.navigationBarTitleDisplayMode(.inline)
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
    let colorPalette = [Color.red, Color.purple, Color.blue, Color.black, Color.white, Color.green, Color.yellow, Color.gray, Color.orange]
}

//struct ThemeChooserView_Previews: PreviewProvider {
//    static var previews: some View {
//        ThemeChooserView()
//    }
//}
