//
//  ProductDetailViewController.swift
//  MoltinSwiftExample
//
//  Created by Kelin Christi on 26/01/2016.
//  Copyright (c) 2016 Kelz All rights reserved.
//

import UIKit
import Moltin
import SwiftSpinner
import MapKit
import CoreLocation
import AddressBookUI
import UberRides

class ProductDetailViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var productDict:NSDictionary?
    
    @IBOutlet weak var productImageView:UIImageView?
    
    @IBOutlet weak var restLabel: UILabel!
    
    @IBOutlet weak var buyButton:UIButton?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var qtyLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var coordinate: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //The following setup is for setting up the bar button to Checkout
        let checkoutButton = UIBarButtonItem(title: "Express", style: UIBarButtonItemStyle.Plain, target: self, action: "checkout")
        self.navigationItem.rightBarButtonItem = checkoutButton
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
        
        buyButton?.backgroundColor = MOLTIN_COLOR

        // Do any additional setup after loading the view.
        if let description = productDict!.valueForKey("description") as? String {
            self.titleLabel?.text = description
            //print (productDict)

        }
        
        if let restname =
            productDict!.valueForKey("rstrnt") as? String {
                self.restLabel?.text = restname
        }
        
        if let phone =
            productDict!.valueForKey("phonenumber") as? String {
                self.phoneLabel?.text = phone
        }
        
        if let address = productDict!.valueForKey("address")as? String {
            self.addressLabel?.text = address
            
            func forwardGeocoding(address: String) {
                CLGeocoder().geocodeAddressString(address , completionHandler: { (placemarks, error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    //Here, we check how many placemarks are found pertaining to the input above.
                    //If there are placemarks, we get all the information about the first one.
                    //I then printed the lats and longs to see if I was getting right results.
                    if placemarks?.count > 0 {
                        let placemark = placemarks?[0]
                        let location = placemark?.location
                        self.coordinate = location?.coordinate
//                        print("lat: \(self.coordinate!.latitude), long: \(self.coordinate!.longitude)")
                        
                        //Declared a constant that is able to leverage the CLLocationCoordinate2D to get the latitude and longitude co-ordinates
                        //Declared another constant that instantiated the MKPointAnnotation that is responsible for the pin
//                        let dest : CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.coordinate!.latitude, self.coordinate!.longitude)
                        
                        
                        //////////////////////////
                        //////////////////////////
                        // 1.
                        self.mapView.delegate = self
                        
                        // 2.
                        let destinationLocation = CLLocationCoordinate2D(latitude: self.coordinate!.latitude, longitude: self.coordinate.longitude)
//                        let sourceLocation = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
//                        print("latitude: \(location!.coordinate.latitude), longitude: \(location!.coordinate.longitude)")
//                        let sourceLocation = CLLocationCoordinate2D(latitude: 47.619493, longitude: -122.196260)
                        
                        // 3.
//                        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
                        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
                        
                        // 4.
//                        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
                        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
                        
                        // 7.
                        let directionRequest = MKDirectionsRequest()
                        directionRequest.source = MKMapItem.mapItemForCurrentLocation()
                        directionRequest.destination = destinationMapItem
                        directionRequest.transportType = .Automobile
                        
                        // Calculate the direction
                        let directions = MKDirections(request: directionRequest)
                        
                        // 8.
                        directions.calculateDirectionsWithCompletionHandler {
                            (response, error) -> Void in
                            
                            guard let response = response else {
                                if let error = error {
                                    print("Error: \(error)")
                                }
                                
                                return
                            }
                            
                            let route = response.routes[0]
                            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.AboveRoads)
                            
                            let rect = route.polyline.boundingMapRect
                            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
                        }
                        
                        
                        let restaurantPin = MKPointAnnotation()
                        restaurantPin.coordinate = destinationLocation
                        self.mapView.addAnnotation(restaurantPin)
                        
                        // Do any additional setup after loading the view, typically from a nib.
                    }
                    
                })
                
            }
            
            //Address to co-ordinates
            forwardGeocoding(address)
        }
    
    
        if let availability = productDict!.valueForKey("stock_level") as? Int{
            self.qtyLabel?.text = "\(availability)"
        }

        if let price = productDict!.valueForKeyPath("price.data.formatted.with_tax") as? String {
            let buyButtonTitle = String(format: "Add to Cart %@", price)
            self.buyButton?.setTitle(buyButtonTitle, forState: UIControlState.Normal)
        }
        
        
        var imageUrl = ""
        
        if let images = productDict!.objectForKey("images") as? NSArray {
            if (images.firstObject != nil) {
                imageUrl = images.firstObject?.valueForKeyPath("url.https") as! String
            }
            
        }
        
        productImageView?.sd_setImageWithURL(NSURL(string: imageUrl))
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buyProduct(sender: AnyObject) {
        // Add the current product to the cart
        let productId:String = productDict!.objectForKey("id") as! String
        
        SwiftSpinner.show("Updating cart")
        
        Moltin.sharedInstance().cart.insertItemWithId(productId, quantity: 1, andModifiersOrNil: nil, success: { (response) -> Void in
            // Done.
            
            //Adds Item to the cart
            let alert = UIAlertController(title: "Added Item to Cart", message: "Grazie!",  preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title:"Sweeeet!", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion:nil )
            
            
            ////////////////////
      //////Switch to cart...////////////
            ////////////////////
//            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//            appDelegate.switchToCartTab()
      ///////////////////////////////////////
            // and hide loading UI
            SwiftSpinner.hide()
            
            
        }) { (response, error) -> Void in
            // Something went wrong.
            // Hide loading UI and display an error to the user.
            SwiftSpinner.hide()
            
            AlertDialog.showAlert("Error", message: "Couldn't add product to the cart", viewController: self)
            print("Something went wrong...")
            print(error)
        }
        
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = MOLTIN_COLOR
        renderer.lineWidth = 2.0
        
        return renderer
    }
    
    
    func checkout() {
        
        //Create the order data(hard coded for now)
        let orderParameters = [
            "customer": ["first_name": "Kelin",
                "last_name":  "Christi",
                "email":      "kelin@kelin.com"],
                "shipping": "free_shipping",
                "gateway": "stripe",
            "bill_to": ["first_name": "Generic",
                "last_name":  "Generic",
                "address_1":  "Generic",
                "address_2":  "Generic",
                "city":       "Generic",
                "county":     "Generic",
                "country":    "US",
                "postcode":   "Generic",
                "phone":     "Generic"],
            ] as [NSObject: AnyObject]
        
        
        //Create an order
        Moltin.sharedInstance().cart.orderWithParameters(orderParameters, success: {(responseDictionary) -> Void in
            
            //Get the Order ID
            let orderId = (responseDictionary as NSDictionary).valueForKeyPath("result.id") as? String
            
            if let oid = orderId {
                //Hard coded credit card data
                let paymentParameters = ["data": [
                    "gateway": "stripe",
                    "number": "4242424242424242",
                    "expiry_month": "02",
                    "expiry_year": "2018",
                    "cvv": "123"
                    ]] as [NSObject: AnyObject]
                
                //processing the payment
                Moltin.sharedInstance().checkout.paymentWithMethod("purchase", order: oid, parameters: paymentParameters, success: { (responseDictionary) -> Void in
                    
                    
                    //Display a message to the user that checkout is successfull
                    let alert = UIAlertController(title: "Order Completed", message: "Enjoy your meal!",  preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alert.addAction(UIAlertAction(title:"I Sure Will!", style: UIAlertActionStyle.Default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Ride Here With Uber", style: UIAlertActionStyle.Default , handler: nil))
                    
                    let button = RequestButton()
                    
                    let controller = UIViewController()
                    controller.view.addSubview(button)
                    
                    alert.addChildViewController(controller)
                    
                    self.presentViewController(alert, animated: true, completion:nil )
                    
                    }, failure: {(responseDictionary, error) -> Void in
                        
                        print("Could not process the payment")
                })
            }
            
            }) { (responseDictionary, error) -> Void in
                
                //Display a messeage that shows checkout was unsuccessfull
                let alert = UIAlertController(title: "Order Failed", message: "Your cart is empty!", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion:nil)
                
                print("Order creation Failed")
        }
    }

}

