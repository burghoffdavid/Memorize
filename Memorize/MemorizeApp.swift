//
//  MemorizeApp.swift
//  Memorize
//
//  Created by David Burghoff on 31.07.20.
//

import SwiftUI

@main
struct MemorizeApp: App {
    var body: some Scene {
        WindowGroup {
            let store = MemoryThemeStore()
            ThemeChooserView(store: store)
        }
    }
}
