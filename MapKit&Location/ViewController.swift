
import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.register(GooalView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(pinLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 2
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func pinLocation(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            
            let touchPoint = gestureRecognizer.location(in: self.mapView)
            let touchCoordinates = mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
            
            let alert = UIAlertController(title: "Какой тип локации предпочитаете", message: nil, preferredStyle: .alert)
            
            let actionGasStation = UIAlertAction(title: "Заправка", style: .destructive) { (alert) in
                let annotation = GoalAnnotation(coordinate: touchCoordinates, typeGoal: .gasStation, title: "Заправка")
                self.mapView.addAnnotation(annotation)
            }
            
            let actionMeeting = UIAlertAction(title: "Встреча", style: .destructive) { (alert) in
                let annotation = GoalAnnotation(coordinate: touchCoordinates, typeGoal: .meeting, title: "Встреча")
                self.mapView.addAnnotation(annotation)
            }
            
            let actionHospital = UIAlertAction(title: "Больница", style: .destructive) { (alert) in
                let annotation = GoalAnnotation(coordinate: touchCoordinates, typeGoal: .hospital, title: "Больница")
                self.mapView.addAnnotation(annotation)
            }
            
            let actionRestaurant = UIAlertAction(title: "Ресторан", style: .destructive) { (alert) in
                let annotation = GoalAnnotation(coordinate: touchCoordinates, typeGoal: .restaurant, title: "Ресторан")
                self.mapView.addAnnotation(annotation)
            }
            
            let actionTaxi = UIAlertAction(title: "Такси", style: .destructive) { (alert) in
                let annotation = GoalAnnotation(coordinate: touchCoordinates, typeGoal: .taxi, title: "Такси")
                self.mapView.addAnnotation(annotation)
            }
            
            let actionBank = UIAlertAction(title: "Банк", style: .destructive) { (alert) in
                let annotation = GoalAnnotation(coordinate: touchCoordinates, typeGoal: .bank, title: "Банк")
                self.mapView.addAnnotation(annotation)
            }
            
            let actionSculpture = UIAlertAction(title: "Достопримечательности", style: .destructive) { (alert) in
                let annotation = GoalAnnotation(coordinate: touchCoordinates, typeGoal: .sculpture, title: "Достопримечательности")
                self.mapView.addAnnotation(annotation)
            }
            
            let actionOther = UIAlertAction(title: "Другое", style: .destructive) { (alert) in
                let annotation = GoalAnnotation(coordinate: touchCoordinates, typeGoal: .other, title: "Другое")
                self.mapView.addAnnotation(annotation)
            }
            
            [actionGasStation, actionTaxi, actionBank, actionOther, actionHospital, actionSculpture, actionRestaurant, actionMeeting].forEach { alert.addAction($0) }
            
            present(alert, animated: true, completion: nil)
            
            //            let annotation = MKPointAnnotation()
            //            annotation.coordinate = touchCoordinates
            //            annotation.title = "Точка"
            //            annotation.subtitle = "Новая точка на карте"
            //
            //            mapView.addAnnotation(annotation)
        }
    }
    
    func setUpmanager() {
        locationManager.delegate = self
        // задаем точность определения геолокации
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationEnabled()
    }
    
    func checkLocationEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            setUpmanager()
            checkAuhtorization()
        } else {
            showAlerLocation(title: "У вас выключена служба геологации", message: "Хотите включить", url: URL(string: "App-Prefs:root=LOCATION_SERVICES"))
        }
    }
    
    func checkAuhtorization() {
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            break
        case .denied:
            showAlerLocation(title: "Вы запретили использование местоположения", message: "Хотите это изменить?", url: URL(string: UIApplication.openSettingsURLString))
        case .authorizedWhenInUse:
            // получаем местоположение пользователя
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        //            Родительский контроль
        case .restricted:
            break
        case .notDetermined:
            // запрашиваем разрешение пользователя на определение геолокации
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func showAlerLocation(title: String, message: String?, url: URL? ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Настройки", style: .default) { (alert) in
            if let url = url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 5000, longitudinalMeters: 5000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuhtorization()
    }
}

extension ViewController: MKMapViewDelegate {
    
    //    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    //        let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 48, height: 48)))
    //        mapsButton.setBackgroundImage(#imageLiteral(resourceName: "Map"), for: .normal)
    //
    //        let identifier = "marker"
    //        var viewMarker: MKMarkerAnnotationView
    //
    //        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
    //            dequeuedView.annotation = annotation
    //            viewMarker = dequeuedView
    //        } else {
    //
    //            viewMarker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
    //            viewMarker.canShowCallout = true
    //            viewMarker.calloutOffset = CGPoint(x: 0, y: 6)
    //            viewMarker.rightCalloutAccessoryView = mapsButton
    //        }
    //        return viewMarker
    //    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let goalAnnotation = view.annotation as? GoalAnnotation else { return }
        guard let coordinate = locationManager.location?.coordinate else { return }
        
        
        mapView.removeOverlays(mapView.overlays)
        
        let startPoint = MKPlacemark(coordinate: coordinate)
        let endPoint = MKPlacemark(coordinate: goalAnnotation.coordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startPoint)
        request.destination = MKMapItem(placemark: endPoint)
        request.transportType = .walking
        
        let direction = MKDirections(request: request)
        direction.calculate { (response, error) in
            guard let response = response else { return }
            for rote in response.routes {
                self.mapView.addOverlay(rote.polyline)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .gray
        renderer.lineWidth = 3
        
        return renderer
    }
}
