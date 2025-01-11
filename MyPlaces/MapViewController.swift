//
//  MapViewController.swift
//  MyPlaces
//
//  Created by Visarg on 09.12.2024.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    var place = Place()
    let annotationIdentifier = "annotationIdentifier"
    let locationManager = CLLocationManager()
    let regionInMeters = 10_000.00
    var incomeSegueIdentifier = ""
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapPinImage: UIImageView!
    @IBOutlet weak var adressLabel: UILabel!
    
    @IBOutlet weak var doneButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        mapView.delegate = self
        checkLocationServices ()
    }
    
    @IBAction func doneButtonPeressed(_ sender: Any) {
    }
    
    @IBAction func centerViewInUserLocation() {
        showUserLocation()
       
    }
    
    @IBAction func closeVC() {
        
        dismiss(animated: true)
    }
    
    
    private func setupMapView() {
        if incomeSegueIdentifier == "showPlace" {
            setupPlacemark()
            mapPinImage.isHidden = true
            adressLabel.isHidden = true
            doneButton.isHidden = true
        }
    }
    
    private func setupPlacemark() {
        
        guard let location = place.location else {return}
        let gecoder = CLGeocoder()
        gecoder.geocodeAddressString(location){ (placemarks, error) in
            if let error = error {
                print (error)
                return
            }
            guard let placemarks = placemarks else {return}
            
            let placemark = placemarks.first
            let annotation = MKPointAnnotation()
            annotation.title = self.place.name
            annotation.subtitle = self.place.type
            guard let placemarkLocation = placemark?.location else { return }
            annotation.coordinate = placemarkLocation.coordinate
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
            
        }
        
    }
    
    private func checkLocationServices () {
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager ()
            checkLocationAuthorization ()
        } else {
            // вызывается алерт контролер с инструкицей как влюкичит эти службы
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(
                    title: "Службы определения местоположения отключены",
                    message: "Чтобы включить его, перейдите: Настройки → Конфиденциальность → Службы определения местоположения и включите"
                )
            }
        }
    }
    
   private func setupLocationManager () {
       locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkLocationAuthorization() {
       
        switch locationManager.authorizationStatus  {
        case .authorizedWhenInUse, .authorizedAlways:
            mapView.showsUserLocation = true
            if incomeSegueIdentifier == "getAdress" { showUserLocation () }
        case .denied:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(
                    title: "Ваше местоположение недоступно",
                    message: "Чтобы предоставить разрешение, перейдите в: Настройки → Мои места → Местоположение"
                )
            }
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Доступ к местоположению ограничен.")
        @unknown default:
            print("Новый неизвестный статус.")
        }
    }
    
    private func showUserLocation() {
        if let location = locationManager.location?.coordinate{
        let region = MKCoordinateRegion(center: location,
                                        latitudinalMeters: regionInMeters,
                                        longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    
    }
    

    
    
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }

}

extension MapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
        annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        annotationView?.canShowCallout = true
        }
        
        if let imageData = place.imageData {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: imageData)
            annotationView?.rightCalloutAccessoryView = imageView
        }
        
        
        
        return annotationView
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }

}
