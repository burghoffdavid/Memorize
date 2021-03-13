//
//  MemoryThemeStore.swift
//  Memorize
//
//  Created by David Burghoff on 13.03.21.
//

import Combine
import Foundation
import UIKit

final class MemoryThemeStore: ObservableObject{
    
    @Published var themes = [MemoryTheme]()
    @Published var selectedTheme: MemoryTheme
    
    private var autosave: AnyCancellable?
    private var autoChangeSelectedTheme: AnyCancellable?
    
    //MARK: - Default Themes
    static var defaultThemes = [
        MemoryTheme(name: "Halloween", emojis: ["👻", "🎃", "🕷", "🧙", "💀"].shuffled(), colorRGB: UIColor.orange.rgb),
        MemoryTheme(name: "Christmas", emojis: ["🎄", "🤶", "🎅", "🎁"].shuffled(), colorRGB: UIColor.red.rgb),
        MemoryTheme(name: "Winter", emojis: ["🥶", "❄️", "☃️", "🧦", "🌨", "⛸", "🏂"].shuffled(), colorRGB: UIColor.blue.rgb),
        MemoryTheme(name: "Beach", emojis: ["👙", "🏝", "⛱", "🩳", "🩱", "🗿"].shuffled(), colorRGB: UIColor.yellow.rgb),
        MemoryTheme(name: "Animals", emojis: ["🐶", "🐱", "🐷", "🐵", "🐔", "🦇", "🐍"].shuffled(), colorRGB: UIColor.green.rgb),
        MemoryTheme(name: "Alcohol!", emojis: ["🥃", "🥂", "🍷", "🍺", "🍶", "🍸", "🍹", "🍾"].shuffled(), colorRGB: UIColor.brown.rgb)
        
    ]
    
    init(named name: String = "Memory Theme") {
        let defaultsKey = "MemoryThemeStore.\(name)"
        if let themesData = UserDefaults.standard.data(forKey: defaultsKey){
            print("found theme data")
            if let themesDecoded = try? JSONDecoder().decode([MemoryTheme].self, from: themesData){
                themes = themesDecoded
            }
        }else {
            themes = MemoryThemeStore.defaultThemes
        }
        selectedTheme = MemoryThemeStore.defaultThemes[0]
        autosave = $themes.sink { themes in
            if let indexOfSelectedTheme = themes.firstIndex(matching: self.selectedTheme){
                self.selectedTheme = themes[indexOfSelectedTheme]
            }
            
            if let themesData = try? JSONEncoder().encode(themes){
                print("encoded Themes!")
                UserDefaults.standard.set(themesData, forKey: defaultsKey)
            }
        }
        
    }
    
   
    
    //MARK: - Access to the model
    func storeTheme(_ theme: MemoryTheme){
        if let themeIndex  = themes.firstIndex(matching: theme){
            themes[themeIndex] = theme
            selectedTheme = theme
        }
    }
    
    //MARK: - Intents
    func changeTheme(to theme: MemoryTheme) {
        if let themeIndex  = themes.firstIndex(matching: theme){
            selectedTheme = themes[themeIndex]
        }
    }
    
    func changeThemeName(_ newName: String){
        if let themeIndex  = themes.firstIndex(matching: selectedTheme){
            themes[themeIndex].name = newName
        }
    }
    func addThemeEmoji(_ textInput: String){
        let filteredArray = textInput
            .unique()
            .filter{ str in
                print(str)
                return !selectedTheme.emojis.contains(String(str)) && str != " "
            }
            .map{String($0)}
        
        if let themeIndex  = themes.firstIndex(matching: selectedTheme){
            themes[themeIndex].emojis.append(contentsOf: filteredArray)
        }
    }
    func changeThemeColor(_ color: UIColor.RGB){
        if let themeIndex  = themes.firstIndex(matching: selectedTheme){
            themes[themeIndex].colorRGB = color
        }
    }
    func removeThemeEmoji(_ emoji: String){
        if let themeIndex  = themes.firstIndex(matching: selectedTheme){
            if let emojiIndex = themes[themeIndex].emojis.firstIndex(of: emoji){
                themes[themeIndex].emojis.remove(at: emojiIndex)
                if (themes[themeIndex].numberOfPairsToShow > themes[themeIndex].emojis.count){
                    themes[themeIndex].numberOfPairsToShow = themes[themeIndex].emojis.count
                }
            }
            
        }
    }
    func changeNumberOfPairsToShow(by value: Int){
        if ((selectedTheme.numberOfPairsToShow + value) > selectedTheme.emojis.count) == false && (selectedTheme.numberOfPairsToShow + value) != 0{
            if let themeIndex = themes.firstIndex(matching: selectedTheme){
                themes[themeIndex].numberOfPairsToShow += value
            }
        }else {
            // error
        }
    }
    
    
    func newTheme(){
        let newTheme = MemoryTheme(name: "Untitled", emojis: [], colorRGB: UIColor.gray.rgb)
        themes.append(newTheme)
    }
    
    func deleteTheme(theme: MemoryTheme){
        if let themeIndex = themes.firstIndex(matching: theme){
            themes.remove(at: themeIndex)
        }// TO-DO: Error Message
    }
}
