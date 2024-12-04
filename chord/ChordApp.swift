//
//  ChordApp.swift
//  Chord
//
//  Created by Huy Ong on 11/10/24.
//

import SwiftUI

@main
struct ChordApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ViewModel())
        }
    }
}
