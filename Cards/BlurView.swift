//
//  BlurView.swift
//  Notr
//
//  Created by Linda Zungu on 2/15/21.
//

import SwiftUI

struct BlurView: UIViewRepresentable{
    
    var style: UIBlurEffect.Style = .systemThinMaterial
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
