//
//  BaseGeoView.swift
//  Pilot
//
//  Created by Francesc Bruguera on 27/03/2018.
//  Copyright © 2018 Francesc Bruguera. All rights reserved.
//

import Foundation
import UIKit
import simd

public class BaseGeoView: UIView {
    
    var zoomScale: CGFloat {
        get {
            if earthRect.width > 180 {
                return 1
            } else if earthRect.width > 90 {
                return 2
            } else if earthRect.width > 20 {
                return 3
            } else if earthRect.width > 10 {
                return 4
            } else if earthRect.width > 5 {
                return 5
            } else if earthRect.width < 5 {
                return 6
            } else {
                return 1
            }
        }
    }
    //var earthRect: CGRect = CGRect(x: -180.0, y: -90, width: 360, height: 180)
    //var earthRect: CGRect = CGRect(x: -0.8116669655, y: 39.085556956, width: 4.5361390114, height: 5.7482037928)
    var earthRect: CGRect = CGRect(x: 1.5116669655, y: 40.085556956, width: 1.5361390114, height: 1.7482037928)
    
    func coordsToCGPoint(coords: float2) -> CGPoint {
        let earthOriginX = Float(earthRect.origin.x)
        let earthOriginY = Float(earthRect.origin.y)
        let earthWidth = Float(earthRect.size.width)
        let earthHeight = Float(earthRect.size.height)
        
        let xIndexPos = (coords.x - earthOriginX) / earthWidth
        let yIndexPos = (coords.y - earthOriginY) / earthHeight
        
        let x = Double(xIndexPos) * Double(frame.width)
        let y = Double(yIndexPos) * Double(frame.height)
        
        var affineTransform = CGAffineTransform.init(scaleX: 1, y: -1)
        affineTransform = affineTransform.translatedBy(x: 0, y: -self.frame.size.height)
        
        let point = CGPoint(x: x, y: y)
        
        return point.applying(affineTransform)
    }
    
    func pointToCoords(point: CGPoint) -> float2 {
        var affineTransform = CGAffineTransform.init(translationX: 0, y: frame.size.height)
        affineTransform = affineTransform.scaledBy(x: 1, y: -1)
        
        let correctPoint = point.applying(affineTransform)
        
        let xPosIndex = correctPoint.x / frame.width
        let yPosIndex = correctPoint.y / frame.height
        
        let x = xPosIndex * earthRect.size.width + earthRect.origin.x
        let y = yPosIndex * earthRect.size.height + earthRect.origin.y
        
        return float2(x: Float(x), y: Float(y))
    }
    
    func isPointVisible(coords: float2) -> Bool {
        return earthRect.contains(CGPoint(x: Double(coords.x), y: Double(coords.y)))
    }
    
    func isPolylinePartiallyVisible(coords: [float2]) -> Bool {
        for coord in coords {
            if isPointVisible(coords: coord) {
                return true
            }
        }
        
        return true
    }
    
    func handleScale(point: CGPoint, scale: CGFloat) {
        let scaleFactor: CGFloat
        if (scale > 1) {
            scaleFactor = 0.9
            //Less width
        } else {
            scaleFactor = 1.1
            //More width
        }
        
        let midPointX = earthRect.midX
        let midPointY = earthRect.midY
        
        let scaledSize = CGSize(width: earthRect.width * scaleFactor, height: earthRect.height * scaleFactor)
        let scaledO = CGPoint(x: midPointX - (scaledSize.width / 2), y: midPointY - (scaledSize.height / 2))
        earthRect = CGRect(origin: scaledO, size: scaledSize)
        
        self.setNeedsDisplay()
    }
    
    func handlePan(pan: CGPoint) {
        let xPercentage = pan.x / frame.width
        let yPercentage = pan.y / frame.width
        
        let xDiff = -earthRect.width * xPercentage
        let yDiff = earthRect.height * yPercentage
        
        let earthOrigin = CGPoint(x: earthRect.origin.x + xDiff, y: earthRect.origin.y + yDiff)
        
        earthRect = CGRect(origin: earthOrigin, size: earthRect.size)
        setNeedsDisplay()
    }
    
    func handleZoomChange(zoomScale: CGFloat) {
        self.contentScaleFactor = zoomScale
        setNeedsDisplay()
    }
    
    public func changeCenterToCoords(point: CGPoint) {
        let normalizedPoint = CGPoint(x: point.x - (earthRect.size.width / 2), y: point.y - (earthRect.size.height / 2))
        earthRect = CGRect(origin: point, size: earthRect.size)
        setNeedsDisplay()
    }
    
    public func nextFrame() {
        preconditionFailure("Must Override")
    }
}
