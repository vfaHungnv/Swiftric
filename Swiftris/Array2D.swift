//
//  Array2D.swift
//  HuCaTetris
//
//  Created by HungNV on 6/23/17.
//  Copyright © 2017 HungNV. All rights reserved.
//

import Foundation

// #1
class Array2D<T> {
    let columns: Int
    let rows: Int
    
    // #2
    var array: Array<T?>
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        
        // #3
        array = Array<T?>(repeating: nil, count: rows * columns)
    }
    
    subscript(column: Int, row: Int) -> T? {
        get {
            return array[(row * columns) + column]
        }
        set(newValue) {
            array[(row * columns) + column] = newValue
        }
    }
}
