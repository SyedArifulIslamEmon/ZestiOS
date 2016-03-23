//
//  DataService.swift
//  MoltinSwiftExample
//
//  Created by Kelin Christi on 3/2/16.
//  Copyright © 2016 Moltin. All rights reserved.
//

import Foundation
import Firebase

//This class interacts with Firebase.
//Done to create a Firebase DB reference with the firebase URL.
class DataService {
    static let dataService = DataService()
    
    private var _BASE_REF = Firebase(url: "\(BASE_URL)")
    private var _USER_REF = Firebase(url: "\(BASE_URL)/users")
    
    var BASE_REF: Firebase {
        return _BASE_REF
    }
    
    var USER_REF: Firebase{
        return _USER_REF
    }
    
    var CURRENT_USER_REF: Firebase {
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        
        let currentUser = Firebase(url: "\(BASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
        
        return currentUser!
    }
    
    func createNewAccount(uid: String, user: Dictionary<String, String>) {
        
        // A User is born.
        
        //setValue is called to save data to the DB. 
        USER_REF.childByAppendingPath(uid).setValue(user)
    }
    
}
