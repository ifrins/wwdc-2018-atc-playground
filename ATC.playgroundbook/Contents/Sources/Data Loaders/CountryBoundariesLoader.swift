//
//  CountryBoundariesLoader.swift
//  Pilot
//
//  Created by Francesc Bruguera on 26/03/2018.
//  Copyright © 2018 Francesc Bruguera. All rights reserved.
//

import Foundation
import simd

class CountryBoundariesLoader {
    static func loadBoundaries() -> [[float2]] {
        let pointsPath = Bundle.main.path(forResource: "points", ofType: "txt")!
        let file = try! String(contentsOfFile: pointsPath, encoding: .utf8)
        
        let lines = file.components(separatedBy: CharacterSet.newlines)
        
        var fullResutls: [[float2]] = []
        
        var array: [float2] = []
        
        for line in lines {
            if line == "" {
                fullResutls.append(array)
                array = []
            } else {
                let coords = line.components(separatedBy: CharacterSet.whitespaces)
                
                if (coords.count == 2) {
                    let x = Float(coords[0])!
                    let y = Float(coords[1])!
                    
                    let coord = float2(x: x, y: y)
                    array.append(coord)
                }
            }
        }
        
        return fullResutls
    }
}
