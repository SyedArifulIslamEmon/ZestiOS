//
//  CollectionsViewController.swift
//  MoltinSwiftExample
//
//  Created by Kelin Christi on 26/01/2016.
//  Copyright (c) 2016 Kelz All rights reserved.
//

import UIKit
import Moltin
import SwiftSpinner
import Firebase
import AZDropdownMenu


class CollectionsViewController: UIViewController{
    
    var rightMenu: AZDropdownMenu?
    
    @IBOutlet weak var tableView:UITableView?
    
    private var collections:NSArray?
    
    private let COLLECTION_CELL_REUSE_IDENTIFIER = "CollectionCell"
    
    private let PRODUCTS_LIST_SEGUE_IDENTIFIER = "productsListSegue"
    
    private var selectedCollectionDict:NSDictionary?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //AZDropdown
        let rightButton = UIBarButtonItem(image: UIImage(named: "options"), style: .Plain, target: self, action: #selector(CollectionsViewController.showRightDropdown))
        navigationItem.rightBarButtonItem = rightButton
        rightMenu = buildDummyDefaultMenu()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Locales"
        
        // Show loading UI
        SwiftSpinner.show("Loading Locales")
        
        // Get collections, async
        Moltin.sharedInstance().collection.listingWithParameters(["status": NSNumber(int: 1), "limit": NSNumber(int: 20)], success: { (response) -> Void in
            
            // We have collections - show them!
            SwiftSpinner.hide()
            
            self.collections = response["result"] as? NSArray
            
            self.tableView?.reloadData()
            
        }) { (response, error) -> Void in
            // Something went wrong; hide loading UI and display warning.
            SwiftSpinner.hide()

            AlertDialog.showAlert("Error", message: "Couldn't load Neighborhoods", viewController: self)
            print("Something went wrong...")
            print(error)
        }
        
        
    }
    
    //Dropdown function.
    func showRightDropdown() {
        if (self.rightMenu?.isDescendantOfView(self.view) == true) {
            self.rightMenu?.hideMenu()
        } else {
            self.rightMenu?.showMenuFromView(self.view)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == PRODUCTS_LIST_SEGUE_IDENTIFIER {
            // Set up products list view!
            let newViewController = segue.destinationViewController as! ProductListTableViewController
            
            newViewController.title = selectedCollectionDict!.valueForKey("title") as? String
            newViewController.collectionId = selectedCollectionDict!.valueForKeyPath("id") as? String
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Firebase Function.
    func logout() {
        // unauth() is the logout method for the current user.
        
        DataService.dataService.CURRENT_USER_REF.unauth()
        
        // Remove the user's uid from storage.
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        
        // Head back to Login!
        
        let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("Login")
        UIApplication.sharedApplication().keyWindow?.rootViewController = loginViewController
    }

}


//Table View source for CollectionsViewController
extension CollectionsViewController: UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if collections != nil {
            return collections!.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(COLLECTION_CELL_REUSE_IDENTIFIER, forIndexPath: indexPath) as! CollectionTableViewCell
        
        let row = indexPath.row
        
        let collectionDictionary = collections?.objectAtIndex(row) as! NSDictionary
        
        cell.setCollectionDictionary(collectionDictionary)
        
        
        
        return cell
    }
    
}

//TableView Delegate for CollectionsViewController
extension CollectionsViewController: UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        selectedCollectionDict = collections?.objectAtIndex(indexPath.row) as? NSDictionary
        
        performSegueWithIdentifier(PRODUCTS_LIST_SEGUE_IDENTIFIER, sender: self)
        
        
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
    
}

//This is the extension of the UIViewController. and this is the code for instantiating the dropdown menu
extension UIViewController {
    
    //Creating Menu
        private func buildDummyDefaultMenu() -> AZDropdownMenu {
            
            let leftTitles = ["Your Receipts", "Profile"]
            let menu = AZDropdownMenu(titles: leftTitles)

            menu.itemFontSize = 16.0
            menu.itemColor = UIColor.blackColor()
            menu.shouldDismissMenuOnDrag = true
            menu.menuSeparatorColor = UIColor.clearColor()
            menu.itemAlignment = .Right
            menu.itemFontColor = MOLTIN_COLOR!
            menu.itemFontName = "Helvetica"
            menu.cellTapHandler = { [weak self] (indexPath: NSIndexPath) -> Void in
                //Code for the Receipts Tab
                if indexPath.row == 0{
                    let controller = UIViewController()
                    controller.title = ("Your Receipts")
                    controller.view.backgroundColor = UIColor.whiteColor()
                    self?.navigationController!.pushViewController(controller, animated:true)
                    
                }
                //Code for the Profile Tab
                if indexPath.row == 1{
                    let controller2 = UIViewController()
                    controller2.title = ("Profile")
                    controller2.view.backgroundColor = UIColor.blackColor()
                    self?.navigationController!.pushViewController(controller2, animated:true)
                    
                    //Logout from firebase.
                    let logoutButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CollectionsViewController.logout))
                    controller2.navigationItem.rightBarButtonItem = logoutButton
                    
                }
                
            
        }
        
        return menu
    }
    

    
    func dismiss(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

