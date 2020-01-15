//
//  ContentView.swift
//  Example-SPM
//
//  Created by Honghao Zhang on 1/14/20.
//  Copyright © 2020 ChouTi. All rights reserved.
//

import SwiftUI
import Ji

struct ContentView: View {
    @State private var title: String = "Loading..."

    var body: some View {
        NavigationView {
            Text(title)
        }.onAppear(perform: delayAndFetch)
    }

    private func delayAndFetch() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let doc = Ji(htmlURL: URL(string: "http://www.apple.com")!)
            let titleNode = doc?.xPath("//head/title")?.first
            let titleString = titleNode?.content ?? "Failed"
            self.title = titleString
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
