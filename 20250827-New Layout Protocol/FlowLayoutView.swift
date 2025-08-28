//
//  FlowLayoutView.swift
//  20250827-New Layout Protocol
//
//  Created by Da Wei Hao on 2025/8/27.
//

import SwiftUI

struct FlowLayout: Layout {
    var vSpacing: CGFloat = 10
    var aligmment: TextAlignment = .leading
    
    struct Row {
        var viewRects: [CGRect] = []
        var width: CGFloat { viewRects.last?.maxX ?? 0 }
        var height: CGFloat { viewRects.map(\.height).max() ?? 0 }
    }
    
    private func getRows(subviews: Subviews, totalWidth: CGFloat?) -> [Row] {
        guard let totalWidth, !subviews.isEmpty else { return [] }
        
        var rows = [Row()]
        let proposal = ProposedViewSize(width: totalWidth, height: nil)
        
        subviews.indices.forEach { index in
            let view = subviews[index]
            let size = view.sizeThatFits(proposal)
            let previousRect = rows.last?.viewRects.last ?? .zero
            let previousView = index == 0 ? nil : subviews[index - 1]
            let spacing = previousView?.spacing.distance(to: view.spacing, along: .horizontal) ?? 0
            
            print(size)
            switch previousRect.maxX + spacing + size.width > totalWidth {
                
            case true:
                // true: 換行
                let rect = CGRect(origin: .init(x: 0, y: previousRect.minY + rows.last!.height), size: size)
                rows.append(Row(viewRects: [rect]))
                
            case false:
                let rect = CGRect(origin: .init(x: previousRect.maxX + spacing, y: previousRect.minY), size: size)
                // false: 同行
               rows[rows.count - 1].viewRects.append(rect)
            }
        }
        return rows
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = getRows(subviews: subviews, totalWidth: proposal.width)
        return .init(width: rows.map(\.width).max() ?? 0,
                     height: rows.last?.viewRects.map(\.maxY).max() ?? 0)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = getRows(subviews: subviews, totalWidth: proposal.width)
        var index = 0
        
        rows.forEach { rect in
            let view = subviews[index]
            defer { index += 1 }
            
            view.place(at: .init(x: rect.minX,
                                 y: <#T##CGFloat#>),
                       proposal: <#T##ProposedViewSize#>)
        }
    }
}

struct FlowLayoutView: View {
    
    @State var aligmment: TextAlignment = .leading
    
    var body: some View {
        ScrollView {
            Picker("", selection: $aligmment) {
                Text("向前").tag(TextAlignment.leading)
                Text("向前").tag(TextAlignment.leading)
                Text("向前").tag(TextAlignment.leading)
            }.pickerStyle(.segmented)
        }
    }
}

#Preview {
    FlowLayoutView()
}

/*
 https://www.youtube.com/watch?v=v8Epp_8ZAOc&list=PLXM8k1EWy5ki1c36h_0hTWgMwt3SRzqVX&index=3
 */
