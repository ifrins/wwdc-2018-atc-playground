//
//  ContainerView.swift
//  Pilot-iOS
//
//  Created by Francesc Bruguera on 31/03/2018.
//  Copyright © 2018 Francesc Bruguera. All rights reserved.
//

import UIKit

public class ContainerView: UIView {
    
    public var geoViews: [BaseGeoView] = []
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupGestureRecognizers()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGestureRecognizers()
    }
    
    public func addView(_ view: BaseGeoView) {
        geoViews.append(view)
        addSubview(view)
    }
    
    func setupGestureRecognizers() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinch(_:)))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        
        addGestureRecognizer(pinch)
        addGestureRecognizer(pan)
    }
    
    @objc func pinch(_ gestureRecognizer : UIPinchGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            let location1 = gestureRecognizer.location(in: self)
            
            for view in geoViews {
                view.handleScale(point: location1, scale: gestureRecognizer.scale)
            }
        
            gestureRecognizer.scale = 1.0
        }
    }
    
    @objc func pan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            let translation = gestureRecognizer.translation(in: self)
            
            for view in geoViews {
                view.handlePan(pan: translation)
            }
            
            gestureRecognizer.setTranslation(CGPoint.zero, in: self)
        }
    }
}
