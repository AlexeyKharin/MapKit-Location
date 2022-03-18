
import Foundation
import MapKit

enum TypeGoal: String {
    case gasStation
    case meeting
    case hospital
    case restaurant
    case sculpture
    case taxi
    case bank
    case other
}


class GoalAnnotation: NSObject, MKAnnotation {
    
    let title: String?
    let typeGoal: TypeGoal
    let coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D, typeGoal: TypeGoal, title: String) {
        self.title = title
        self.typeGoal = typeGoal
        self.coordinate = coordinate
        super.init()
    }
    
    var image: UIImage {
        
        switch typeGoal {
        case .bank:
            return #imageLiteral(resourceName: "Bank")
        case .gasStation:
            return #imageLiteral(resourceName: "GasStation")
        case .hospital:
            return #imageLiteral(resourceName: "Hospital")
        case .meeting:
            return #imageLiteral(resourceName: "Group")
        case .other:
            return #imageLiteral(resourceName: "Flag")
        case .restaurant:
            return #imageLiteral(resourceName: "Restaurant")
        case .sculpture:
            return #imageLiteral(resourceName: "Sculpture")
        case .taxi:
            return #imageLiteral(resourceName: "Taxi")
        }
    }
    
}
