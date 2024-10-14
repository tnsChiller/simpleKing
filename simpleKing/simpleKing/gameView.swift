//
//  ContentView.swift
//  simpleKing
//
//  Created by Ilhan on 13/10/2024.
//

import SwiftUI

struct gameView: View {
    var body: some View {
        card(no: 12, suit: 0)
    }
}

func card(no: Int, suit: Int) -> some View {
    Image(systemName: "rectangle.portrait.fill")
        .font()
}

#Preview {
    gameView()
}
