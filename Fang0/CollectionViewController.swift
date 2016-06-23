//
//  CollectionViewController.swift
//  Fang0
//
//  Created by TinaTien on 2015/12/19.
//  Copyright © 2015年 TinaTien. All rights reserved.
//

import UIKit
import Alamofire

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var addListButton: UIBarButtonItem!
    @IBOutlet weak var editListBatton: UIBarButtonItem!
    @IBOutlet weak var collectionVIew: UICollectionView!
    
    let textView: UIView = UIView()
    let textLabel: UILabel = UILabel()
    var userInput: UITextField!
    
    var collectionListArray = [AnyObject]()
    var listname :String?
    var sendListName: String?
    var collectionImageData = ["collection1-1","collection2-1","collection3-1","collection4-1","collection5-1","collection6-1","collection7-1","collection8-1","collection9-1","collection10-1","collection11-1","collection12-1","collection13-1","collection14-1","collection15-1","collection16-1","collection17-1","collection18-1","collection19-1","collection20-1"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = 200
            
            navigationController!.navigationBar.barTintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha:1 )
            self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")!.imageWithRenderingMode(.AlwaysOriginal)
            self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")!.imageWithRenderingMode(.AlwaysOriginal)
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:",name:"load", object: nil)
            
            
            if let userDefaultToken = NSUserDefaults.standardUserDefaults().valueForKey("token") {
                self.getCollectionList("http://140.119.19.13:30080/collections")
                print("get accessToken")
            } else {
                let next = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                self.presentViewController(next, animated: true, completion: nil)
                print("don't get accessToken")
            }
        }
    }
    
    @IBOutlet weak var nodataImage: UIImageView!
    @IBOutlet weak var nodataLabel: UILabel!
    @IBOutlet weak var nodataView: UIView!
    
    func getCollectionList(urlString :String){
        
        let token = NSUserDefaults.standardUserDefaults().valueForKey("token")
        
        Alamofire.request(.GET, urlString, parameters: ["token":token!])
            .responseJSON { response in
                if let JSON = response.result.value {
                    if let dataArray :NSArray = JSON as? NSArray {
                        self.collectionListArray = dataArray as [AnyObject]
                        self.nodataView.hidden = true
                        self.collectionVIew.reloadData()
                        print("has data")
                    } else {
                        self.collectionListArray = []
                        self.view.addSubview(self.nodataView)
                        self.nodataView.addSubview(self.nodataImage)
                        self.nodataView.addSubview(self.nodataLabel)
                        self.nodataView.hidden = false
                        print("no data")
                    }
                }
        }
    }
    
    @IBAction func editButtonTouched(sender: AnyObject) {
        if self.editListBatton.title == "Edit" {
            self.editListBatton.title = "Done"
            
            for item in self.collectionVIew.visibleCells() {
                let indexPath :NSIndexPath = self.collectionVIew.indexPathForCell(item)!
                let cell = self.collectionVIew.cellForItemAtIndexPath(indexPath) as! CollectionViewCell
                cell.deleteButton.hidden = false
            }
        } else {
            self.editListBatton.title = "Edit"
            self.getCollectionList("http://140.119.19.13:30080/collections")
            if collectionListArray.count == 0 {
                self.collectionVIew.reloadData()
                self.nodataView.hidden = false
            }
        }
    }
    
    func runAfterDelay(delay: NSTimeInterval, block: dispatch_block_t) {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), block)
    }
    
    @IBAction func addListButtonTouched(sender: AnyObject) {
        let token = NSUserDefaults.standardUserDefaults().valueForKey("token")
        
        let alertController = UIAlertController(title: "New Collection", message: "Enter collection name", preferredStyle: .Alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .Default) { (_) in
            if let field = alertController.textFields![0] as? UITextField {
                self.userInput = field
                
                let parameters = [
                    "token" :token!,
                    "collectionname" : self.userInput.text!
                ]
                
                Alamofire.request(.POST, "http://140.119.19.13:30080/collections", parameters: parameters)
                self.runAfterDelay(0.2) {
                    self.getCollectionList("http://140.119.19.13:30080/collections")
                }
                self.collectionVIew.reloadData()
            } else {
                // user did not fill field
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Collection Name"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func configurationTextField (textField :UITextField!) {
        textField.placeholder = "Enter collection name"
        userInput = textField
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionListArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Collection Cell", forIndexPath: indexPath) as! CollectionViewCell
        
        if let rowData: NSDictionary = self.collectionListArray[indexPath.row] as? NSDictionary {
            let name = rowData["collectionname"] as! String
            cell.listnameLabel.text = name
        }
        cell.collectionImage.image = UIImage(named: collectionImageData[indexPath.row])
        cell.deleteButton.layer.setValue(indexPath.row, forKey: "index")
        cell.deleteButton.addTarget(self, action: "deleteCell:", forControlEvents: UIControlEvents.TouchUpInside)
        
        if self.editListBatton.title == "Edit" {
            cell.deleteButton.hidden = true
        } else {
            cell.deleteButton.hidden = false
        }
        return cell
    }
    
    var deleteName: String!
    
    func deleteCell(sender: UIButton) {
        let token = NSUserDefaults.standardUserDefaults().valueForKey("token")
        let i = sender.layer.valueForKey("index") as! Int
        
        if let rowData: NSDictionary = self.collectionListArray[i] as? NSDictionary {
            deleteName = rowData["collectionname"] as! String
        }
        
        let parameter = ["token":token!, "collectionname":deleteName]
        Alamofire.request(.DELETE, "http://140.119.19.13:30080/collections", parameters:parameter)
        collectionListArray.removeAtIndex(i)
        self.collectionVIew.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showCollectionArticles" {
            let destinationVC = segue.destinationViewController as! CollectionArticlesViewController
            let cell = sender as! CollectionViewCell
            let indexPath = self.collectionVIew.indexPathForCell(cell)
            
            if let rowData: NSDictionary = self.collectionListArray[(indexPath?.row)!] as? NSDictionary {
                sendListName = rowData["collectionname"] as? String
            }
            destinationVC.acceptListName = sendListName
        }
    }
}
