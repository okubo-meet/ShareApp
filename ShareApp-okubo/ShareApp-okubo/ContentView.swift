//
//  ContentView.swift
//  ShareApp-okubo
//
//  Created by 大久保徹郎 on 2023/02/15.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            TextCreateView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
