//
//  ContentView.swift
//  ShareApp-okubo
//
//  Created by 大久保徹郎 on 2023/02/15.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        // NavigationStackをContentViewで宣言していると、NavigationLinkを押した時にCPU使用率が99%近くになってフリーズしてしまう不具合が発生
        TextCreateView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
