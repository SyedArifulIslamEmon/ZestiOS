//
//  AlertDialog.swift
//  MoltinSwiftExample
//
//  Created by Kelin Christi on 26/01/2016.
//  Copyright (c) 2016 Kelz All rights reserved.
//

import Foundation
import UIKit

// A simple convenience class to present alerts, to avoid lots of UIAlertController code duplication.
class AlertDialog {
    
    class func showAlert(title: String, message: String, viewController: UIViewController) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alertController.addAction(dismissAction)
        
        viewController.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
}