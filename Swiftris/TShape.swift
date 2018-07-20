//
//  TShape.swift
//  HuCaTetris
//
//  Created by HungNV on 6/24/17.
//  Copyright © 2017 HungNV. All rights reserved.
//

import Foundation

class TShape: Shape {
    /*
        Orientation 0
     
          ~ | 0 |
     
        | 1 | 2 | 3 |
     
        
        Orientation 90
     
        ~ | 1 |
     
          | 2 | 0 |
          
          | 3 |
     
        Orientation 180
     
         ~
     
        | 1 | 2 | 3 |
     
            | 0 |
     
        Orientation 270
     
         ~ | 1 |
     
       | 0 | 2 |
     
           | 3 |
     
     ~ marks the row/column indicator for the shape
     */
    
    // The square shape will not rotate
    
    // #10
    override var blockRowColumnPositions: [Orientation : Array<(columnDiff: Int, rowDiff: Int)>] {
        return [
            Orientation.zero: [(1, 0), (0, 1), (1, 1), (2, 1)],
            Orientation.ninety: [(2, 1), (1, 0), (1, 1), (1, 2)],
            Orientation.oneEighty: [(1, 2), (0, 1), (1, 1), (2, 1)],
            Orientation.twoSeventy: [(0, 1), (1, 0), (1, 1), (1, 2)]
        ]
    }
    
    // #11
    override var bottomBlocksForOrientations: [Orientation : Array<Block>] {
        return [
            Orientation.zero: [blocks[SecondBlockIdx], blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
            Orientation.ninety: [blocks[FirstBlockIdx], blocks[FourthBlockIdx]],
            Orientation.oneEighty: [blocks[FirstBlockIdx], blocks[SecondBlockIdx], blocks[FourthBlockIdx]],
            Orientation.twoSeventy: [blocks[FirstBlockIdx], blocks[FourthBlockIdx]],
        ]
    }
}
