//
//  UIExtension.swift
//  RxTest
//
//  Created by Sean Kim on 2022/11/22.
//

import UIKit
enum Location {
    case left
    case right
}

extension UITextField {
    func addPadding(_ location: Location, _ size: CGFloat) {
        let paddingWidthView = UIView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: size,
                                               height: self.frame.height))
        switch location {
        case .left:
            self.leftView = paddingWidthView
            self.leftViewMode = ViewMode.always
            
        case .right:
            self.rightView = paddingWidthView
            self.rightViewMode = ViewMode.always
            
        }
    }
}
