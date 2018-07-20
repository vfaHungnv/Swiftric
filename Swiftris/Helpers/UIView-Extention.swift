//
//  UIView-Extention.swift
//  HuCaTetris
//
//  Created by HungNV on 6/26/17.
//  Copyright © 2017 HungNV. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func mCustomView(_ radius: CGFloat) {
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.4
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
