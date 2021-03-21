//
//  CustomButton.swift
//  VisitCard
//
//  Created by Damien DELES on 17/03/2021.
//

import SwiftUI

struct HWButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content.frame(width: 250, height: 44)
            .background(Color.blue.opacity(0.7))
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

extension View {
    func hwButtonStyle() -> some View {
        return self.modifier(HWButtonStyle())
    }
}
