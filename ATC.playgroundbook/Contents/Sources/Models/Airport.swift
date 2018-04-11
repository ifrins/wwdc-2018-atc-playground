//
//  Airport.swift
//  Pilot
//
//  Created by Francesc Bruguera on 27/03/2018.
//  Copyright © 2018 Francesc Bruguera. All rights reserved.
//

import Foundation
import simd

public struct Airport {
    public let code: String
    public let coordinates: float2
    public let type: AirportType
    
    init(code: String, coordinates: float2, type: AirportType) {
        self.code = code
        self.coordinates = coordinates
        self.type = type
    }
}

public enum AirportType: Int8 {
    case large = 2
    case medium = 1
    case small = 0
}
