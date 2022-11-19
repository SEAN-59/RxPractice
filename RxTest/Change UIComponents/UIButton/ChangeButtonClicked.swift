//
//  ChangeButtonClicked.swift
//  RxTest
//
//  Created by Sean Kim on 2022/11/06.
//

import UIKit

class ChangeButtonClicked: UIButton {
    var isSizeUpBtn : Bool = false
    var isSizeDownBtn: Bool = false
    
    override var isHighlighted: Bool {
        didSet {
            if isSizeUpBtn { self.animationWhenHighlightedUp() }
            if isSizeDownBtn { self.animationWhenHighlightedDown()}
        }
    }
    private func animationWhenHighlightedDown() {
        let animationElement = self.isHighlighted ? SizeDown.touchDown.element : SizeDown.touchUp.element
        
        UIView.animate(withDuration: animationElement.duration,
                       delay: animationElement.delay,
                       options: animationElement.options,
                       animations: {
            self.transform = animationElement.scale
            self.alpha = animationElement.alpha
        })
    }
    
    private func animationWhenHighlightedUp() {
        let animationElement = self.isHighlighted ? SizeUp.touchDown.element : SizeUp.touchUp.element
        
        UIView.animate(withDuration: animationElement.duration,
                       delay: animationElement.delay,
                       options: animationElement.options,
                       animations: {
            self.transform = animationElement.scale
            self.alpha = animationElement.alpha
        })
    }
}

private enum SizeUp {
    typealias Element = (
        duration: TimeInterval,
        delay: TimeInterval,
        options: UIView.AnimationOptions,
        scale: CGAffineTransform,
        alpha: CGFloat
    )
    
    case touchDown
    case touchUp
    
    var element: Element {
        switch self {
        case .touchDown:
            return Element(duration: 0,
                           delay: 0,
                           options: .curveLinear,
                           scale: .init(scaleX: 1.1, y: 1.1),
                           alpha: 0.8)
        case .touchUp:
            return Element(duration: 0,
                           delay: 0,
                           options: .curveLinear,
                           scale: .identity,
                           alpha: 1)
        }
    }
    
    
}

private enum SizeDown {
    typealias Element = (
        duration: TimeInterval,
        delay: TimeInterval,
        options: UIView.AnimationOptions,
        scale: CGAffineTransform,
        alpha: CGFloat
    )
    
    case touchDown
    case touchUp
    
    var element: Element {
        switch self {
        case .touchDown:
            return Element(duration: 0,
                           delay: 0,
                           options: .curveLinear,
                           scale: .init(scaleX: 0.7, y: 0.7),
                           alpha: 0.8)
        case .touchUp:
            return Element(duration: 0,
                           delay: 0,
                           options: .curveLinear,
                           scale: .identity,
                           alpha: 1)
        }
    }
    
    
}

