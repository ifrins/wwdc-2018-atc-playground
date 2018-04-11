//
//  AirportDataLoader.swift
//  Pilot
//
//  Created by Francesc Bruguera on 27/03/2018.
//  Copyright © 2018 Francesc Bruguera. All rights reserved.
//

import Foundation
import simd

public class AirportDataLoader {
    
    public static func loadAirportData() -> [Airport] {
        let path = Bundle.main.path(forResource: "airports_a", ofType: "txt")!
        
        let file = try! String(contentsOfFile: path, encoding: .utf8)
        
        let lines = file.components(separatedBy: CharacterSet.newlines)
        
        var array: [Airport] = []

        for line in lines {
            let components = line.components(separatedBy: CharacterSet.whitespaces)
            
            if components.count == 4 {
                let code = components[0]
                let lat = Float(components[1])!
                let lon = Float(components[2])!
                let type = AirportType(rawValue: Int8(components[3])!)!
                
                let airport = Airport(code: code, coordinates: float2(x: lat, y: lon), type: type)
                array.append(airport)
            }
        }
        
        return array
    }
}
