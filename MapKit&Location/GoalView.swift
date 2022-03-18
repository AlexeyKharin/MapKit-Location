
import Foundation
import MapKit

class GooalView: MKAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let goalAnnotation = newValue as? GoalAnnotation else { return }
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y:-5)
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 48, height: 48)))
            mapsButton.setBackgroundImage(#imageLiteral(resourceName: "Map"), for: .normal)
            rightCalloutAccessoryView = mapsButton
            
            image = goalAnnotation.image
        }
    }
}
