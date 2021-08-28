//
//  TapToCenterTabBar.swift
//  TapToCenterTabBar
//
//  Created by Raphael Cerqueira on 27/08/21.
//

import SwiftUI

public struct TabItem: Identifiable {
    public let id = UUID().uuidString
    let title: String
}

public struct TapToCenterTabBar: View {
    var tabWidth: CGFloat = 120
    @State var xOffset: CGFloat = 0
    @State var currrentXOffset: CGFloat = 0
    var screenWidth: CGFloat = UIScreen.main.bounds.width
    @Binding var selectedIndex: Int
    @Namespace var namespace
    
    var tabItems: [TabItem]
    
    var selectedColor: Color = Color.primary
    var unselectedColor: Color = Color.gray
    
    public var body: some View {
        VStack(spacing: 0) {
            GeometryReader { reader in
                HStack(spacing: 0) {
                    ForEach(0 ..< tabItems.count) { i in
                        VStack {
                            Text(tabItems[i].title)
                                .foregroundColor(selectedIndex == i ? selectedColor : unselectedColor)
                                .font(.system(size: 15))
                            
                            ZStack {
                                if selectedIndex == i {
                                    Capsule()
                                        .frame(width: 60, height: 4)
                                        .foregroundColor(selectedColor)
                                        //.matchedGeometryEffect(id: "capsule", in: namespace)
                                } else {
                                    Capsule()
                                        .frame(width: 60, height: 4)
                                        .foregroundColor(.clear)
                                }
                            }
                        }
                        .frame(width: tabWidth)
                        .onTapGesture {
                            withAnimation {
                                selectedIndex = i
                            }
                            
                            // center on tap
                            let aux = tabWidth * CGFloat(selectedIndex)
                            if aux > screenWidth / 2 {
                                if aux > CGFloat(tabItems.count) * tabWidth - (screenWidth / 2) - (tabWidth / 2) {
                                    withAnimation {
                                        xOffset = -(CGFloat(tabItems.count) * tabWidth) + screenWidth - 30
                                    }
                                } else {
                                    withAnimation {
                                        xOffset = -aux + (screenWidth / 2) - (tabWidth / 2) - 15
                                    }
                                }
                            } else {
                                withAnimation {
                                    xOffset = 0
                                }
                            }
                            
                            currrentXOffset = xOffset
                        }
                    }
                }
                .padding(.horizontal)
                .offset(x: xOffset)
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            onChanged(value: value)
                        })
                        .onEnded({ value in
                            onEnded(value: value)
                        })
                )
            }
            .frame(height: 34)
            
            Divider()
        }
    }
    
    func onChanged(value: DragGesture.Value) {
        let aux = currrentXOffset + value.translation.width
        if value.translation.width < 0 { // right to left
            if aux < -(CGFloat(tabItems.count) * tabWidth) + screenWidth {
                withAnimation {
                    xOffset = -(CGFloat(tabItems.count) * tabWidth) + screenWidth - 30 // max value for xOffset
                }
            } else {
                withAnimation {
                    xOffset = aux
                }
            }
        } else if value.translation.width > 0 { // left to right
            if aux > 0 {
                withAnimation {
                    xOffset = 0
                }
            } else {
                withAnimation {
                    xOffset = aux
                }
            }
        }
    }
    
    func onEnded(value: DragGesture.Value) {
        currrentXOffset = xOffset
    }
}

struct PreviewContainer: View {
    @State var selectedIndex = 0

    let items = [
        TabItem(title: "Tab One"),
        TabItem(title: "Tab Two"),
        TabItem(title: "Tab Three"),
        TabItem(title: "Tab Four"),
        TabItem(title: "Tab Five"),
        TabItem(title: "Tab Six"),
        TabItem(title: "Tab Seven"),
        TabItem(title: "Tab Eight"),
    ]
    
    var body: some View {
        VStack {
            TapToCenterTabBar(selectedIndex: $selectedIndex, tabItems: items)
            
            Spacer()
        }
    }
}

struct TapToCenterTabBar_Previews: PreviewProvider {
    static var previews: some View {
        PreviewContainer()
    }
}

