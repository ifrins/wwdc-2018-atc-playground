//
//  BinaryExtensions.swift
//  Pilot
//
//  Created by Francesc Bruguera on 28/03/2018.
//  Copyright © 2018 Francesc Bruguera. All rights reserved.
//

import Foundation

extension Data {
    func scanValue<T>(start: Int, length: Int) -> T {
        return self.subdata(in: start..<start+length).withUnsafeBytes { $0.pointee }
    }
    
    func scanString(start: Int, length: Int) -> String {
        return String(data: self.subdata(in: start..<start+length), encoding: .ascii)!
    }
}

