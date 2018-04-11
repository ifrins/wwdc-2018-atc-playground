//#-hidden-code

import Foundation
import UIKit
import PlaygroundSupport

let proxy = PlaygroundPage.current.liveView as! PlaygroundRemoteLiveViewProxy
var animating = false

PlaygroundPage.current.needsIndefiniteExecution = true

let timer = Timer.init(timeInterval: 1, repeats: true, block: { timer in 
    if animating {
        proxy.send(PlaygroundValue.dictionary(["command": PlaygroundValue.string("NEFR")]))
    }
})

RunLoop.current.add(timer, forMode: .defaultRunLoopMode)

func runAnimation() {
    animating = true
}

//#-end-hidden-code

/*:

ATC uses radar screens to separate planes in order to keep them safe. 

Each plane is represented as a green square. 

The first line shows the call sign of the plane –or the IATA plane code. 
They use the NATO phonetic alphabet to say the call sign when contacted over the radio. 
For example, AY 5657 is Alpha Yankee Five Six Five Seven.

The second line shows the altitude of the plane in feet (1 ft = 0.3 m) and the speed in knots (1 kt = 1.15 mph = 1.85 km/h).

Then there's a line inside the plane. It indicates tail direction. If it's going to the north, then the tail will be pointing to the south. 

What happens if there's an emergency? The green text turns into red. 

**Now you're ready to experience what Air Traffic Controllers see on their screens. For the best experience, use full screen, and explore the planes around you**.

*/

// Want to see planes moving?

runAnimation()