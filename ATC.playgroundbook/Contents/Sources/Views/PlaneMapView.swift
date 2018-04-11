//
//  PlaneMapView.swift
//  Pilot
//
//  Created by Francesc Bruguera on 28/03/2018.
//  Copyright © 2018 Francesc Bruguera. All rights reserved.
//

import Foundation
import UIKit

public class PlaneMapView: BaseGeoView {
    private let PLANE_SIZE = 8
    private let PLANE_TRACK_SIZE = Double(30)
    private var loader = PlaneDataLoader()
    private var planes: [PlanePosition] = []
    private var timestamp: Int64 = 0
    private var displayFrame = 2
    
    private let dateFormatter = DateFormatter()
    
    private let airplaneTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0),
                                 NSAttributedStringKey.foregroundColor: UIColor.green
    ]
    
    private let dateTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0),
                                      NSAttributedStringKey.foregroundColor: UIColor(white: 0.6, alpha: 1)
    ]

    
    override public init(frame frameRect: CGRect) {
        let planesData = loader.loadFrame(i: displayFrame)
        planes = planesData.planes
        timestamp = planesData.timestamp
        dateFormatter.dateFormat = "MM-dd HH:mm:ss"
        super.init(frame: frameRect)
        isOpaque = false
    }
    
    required public init?(coder decoder: NSCoder) {
        let planesData = loader.loadFrame(i: displayFrame)
        planes = planesData.planes
        timestamp = planesData.timestamp
        dateFormatter.dateFormat = "MM-dd HH:mm:ss"
        super.init(coder: decoder)
    }
    
    override public func draw(_ dirtyRect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        
        if (zoomScale > 5) {
            drawPlanesWithDetail(rect: dirtyRect, context: context)
        } else if (zoomScale > 2) {
            drawPlanesSmall(rect: dirtyRect, context: context)
        }

        context.setStrokeColor(UIColor.green.cgColor)
        context.drawPath(using: .stroke)
        
        drawDate()
    }
    
    func drawDate() {
        let date = Date(timeIntervalSince1970: Double(timestamp / 1000))
        let formattedDate = dateFormatter.string(from: date)
        let dateAttributedString = NSAttributedString(string: formattedDate, attributes: dateTextAttributes)
        dateAttributedString.draw(at: CGPoint.zero)
    }
    
    func drawPlanesWithDetail(rect: CGRect, context: CGContext) {
        for plane in planes where isPointVisible(coords: plane.coordinates) {
            let planePoint = super.coordsToCGPoint(coords: plane.coordinates)
            let size = CGSize(width: PLANE_SIZE, height: PLANE_SIZE)
            let point = CGRect(origin: planePoint, size: size)
            context.addRect(point)
            
            let string = "\(plane.callsign)\n\(plane.altitude)ft ∙ \(plane.speed)kt"
            
            let attrString = NSAttributedString(string: string,
                                                attributes: airplaneTextAttributes)
            attrString.draw(at: CGPoint(x: point.origin.x + 23, y: point.origin.y + 5))
            
            let angle = Double((plane.track + (90)))
            let track = angle * .pi / 180
            
            let planeLineOrigin = CGPoint(x: planePoint.x + 4, y: planePoint.y + 4)
            
            let finalLinePoint = CGPoint(x: Double(planeLineOrigin.x) + (cos(track) * PLANE_TRACK_SIZE), y: Double(planeLineOrigin.y) + (sin(track) * PLANE_TRACK_SIZE))
            context.move(to: planeLineOrigin)
            context.addLine(to: finalLinePoint)
        }
    }
    
    func drawPlanesSmall(rect: CGRect, context: CGContext) {
        for plane in planes where isPointVisible(coords: plane.coordinates) {
            let planePoint = super.coordsToCGPoint(coords: plane.coordinates)
            
            let size = CGSize(width: zoomScale / 5, height: zoomScale / 5)
            let rect = CGRect(origin: planePoint, size: size)
            context.addEllipse(in: rect)
        }
    }
    
    public override func nextFrame() {
        let planesData = loader.loadFrame(i: displayFrame)
        planes = planesData.planes
        timestamp = planesData.timestamp
        self.setNeedsDisplay(self.frame)
        if (self.displayFrame + 1 < self.loader.framesOffset.count) {
            self.displayFrame += 1
        } else {
            self.displayFrame = 0
        }
    }
}
