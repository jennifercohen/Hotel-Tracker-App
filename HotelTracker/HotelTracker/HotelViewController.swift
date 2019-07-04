//
//  HotelViewController.swift
//  HotelTracker
//
//  Created by Jennifer Cohen on 21/06/2019.
//  Copyright © 2019 Jennifer Cohen. All rights reserved.
//

import UIKit
import os.log
import MapKit

class HotelViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoimageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var descriptionBox: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addLocation: UIButton!
    

    let locationManager = CLLocationManager()
    
    //Value passed by "HotelTableViewController" or constructed as part of adding new hotel
    var hotel: Hotel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        //Handle the text field's user input through delegate callbacks
        nameTextField.delegate = self
        descriptionBox.delegate = self

        
        //Set up views if editing an existing Hotel
        if let hotel = hotel {
            navigationItem.title = hotel.name
            nameTextField.text = hotel.name
            photoimageView.image = hotel.photo
            ratingControl.rating = hotel.rating
            descriptionBox.text = hotel.comment
            if let coordinate = hotel.coordinate {
                addMapPin(coordinate: coordinate)
            }
        }
      
        //Enable Save button only if the text field has a valid Hotel name
        updateSaveButtonState()

     mapView.delegate = self
        
    }
    
    
    @IBAction func addLocationTap(_ sender: Any) {
        let coordinate = mapView.centerCoordinate
        addMapPin(coordinate: coordinate)
    }
    
    private func addMapPin(coordinate: CLLocationCoordinate2D) {
        mapView.removeAnnotations(mapView.annotations)
        
        mapView.addAnnotation(Place(
            title: nameTextField.text ?? "",
            locationName: "",
            coordinate: coordinate,
            rating: ratingControl.rating
        ))
    }
    
    
    //MARK: UITextFieldDelegate
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //MARK: Disable the Save button while editing
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
   
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = nameTextField.text
    }
    
    func locationAddedToMap(_ :UIButton) {
        updateSaveButtonState()
    }


    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //MARK: The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        //MARK: Set photoImageView to display the selected image.
        photoimageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddHotelMode = presentingViewController is UINavigationController
        
        if isPresentingInAddHotelMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The HotelViewController is not inside a navigation controller.")
        }
    }
    
    //MARK: This method lets you configure a view controller before it's presented
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        //configure destination view controller only when the save button is pressed
        guard let button = sender as? UIBarButtonItem, button === saveButton
            else {
                os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
                return
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoimageView.image
        let rating = ratingControl.rating
        let comment = descriptionBox.text ?? ""
        let coordinate = CLLocationCoordinate2D()
        //Set the hotel to be passed to HotelTableViewController after the unwind segue
        hotel = Hotel(name: name, photo: photo, rating: rating, comment: comment, coordinate: coordinate)
        
    }
    
    // MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        //MARK: Hide the keyboard.
        nameTextField.resignFirstResponder()
        
        //MARK: UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        //MARK: Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        //MARK: Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        //Disable Save button if text field empty
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
}
extension HotelViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
//            locationManager.startUpdatingLocation()
        }
    }
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")

    }
}

extension HotelViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard let annotation = annotation as? Place else { return nil }

        let identifier = "marker"
        var view: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        view.markerTintColor = annotation.markerTintColor

        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Place
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}
