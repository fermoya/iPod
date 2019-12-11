//
//  Pager.swift
//  iPod
//
//  Created by Fernando Moya de Rivas on 05/12/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

struct Pager<Data, Content>: View  where Content: View, Data: Identifiable & Equatable {

    enum Direction {
        case forward, backward
    }

    private let content: (Data) -> Content
    private var pageSize: CGSize
    private var data: [Data]
    private var realItemSpacing: CGFloat
    private var verticalInsets: CGFloat

    private let unfocusedItemScale: CGFloat = 0.8
    private let focusedItemScale: CGFloat = 1
    private var extraOffset = 0

    @State private var draggingOffset: CGFloat = 0
    @State private var draggingStartTime: Date! = nil
    @Binding private var page: Int

    private var contentOffset: CGFloat = 0

    private var numberOfPages: Int { data.count }
    private var scaleTotalIncrement: CGFloat { focusedItemScale - unfocusedItemScale }
    private var itemSpacing: CGFloat { realItemSpacing - (pageSize.width * scaleTotalIncrement) / 2 }
    private var isDragging: Bool { abs(totalOffset) > 0 }

    private var backgroundColor: Color = .clear
    private var shadowColor: Color = .clear

    private var direction: Direction? {
        guard totalOffset != 0 else { return nil }
        return totalOffset < 0 ? .forward : .backward
    }

    private var offsetLowerbound: CGFloat {
        CGFloat(numberOfPages) / 2 * pageDistance - pageDistance / 4

    }
    private var offsetUpperbound: CGFloat { -CGFloat(numberOfPages) / 2 * pageDistance + pageDistance / 4}

    private var totalOffset: CGFloat {
        draggingOffset + contentOffset
    }

    private var currentPage: Int {
        guard isDragging else { return page }
        let newPage = -Int((totalOffset / self.pageDistance).rounded()) + self.page
        return max(min(newPage, self.numberOfPages - 1), 0)
    }

    init(page: Binding<Int>, pageSize: CGSize, data: [Data], itemSpacing: CGFloat = 20, verticalInsets: CGFloat = 4, content: @escaping (Data) -> Content) {
        self._page = page
        self.pageSize = CGSize(width: pageSize.width - 8, height: (pageSize.width - 2 * verticalInsets) * pageSize.height / pageSize.width)
        self.data = data
        self.realItemSpacing = itemSpacing
        self.verticalInsets = verticalInsets
        self.content = content
    }

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: self.itemSpacing) {
                ForEach(self.data) { item in
                    self.content(item)
                        .frame(width: self.pageSize.width,
                               height: self.pageSize.height,
                               alignment: .center)
                        .scaleEffect(self.scale(for: item))
                        .onTapGesture (perform: {
                            withAnimation(.spring()) {
                                self.scrollToItem(item)
                            }
                        }).shadow(color: self.shadowColor, radius: 5)
                }
                .offset(x: self.xOffset, y : 0)
            }
            .frame(width: geometry.size.width,
                   height: geometry.size.height)
            .clipped()
            .gesture(self.swipeGesture)
        }
        .padding(.vertical, verticalInsets)
        .background(backgroundColor)
    }
}

// MARK: Gestures

extension Pager {

    var swipeGesture: some Gesture {
        DragGesture()
            .onChanged({ value in
                withAnimation {
                    self.draggingStartTime = self.draggingStartTime ?? value.time
                    self.draggingOffset = value.translation.width
                }
            }).onEnded({ (value) in
                let velocity = -Double(value.translation.width) / value.time.timeIntervalSince(self.draggingStartTime)

                var newPage = self.currentPage + Int(velocity / 2000)
                newPage = max(0, min(self.numberOfPages - 1, newPage))
                let extraPage = abs(newPage - self.page)

                let animation: Animation = extraPage > 0 ? .spring(response: 0.55, dampingFraction: 0.825, blendDuration: Double(extraPage) * 0.2) : .easeOut
                withAnimation(animation) {
                    self.page = newPage
                    self.draggingOffset = 0
                    self.draggingStartTime = nil
                }
            }
        )
    }

}

extension Pager: Buildable {

    func pageOffset(_ pageOffset: Double) -> Self {
        let contentOffset = CGFloat(pageOffset) * pageDistance
        return mutate(keyPath: \.contentOffset, value: contentOffset)
    }

    func background(_ background: Color, alignment: Alignment = .center) -> some View {
        mutate(keyPath: \.backgroundColor, value: background)
    }

    func itemShadowColor(_ color: Color) -> Self {
        mutate(keyPath: \.shadowColor, value: color)
    }

}

extension Pager {

    private func scale(for item: Data) -> CGFloat {
        guard isDragging else { return isFocused(item) ? focusedItemScale : unfocusedItemScale }

        let totalIncrement = abs(totalOffset / pageDistance)
        let currentPage = direction == .forward ? CGFloat(page) + totalIncrement : CGFloat(page) - totalIncrement

        guard let indexInt = data.firstIndex(of: item) else { return unfocusedItemScale }

        let index = CGFloat(indexInt)
        guard abs(currentPage - index) <= 1 else { return unfocusedItemScale }

        let increment = totalIncrement - totalIncrement.rounded(.towardZero)
        let nextPage = direction == .forward ? currentPage.rounded(.awayFromZero) : currentPage.rounded(.towardZero)
        guard currentPage > 0 else {
            return focusedItemScale - (scaleTotalIncrement * increment)
        }

        return index == nextPage ? unfocusedItemScale + (scaleTotalIncrement * increment)
            : focusedItemScale - (scaleTotalIncrement * increment)
    }

    private func isFocused(_ item: Data) -> Bool {
        data.firstIndex(of: item) == currentPage
    }

    private func scrollToItem(_ item: Data) {
        guard let index = data.firstIndex(of: item) else { return }
        self.page = index
    }

    private var pageDistance: CGFloat {
        pageSize.width + self.itemSpacing
    }

    private var xOffset: CGFloat {
        let page = CGFloat(self.page)
        let numberOfPages = CGFloat(self.numberOfPages)
        let xIncrement = pageDistance / 2
        let offset = (numberOfPages / 2 - page) * pageDistance - xIncrement + totalOffset
        return max(offsetUpperbound, min(offsetLowerbound, offset))
    }

}
