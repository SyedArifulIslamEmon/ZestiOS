//
//  String+Numeric.swift
//  MoltinSwiftExample
//
//  Created by Kelin Christi on 26/01/2016.
//  Copyright (c) 2016 Kelz All rights reserved.
//

import Foundation

extension String {
    func isNumericString() -> Bool {
        
        let nonDigitChars = NSCharacterSet.decimalDigitCharacterSet().invertedSet
        
        let string = self as NSString
        
        if string.rangeOfCharacterFromSet(nonDigitChars).location == NSNotFound {
            // definitely numeric entierly
            return true
        }
        
        return false
    }
}