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

//struct ThemeChooserView_Previews: PreviewProvider {
//    static var previews: some View {
//        ThemeChooserView()
//    }
//}
