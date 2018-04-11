
//
//  GeoMapView.swift
//  Pilot
//
//  Created by Francesc Bruguera on 26/03/2018.
//  Copyright © 2018 Francesc Bruguera. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

public class GeoMapView: BaseGeoView {
    let mapPath = CountryBoundariesLoader.loadBoundaries()
    
    override public func draw(_ dirtyRect: CGRect) {
        UIColor(red: 23/255, green: 22/255, blue: 18/255, alpha: 1).setFill()
        let context = UIGraphicsGetCurrentContext()!
        context.fill(dirtyRect)

        for shape in mapPath where shape.count != 0 && isPolylinePartiallyVisible(coords: shape) {
            let cgPoint = CGPoint(x: Double(shape[0].x), y: Double(shape[0].y))
            context.move(to: cgPoint)

            let points = shape.flatMap { coordsToCGPoint(coords: $0) }
            
            context.addLines(between: points)
            context.closePath()
        }
        
        context.setLineWidth(0.3)
        context.setStrokeColor(UIColor.white.cgColor)
        context.strokePath()
    }
    
    public override func nextFrame() {
        /* no-op */
    }
}
