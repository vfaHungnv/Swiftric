//
//  SKSpriteNode-Extention.swift
//  HuCaTetris
//
//  Created by HungNV on 6/26/17.
//  Copyright © 2017 HungNV. All rights reserved.
//

import Foundation
import SpriteKit

extension SKSpriteNode {
    func aspectFillToSize(_ fillSize: CGSize) {
        if let texture = texture {
            self.size = texture.size()
            let verticalRatio = fillSize.height / self.size.height
            let horizontalRatio = fillSize.width / self.size.width
            let scaleRatio = horizontalRatio > verticalRatio ? horizontalRatio : verticalRatio
            self.setScale(scaleRatio)
        }
    }
}
