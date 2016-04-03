//
//  LoginViewController.swift
//  MoltinSwiftExample
//
//  Created by Kelin Christi on 4/2/16.
//  Copyright © 2016 Moltin. All rights reserved.
//

import Foundation
import UIKit
import Moltin

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFields()
    }
    
    var first_name: UITextField?
    var last_name: UITextField?
    var email: UITextField?
    var registerNew = false
    
    func setTextFields() {
        first_name = UITextField(frame: CGRectMake(0, 100, 420, 30))
        first_name?.backgroundColor = MOLTIN_COLOR
        first_name!.placeholder = "First Name"
        
        last_name = UITextField(frame: CGRectMake(0, 150, 420, 30))
        last_name?.backgroundColor = MOLTIN_COLOR
        last_name!.placeholder = "Last Name"
        
        email = UITextField(frame: CGRectMake(0, 200, 420, 30))
        email?.backgroundColor = MOLTIN_COLOR
        email!.placeholder = "E-mail"
        
        let loginButton = UIButton(type: .System) as UIButton
        loginButton.frame = CGRectMake(100, 250, 100, 30)
        loginButton.backgroundColor = UIColor.greenColor()
        loginButton.setTitle("Login", forState: .Normal)
        loginButton.addTarget(self, action: #selector(LoginViewController.login), forControlEvents: .TouchUpInside)
        
        let regButton = UIButton(type: .System) as UIButton
        regButton.frame = CGRectMake(100, 250, 100, 30)
        regButton.backgroundColor = UIColor.greenColor()
        regButton.setTitle("Register", forState: .Normal)
        regButton.addTarget(self, action: #selector(LoginViewController.register), forControlEvents: .TouchUpInside)
        
        if registerNew {
            self.view.addSubview(first_name!)
            self.view.addSubview(last_name!)

            self.view.addSubview(regButton)
        } else {
            self.view.addSubview(loginButton)
        }
        self.view.addSubview(email!)
        
    }
    
    
    func login(){
        //Method to create a user.
        let params = [
            "email": email!.text!,
            "password": "Asdf1234"
        ]
        func success(incoming: [NSObject : AnyObject]!) -> Void{
            print("Success: \(incoming)");
        }
        
        func failure(incoming: [NSObject: AnyObject]!, error: NSError!) -> Void{
            print("Failure: \(incoming)");
        }
//        Moltin.sharedInstance().customer.findWithParameters(params, success: success, failure: failure)
        Moltin.sharedInstance().customer.getWithEndpoint("customers/authenticate", andParameters:params, success: success, failure: failure)
        
//        print("Login test \(email!.text)")
    }
    func register() {
        
        //Method to create a user.
        let params = [
            "first_name": first_name!.text!,
            "last_name": last_name!.text!,
            "email": email!.text!,
            "password": "Asdf1234"
        ]
        func success(incoming: [NSObject : AnyObject]!) -> Void{
            print("Success: \(incoming)");
        }
        
        func failure(incoming: [NSObject: AnyObject]!, error: NSError!) -> Void{
            print("Failure: \(incoming)");
        }
        Moltin.sharedInstance().customer.postWithEndpoint("customers", andParameters: params, success: success, failure: failure)
//        Moltin.sharedInstance().customer.createWithParameters(params, success: success, failure: failure)

    }
    
}


