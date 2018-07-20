//
//  SquareShape.swift
//  HuCaTetris
//
//  Created by HungNV on 6/24/17.
//  Copyright © 2017 HungNV. All rights reserved.
//

import Foundation

class SquareShape: Shape {
    /*
        // #9
        
        | 0~| 1 |
     
        | 2 | 3 |
     
     ~ marks the row/column indicator for the shape
     */
    
    // The square shape will not rotate
    
    // #10
    override var blockRowColumnPositions: [Orientation : Array<(columnDiff: Int, rowDiff: Int)>] {
        return [
            Orientation.zero: [(0, 0), (1, 0), (0, 1), (1, 1)],
            Orientation.oneEighty: [(0, 0), (1, 0), (0, 1), (1, 1)],
            Orientation.ninety: [(0, 0), (1, 0), (0, 1), (1, 1)],
            Orientation.twoSeventy: [(0, 0), (1, 0), (0, 1), (1, 1)]
        ]
    }
    
    // #11
    override var bottomBlocksForOrientations: [Orientation : Array<Block>] {
        return [
            Orientation.zero: [blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
            Orientation.oneEighty: [blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
            Orientation.ninety: [blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
            Orientation.twoSeventy: [blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
        ]
    }
}
