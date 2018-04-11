import Foundation
import UIKit
import PlaygroundSupport

class PlanesVC : UIViewController, PlaygroundLiveViewMessageHandler {
    
    let airports = AirportDataLoader.loadAirportData()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let innerFrame = self.view.frame
        
        let mapView = GeoMapView(frame: innerFrame)
        let airportView = AirportMapView(frame: innerFrame, airportData: airports)
        let planeView = PlaneMapView(frame: innerFrame)
                
        let containerView = ContainerView(frame: innerFrame)
        
        containerView.addView(mapView)
        containerView.addView(airportView)
        containerView.addView(planeView)
        
        self.view = containerView
    }
    
    func receive(_ message: PlaygroundValue) {
           guard case let .dictionary(dict) = message else { return }
           guard case let .string(commandName)? = dict["command"] else { return }
           
           let containerView = self.view as! ContainerView
           
           if commandName == "SELA" {
               guard case let .string(airportName)? = dict["airport"] else { return }
               
               for airport in airports {
                   if airport.code == airportName {
                       let coords = airport.coordinates
                       let point = CGPoint(x: CGFloat(coords.x), y: CGFloat(coords.y))
                
                       for v in containerView.geoViews {
                           v.changeCenterToCoords(point: point)
                       }
                
                       break
                   }
               }
           } else if commandName == "NEFR" {
               for v in containerView.geoViews {
                   v.nextFrame()
               }
           }
    }
    
}

let vc = PlanesVC()

PlaygroundPage.current.liveView = vc