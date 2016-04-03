//
//  CartViewController.swift
//  MoltinSwiftExample
//
//  Created by Kelin Christi on 26/01/2016.
//  Copyright (c) 2016 Kelz All rights reserved.
//

import UIKit
import Moltin
import SwiftSpinner

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CartTableViewCellDelegate {
    
    private let CART_CELL_REUSE_IDENTIFIER = "CartTableViewCell"
    
    @IBOutlet weak var tableView:UITableView?
    @IBOutlet weak var totalLabel:UILabel?
    @IBOutlet weak var checkoutButton:UIButton?
    
    private var cartData:NSDictionary?
    private var cartProducts:NSDictionary?

    
    private let BILLING_ADDRESS_SEGUE_IDENTIFIER = "showBillingAddress"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Cart"

        totalLabel?.text = ""
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshCart()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshCart() {
        SwiftSpinner.show("Updating cart")
        
        // Get the cart contents from Moltin API
        Moltin.sharedInstance().cart.getContentsWithsuccess({ (response) -> Void in
            // Got cart contents succesfully!
            // Set local var's
            self.cartData = response
            print(self.cartData)
            
            //The cart products
            self.cartProducts = self.cartData?.valueForKeyPath("result.contents") as? NSDictionary
            
            // Reset cart total with proper formatting
            if let cartPriceString:NSString = self.cartData?.valueForKeyPath("result.totals.post_discount.formatted.with_tax") as? NSString {
                self.totalLabel?.text = cartPriceString as String
                
            }
            
            // And reload table of cart items...
            self.tableView?.reloadData()
            
            // Hide loading UI
            SwiftSpinner.hide()
            
            // If there's < 1 product in the cart, disable the checkout button
            self.checkoutButton?.enabled = (self.cartProducts != nil && self.cartProducts?.count > 0)

            }, failure: { (response, error) -> Void in
                // Something went wrong; hide loading UI and warn user
                SwiftSpinner.hide()

                AlertDialog.showAlert("Error", message: "Couldn't load cart", viewController: self)
                print("Something went wrong...")
                print(error)
        })
        
        
        
    }
    
    // MARK: - TableView Data source & Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (cartProducts != nil) {
            return cartProducts!.allKeys.count
        }
        
        
        return 0
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CART_CELL_REUSE_IDENTIFIER, forIndexPath: indexPath) as! CartTableViewCell
        
        let row = indexPath.row
        
        let product:NSDictionary = cartProducts!.allValues[row] as! NSDictionary
        
        cell.setItemDictionary(product)
        
        cell.productId = cartProducts!.allKeys[row] as? String
        
        cell.delegate = self
        
        
        return cell
    }
    
    
    
    func tableView(_tableView: UITableView,
        willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
            
            if cell.respondsToSelector(Selector("setSeparatorInset:")) {
                cell.separatorInset = UIEdgeInsetsZero
            }
            if cell.respondsToSelector(Selector("setLayoutMargins:")) {
                cell.layoutMargins = UIEdgeInsetsZero
            }
            if cell.respondsToSelector(Selector("setPreservesSuperviewLayoutMargins:")) {
                cell.preservesSuperviewLayoutMargins = false
            }
    }
    //Swipe to delete functionality to remove items from the cart
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            // Remove the item from the cart.
            removeItemFromCartAtIndex(indexPath.row)
        }
    }
    
    private func removeItemFromCartAtIndex(index: Int) {
        // Get item ID...
        let selectedProductId = cartProducts!.allKeys[index] as? String
        
        SwiftSpinner.show("Updating cart")

        
        // And remove it from the cart...
        Moltin.sharedInstance().cart.removeItemWithId(selectedProductId, success: { (response) -> Void in
            // Completed item removal - refresh cart hide loading UI
            self.refreshCart()

            SwiftSpinner.hide()
            
            
            }, failure: { (response, error) -> Void in
                // Removal failed - hide loading UI and warn the user
                SwiftSpinner.hide()
                
                AlertDialog.showAlert("Error", message: "Couldn't update cart", viewController: self)
                print("Something went wrong...")
                print(error)
        })
    }
    
    // MARK: - Cell delegate
    func cartTableViewCellSetQuantity(cell: CartTableViewCell, quantity: Int) {
        // The cell's quantity's been updated by the stepper control - tell the Moltin API and refresh the cart too.
        // If quantity is zero, the Moltin API automagically knows to remove the item from the cart
        
        // Loading UI..
        SwiftSpinner.show("Updating quantity")
        
        // Update to new quantity value...
        Moltin.sharedInstance().cart.updateItemWithId(cell.productId!, parameters: ["quantity": quantity], success: { (response) -> Void in
            // Update succesful, refresh cart
            self.refreshCart()

            SwiftSpinner.hide()
            
            
            }, failure: { (response, error) -> Void in
                // Something went wrong; hide loading UI and warn user
                SwiftSpinner.hide()
                
                AlertDialog.showAlert("Error", message: "Couldn't update cart", viewController: self)
                print("Something went wrong...")
                print(error)
        })
        
    }
    
    // MARK: - Checkout button
    @IBAction func checkoutButtonClicked(sender: AnyObject) {
        performSegueWithIdentifier(BILLING_ADDRESS_SEGUE_IDENTIFIER, sender: self)
    }
    
}

