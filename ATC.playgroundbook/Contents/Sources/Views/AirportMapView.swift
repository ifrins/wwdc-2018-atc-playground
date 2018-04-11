//
//  AirportMapView.swift
//  Pilot
//
//  Created by Francesc Bruguera on 27/03/2018.
//  Copyright © 2018 Francesc Bruguera. All rights reserved.
//

import Foundation
import UIKit

public class AirportMapView: BaseGeoView {
    
    private let grayColor = UIColor(white: 195/255, alpha: 1)

    private let airportTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0),
                                 NSAttributedStringKey.foregroundColor: UIColor(white: 195/255, alpha: 1)
    ]

    var airportData: [Airport]
    
    override public convenience init(frame frameRect: CGRect) {
        self.init(frame: frameRect, airportData: AirportDataLoader.loadAirportData())
    }
    
    public init(frame frameRect: CGRect, airportData: [Airport]) {
        self.airportData = airportData
        super.init(frame: frameRect)
        isOpaque = false
    }
    
    required public init?(coder decoder: NSCoder) {
        airportData = AirportDataLoader.loadAirportData()
        super.init(coder: decoder)
    }
    
    override public func draw(_ dirtyRect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        print("Draw Airports withs scaleFactor: \(zoomScale)")

        if (zoomScale > 3) {
            drawAirportsWithDetail(rect: dirtyRect, context: context)
        } else {
            drawAirportsSmall(rect: dirtyRect, context: context)
        }
        
        context.setStrokeColor(grayColor.cgColor)
        context.drawPath(using: .stroke)
    }
    
    func drawAirportsWithDetail(rect: CGRect, context: CGContext) {
        for airport in airportData where airport.type == .large && isPointVisible(coords: airport.coordinates) {
            let position = coordsToCGPoint(coords: airport.coordinates)
            let size = CGSize(width: 10, height: 10)
            context.addRect(CGRect(origin: position, size: size))
            
            let textPosition = CGPoint(x: position.x + size.width + 3, y: position.y - (size.height / 4))
            
            let attrString = NSAttributedString(string: airport.code,
                                                attributes: airportTextAttributes)
            
            attrString.draw(at: textPosition)
        }
    }
    
    func drawAirportsSmall(rect: CGRect, context: CGContext) {
        for airport in airportData where airport.type == .large && isPointVisible(coords: airport.coordinates) {
            let position = coordsToCGPoint(coords: airport.coordinates)
            let size = CGSize(width: zoomScale / 2, height: zoomScale / 2)

            context.addRect(CGRect(origin: position, size: size))
        }
    }
    
    public override func nextFrame() {
        /* no-op */
    }
}
