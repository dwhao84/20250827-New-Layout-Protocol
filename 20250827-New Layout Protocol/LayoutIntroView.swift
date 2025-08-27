//
//  ContentView.swift
//  20250827-New Layout Protocol
//
//  Created by Da Wei Hao on 2025/8/27.
//

import SwiftUI

struct LayoutIntroView: View {
    var body: some View {
        TabView {
            PreviewLayoutView(title: "自動調整",tabImage: "1.circle") {
                LayoutViewTest()
            }
            PreviewLayoutView(title: "自訂 Layout",tabImage: "2.circle") {
                FlowLayoutView()
            }
            
            PreviewLayoutView(title: "自訂 Layout",tabImage: "3.circle") {
                ClockLayoutView()
            }
        }.background(Color.yellow)
    }
}

func PreviewLayoutView<Content: View>(title: String, tabImage: String, content: () -> Content) -> some View {
    content()
}

struct LayoutIntroView_Previews: PreviewProvider {
    static var previews: some View {
        LayoutIntroView()
    }
}
