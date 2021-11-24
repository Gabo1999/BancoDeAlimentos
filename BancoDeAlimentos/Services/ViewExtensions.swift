//
//  ViewExtensions.swift
//  BancoDeAlimentos
//
//  Created by David Josué Marcial Quero on 24/11/21.
//

import SwiftUI


extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true:
            self.hidden()
        case false:
            self
        }
    }
}
