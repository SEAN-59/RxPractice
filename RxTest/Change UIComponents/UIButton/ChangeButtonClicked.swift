//
//  ChangeButtonClicked.swift
//  RxTest
//
//  Created by Sean Kim on 2022/11/06.
//

import UIKit

class ChangeButtonClicked: UIButton {
    var isSizeChangeBtn : Bool = false
    
    override var isHighlighted: Bool {
        didSet {
            if isSizeChangeBtn { self.animationWhenHighlighted() }
        }
    }
    
    private func animationWhenHighlighted() {
        let animationElement = self.isHighlighted ? SizeChangeAnimation.touchDown.element : SizeChangeAnimation.touchUp.element
        
        UIView.animate(withDuration: animationElement.duration,
                       delay: animationElement.delay,
                       options: animationElement.options,
                       animations: {
            self.transform = animationElement.scale
            self.alpha = animationElement.alpha
        })
    }
}

private enum SizeChangeAnimation {
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
