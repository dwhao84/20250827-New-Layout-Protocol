//
//  LayoutViewTest.swift
//  20250827-New Layout Protocol
//
//  Created by Da Wei Hao on 2025/8/27.
//

import SwiftUI

// MARK: - 自訂 Layout
struct EqualSizeLayout: Layout {
    
    var hSpacing: CGFloat = 10
    var vSpacing: CGFloat = 10
    
    // MARK: 取得最大尺寸
    private func getMaxSize(_ subviews: Subviews) -> CGSize {
        return subviews.reduce(.zero) { maxSize, view in
            let size = view.sizeThatFits(.unspecified)
            return .init(width: max(maxSize.width, size.width), height: max(maxSize.height, size.height))
        }
    }
        
    // MARK: 計算 適合尺寸
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        
        // 取得最大寬度
        guard let totalWidth = proposal.width, !subviews.isEmpty else { return .zero }
        
        // 取得子視圖的最大尺寸
        let maxSize     = getMaxSize(subviews)
        
        // 計算每行可以容納的最大列數
        let maxColumns  = ((totalWidth + hSpacing / maxSize.width + hSpacing)).rounded(.down)
        let columns     = min(maxColumns, CGFloat(subviews.count))
        let rows        = (CGFloat(subviews.count) / columns).rounded(.up)
        
        let width       = columns * (maxSize.width + hSpacing) - hSpacing
        let height      = rows * (maxSize.height + vSpacing) - vSpacing
        
        // 回傳計算出的總尺寸
        return .init(width: width, height: height)
    }
    
    // MARK: - 放置子視圖
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        
        // 取得子視圖的最大尺寸
        let maxSize = getMaxSize(subviews)
        let proposal = ProposedViewSize(maxSize)
        
        // 找到邊界的最小 x 和 y 座標
        var x = bounds.minX
        var y = bounds.minY
        
        // 計算每行可以容納的最大列數
        subviews.forEach { view in
            view.place(at: .init(x: x, y: y), proposal: proposal)
            
            x += maxSize.width + hSpacing
            
            if (x >= bounds.maxX) {
                y += maxSize.height + vSpacing
                x = bounds.minX
            }
        }
    }
}

/*
 callAsFunction
 Layout的callAsFunction方法允許你直接將Layout實例當作函數來調用，這樣可以更簡潔地使用自訂的Layout。
 */

// MARK: - 測試 Layout
struct LayoutViewTest: View {

    let tags = [
        "WWDC22", "SwiftUI", "Swift", "Apple", "iPhone", "iPad", "iOS"
    ]
    
    var body: some View {
        VStack {
            EqualSizeLayout {
                ForEach(tags, id: \.self) { tag in
                        TextButton(title: tag)
                        TextButton(title: tag)
                        TextButton(title: tag)
                        TextButton(title: tag)
                }
            }
        }
        .padding()
    }
}

struct TextButton : View {
    let title: String
    var body: some View {
        Text(title)
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}



#Preview {
    LayoutViewTest()
}

/*
 https://www.youtube.com/watch?v=du_Bl7Br9DM&list=PLXM8k1EWy5ki1c36h_0hTWgMwt3SRzqVX&index=2
 */
