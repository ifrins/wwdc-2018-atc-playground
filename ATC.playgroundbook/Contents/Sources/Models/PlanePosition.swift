//
//  PlanePosition.swift
//  Pilot-iOS
//
//  Created by Francesc Bruguera on 31/03/2018.
//  Copyright © 2018 Francesc Bruguera. All rights reserved.
//

import Foundation
import simd

struct PlanePosition {
    let callsign: String
    let coordinates: float2
    let altitude: Int32
    let speed: Int32
    let track: Int32
    
    init(_ callsign: String,
         _ coordinates: float2,
         _ altitude: Int32,
         _ speed: Int32,
         _ track: Int32) {
        
        self.callsign = callsign
        self.coordinates = coordinates
        self.altitude = altitude
        self.speed = speed
        self.track = track
    }
}
