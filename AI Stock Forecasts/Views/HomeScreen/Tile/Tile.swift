//
//  Tile.swift
//  Stock Forecasts
//
//  Created by Alexis on 9/20/20.
//

import SwiftUI

struct Tile: View {
    let name: String
    var body: some View {
        NavigationLink(destination: SelectionView(sector: name)) {
            VStack {
                Image(name)
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 128, height: 128)
                    .padding()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 2))
                Divider()
                Text(name.uppercased())
            }
        }
    }
}
