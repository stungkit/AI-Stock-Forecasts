//
//  HomeView.swift
//  Stock Forecasts
//
//  Created by Alexis on 9/19/20.
//

import SwiftUI

struct HomeView: View {
    let iconlist = [ "industrials", "healthcare", "technology", "telecom-media", "goods", "energy", "financials", "all"]
    let layout = [GridItem(.adaptive(minimum: 128), spacing: 10, alignment: .center)]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.background.edgesIgnoringSafeArea(.bottom)
                VStack {
                    TitleView()
                    ScrollView {
                        LazyVGrid(columns: layout, spacing: 10) {
                            ForEach(iconlist, id: \.self) { item in
                                Tile(name: item)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
    }
}
