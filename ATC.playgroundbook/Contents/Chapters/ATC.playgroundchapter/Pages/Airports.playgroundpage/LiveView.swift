import Foundation
import UIKit
import PlaygroundSupport

class AirportsVC : UIViewController, PlaygroundLiveViewMessageHandler {
    let airports = AirportDataLoader.loadAirportData()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let innerFrame = self.view.frame
        
        let mapView = GeoMapView(frame: innerFrame)
        let airportView = AirportMapView(frame: innerFrame, airportData: airports)
                
        let containerView = ContainerView(frame: innerFrame)
        self.view = containerView
        
        containerView.addView(mapView)
        containerView.addView(airportView)        
    }    
}

let vc = AirportsVC()

PlaygroundPage.current.liveView = vc
