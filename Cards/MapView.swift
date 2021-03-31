//
//  MapView.swift
//  Cards
//
//  Created by Linda Zungu on 2021/03/24.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var nameOfBank : String
    
    let locationManager = CLLocationManager()
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.showsUserLocation = true
//        uiView.userTrackingMode = .followWithHeading
        
        let status = CLLocationManager()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if status.authorizationStatus == .authorizedAlways || status.authorizationStatus == .authorizedWhenInUse {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            let location: CLLocationCoordinate2D = locationManager.location!.coordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
            let region = MKCoordinateRegion(center: location, span: span)
            uiView.setRegion(region, animated: true)
            
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = nameOfBank
//            searchRequest.region = uiView.regionThatFits(MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 1.00, longitudeDelta: 1.00)))
            searchRequest.region.center = uiView.region.center
            let search = MKLocalSearch(request: searchRequest)
            search.start { response, error in
                guard let response = response else{
                    print("Error: \(error?.localizedDescription ?? "Unknown error").")
                    return
                }
                
                for item in response.mapItems{
                    let place = MKPointAnnotation()
                    place.title = searchRequest.naturalLanguageQuery
                    place.coordinate = item.placemark.coordinate
                    uiView.addAnnotation(place)
                }
            }
        }
        
//        let searchRequest = MKLocalSearch.Request()
//        searchRequest.naturalLanguageQuery = "Standard Bank"
//        searchRequest.region = uiView.regionThatFits(.init(center: locationManager.location?.coordinate ?? (CLLocationCoordinate2D(latitude: -34.0999, longitude: 18.4241)), span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)))
//        let search = MKLocalSearch(request: searchRequest)
//        search.start { response, error in
//            guard let response = response else {
//                print("Error: \(error?.localizedDescription ?? "Unknown error").")
//                return
//            }
//
//            for item in response.mapItems {
//                print(item.placemark.coordinate)
//                let london = MKPointAnnotation()
//                london.title = searchRequest.naturalLanguageQuery
//                london.coordinate = item.placemark.coordinate
//                uiView.addAnnotation(london)
//
//            }
//        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(nameOfBank: "Standard Bank")
    }
}
