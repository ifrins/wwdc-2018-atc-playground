//
//  PlaneDataLoader.swift
//  Pilot
//
//  Created by Francesc Bruguera on 28/03/2018.
//  Copyright © 2018 Francesc Bruguera. All rights reserved.
//

import Foundation
import simd

class PlaneDataLoader {
    private let DOUBLE_LENGTH = 8
    private let INT_LENGTH = 4
    private let FLOAT_LENGTH = 4
    private let STRING_LENGTH = 4
    
    var framesOffset: [Int32] = []
    var bodyStart: Int32 = 0
    var timestampOffset: Int64 = 0
    var data: Data
    
    let PLANE_POSITION_SIZE = Int32(27)
    
    init() {
        let path = Bundle.main.path(forResource: "planes", ofType: "bin")!
        
        self.data = try! Data(contentsOf: URL(fileURLWithPath: path))
        
        self.readHeader()
    }
    
    private func readHeader() {
        self.timestampOffset = Int64(bigEndian: data.scanValue(start: 0, length: DOUBLE_LENGTH))
        let count: Int32 = Int32(bigEndian: data.scanValue(start: 8, length: INT_LENGTH))
        
        bodyStart = 8 + 4 + (4 * count)
        
        for i in 0...count - 1 {
            let readOffset = Int(8 + 4 + (i * 4))
            
            let offset = Int32(bigEndian: data.scanValue(start: readOffset, length: INT_LENGTH))
            
            framesOffset.append(bodyStart + offset)
        }
    }
    
    public func loadFrame(i: Int) -> (planes: [PlanePosition], timestamp: Int64) {
        var offset = framesOffset[i]
        let nextOffset: Int32
        if framesOffset.count > i + 1 {
            nextOffset = framesOffset[Int(i) + 1]
        } else {
            nextOffset = Int32(data.count)
        }
        
        var buffer: [PlanePosition] = []
        
        while offset < nextOffset {
            let planePosition = readPlanePosition(Int(offset))
            buffer.append(planePosition)
            offset += PLANE_POSITION_SIZE
        }
        
        let timestamp = timestampOffset + Int64(20 * 1000 * i)
        
        return (buffer, timestamp)
    }
    
    private func readPlanePosition(_ offset: Int) -> PlanePosition {
        let callsign: String = data.scanString(start: offset, length: STRING_LENGTH)
        let lat: Float32 = Float32(bitPattern: UInt32(bigEndian: data.scanValue(start: offset + 7, length: FLOAT_LENGTH)))
        let long: Float32 = Float32(bitPattern: UInt32(bigEndian: data.scanValue(start: offset + 7 + 4, length: FLOAT_LENGTH)))
        let altitude = Int32(bigEndian: data.scanValue(start: offset + 7 + 4 + 4, length: INT_LENGTH))
        let speed = Int32(bigEndian: data.scanValue(start: offset + 7 + 4 + 4 + 4, length: INT_LENGTH))
        let track = Int32(bigEndian: data.scanValue(start: offset + 7 + 4 + 4 + 4 + 4, length: INT_LENGTH))

        return PlanePosition(callsign, float2(x: long, y: lat), altitude, speed, track)
    }
}
