//
//  ArticleDetailViewController.swift
//  Fang0
//
//  Created by TinaTien on 2015/12/20.
//  Copyright © 2015年 TinaTien. All rights reserved.
//

import UIKit
import Alamofire
import Social

class ArticleDetailViewController: UIViewController, UIScrollViewDelegate,UIPopoverPresentationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var collectButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var articleContent: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var fanspagePictureImage: UIImageView!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var fanspageNameLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var recommendCollectionView: UICollectionView!
    
    var acceptArticleId = String()
    var acceptArticleContent = String()
    var acceptArticleImage = NSData()
    var acceptFanspagePictureImage = NSData()
    var acceptPostDateLabel = String()
    var acceptArticleTitleLabel = String()
    var acceptFanspageNameLabel = String()
    
    let textView = UIView()
    let textLabel = UILabel()
    
    var recommendArticlesArray = []
    var pickerItemArray = []
    var listname :String!
    var userInput :UITextField!
    var isPickerViewHidden = true
    var isTextViewHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //設定navigationbar
        navigationController!.navigationBar.barTintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha:1 )
        
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")!.imageWithRenderingMode(.AlwaysOriginal)
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")!.imageWithRenderingMode(.AlwaysOriginal)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        if let userDefaultToken = NSUserDefaults.standardUserDefaults().valueForKey("token") {
            self.getCollectionList("http://140.119.19.13:30080/collections")
            self.pickerView.delegate = self
            self.pickerView.dataSource = self
        }
        
        self.getRecommendArticles("http://140.119.19.13:30080/recommendations")
        
        self.pickerView.hidden = true
        
        self.articleContent.text = acceptArticleContent
        self.articleImage.image = UIImage(data: acceptArticleImage)
        self.fanspagePictureImage.image = UIImage(data: acceptFanspagePictureImage)
        self.postDateLabel.text = acceptPostDateLabel
        self.fanspageNameLabel.text = acceptFanspageNameLabel
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Load the pages that are now on screen
    }
    
    func getCollectionList(urlString :String){
        if let token = NSUserDefaults.standardUserDefaults().valueForKey("token") {
            Alamofire.request(.GET, urlString, parameters: ["token": token])
                .responseJSON { response in
                    if let JSON = response.result.value {
                        if let dataArray :NSArray = JSON as? NSArray {
                            self.pickerItemArray = dataArray
                            self.pickerView.reloadAllComponents()
                        } else {
                            self.pickerItemArray = []
                        }
                    }
            }
        }
    }
    
    func getRecommendArticles(urlString :String) {
        Alamofire.request(.GET, urlString,parameters: ["articleid":acceptArticleId])
            .responseJSON { response in
                if let JSON = response.result.value {
                    if let dataArray: NSArray = JSON as? NSArray {
                        self.recommendArticlesArray = dataArray
                        self.recommendCollectionView.reloadData()
                    }
                }
        }
    }
    
    @IBAction func shareToFacebook(sender: AnyObject) {
        let shareToFacebook : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        shareToFacebook.setInitialText(self.articleContent.text)
        shareToFacebook.addImage(self.articleImage.image)
        self.presentViewController(shareToFacebook, animated: true, completion: nil)
    }
    
    @IBAction func addButtonTouched(sender: AnyObject) {
        if let token = NSUserDefaults.standardUserDefaults().valueForKey("token") {
            let alertController = UIAlertController(title: "New Collection", message: "Enter collection name", preferredStyle: .Alert)
            
            let confirmAction = UIAlertAction(title: "Confirm", style: .Default) { (_) in
                if let field = alertController.textFields![0] as? UITextField {
                    self.userInput = field
                    let parameters = [
                        "token" :token,
                        "collectionname" : self.userInput.text!
                    ]
                    Alamofire.request(.POST, "http://140.119.19.13:30080/collections", parameters: parameters)
                    self.runAfterDelay(0.2) {
                        self.getCollectionList("http://140.119.19.13:30080/collections")
                    }
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
        } else {
            let next = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            self.presentViewController(next, animated: true, completion: nil)
        }
    }
    
    func runAfterDelay(delay: NSTimeInterval, block: dispatch_block_t) {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), block)
    }
    
    @IBAction func collectionButtonTouched(sender: AnyObject) {
        
        if let token = NSUserDefaults.standardUserDefaults().valueForKey("token") {
            getCollectionList("http://140.119.19.13:30080/collections")
        } else {
            let next = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            self.presentViewController(next, animated: true, completion: nil)
        }
        
        if self.pickerItemArray != [] {
            if isPickerViewHidden {
                pickerView.hidden = false
                isPickerViewHidden = false
            } else {
                pickerView.hidden = true
                isPickerViewHidden = true
            }
        } else {
            let alertController = UIAlertController(title: "Reminder", message: "There isn't any collection in your account", preferredStyle: .Alert)
            let confirmlAction = UIAlertAction(title: "Comfirm", style: .Default) { (_) in}
            
            alertController.addAction(confirmlAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerItemArray.count
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let rowData: NSDictionary = (self.pickerItemArray[row] as? NSDictionary)!
        listname = rowData["collectionname"] as? String
        let pickerViewTitle = NSAttributedString(string: listname, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
        return pickerViewTitle
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let rowData: NSDictionary = self.pickerItemArray[row] as? NSDictionary {
            listname = rowData["collectionname"] as? String
        }
        
        if let token = NSUserDefaults.standardUserDefaults().valueForKey("token") {
            let parameters = [
                "token" :token,
                "collectionname" : listname,
                "articleid" : acceptArticleId
            ]
            Alamofire.request(.POST, "http://140.119.19.13:30080/collections/articles", parameters: parameters)
            pickerView.hidden = true
        }
    }
    
    
    func configurationTextField (textField :UITextField!) {
        textField.placeholder = "Enter collection name"
        userInput = textField
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recommendArticlesArray.count
    }
    
    var sendArticleId = [AnyObject]()
    var sendArticleContent = [AnyObject]()
    var sendArticleImage = [AnyObject]()
    var sendFanspagePictureImage = [AnyObject]()
    var sendPostDateLabel = [AnyObject]()
    var sendFanspageNameLabel = [AnyObject]()
    
    var articleId :String?
    var picture :String?
    var pictureImgURL :NSURL?
    var defaultImgURL :NSURL?
    var defaultImgData :NSData?
    var pictureImgData :NSData?
    var message :String?
    var fanspagePicture :String?
    var fanspagePictureImgURL :NSURL?
    var fanspagePictureImgData :NSData?
    var createTime :String?
    var fanspageName :String?
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("recommendCell", forIndexPath: indexPath) as! RecommendCollectionViewCell
        
        if let rowData: NSDictionary = self.recommendArticlesArray[indexPath.item] as? NSDictionary {
            articleId = rowData["id"] as? String
            
            picture = rowData["picture"] as? String
            pictureImgURL = NSURL(string: picture!)
            pictureImgData = NSData(contentsOfURL: pictureImgURL!)
            
            message = rowData["message"] as! String
            
            fanspagePicture = rowData["fanpage_picture"] as? String
            fanspagePictureImgURL = NSURL(string: fanspagePicture!)
            fanspagePictureImgData = NSData(contentsOfURL: fanspagePictureImgURL!)
            
            createTime = rowData["created_time"] as? String
            
            fanspageName = rowData["fanpage_name"] as? String
            
            sendArticleContent.append(message!)
            sendArticleId.append(articleId!)
            sendArticleImage.append(pictureImgData!)
            sendFanspagePictureImage.append(fanspagePictureImgData!)
            sendPostDateLabel.append(createTime!)
            sendFanspageNameLabel.append(fanspageName!)
        }
        cell.imageView.image = UIImage(data: pictureImgData!)
        cell.nameLabel.text = message
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRecommendArticle" {
            let cell = sender as! RecommendCollectionViewCell
            let indexPath = self.recommendCollectionView.indexPathForCell(cell)
            
            let destinationController = segue.destinationViewController as! ArticleDetailViewController
            
            destinationController.acceptArticleId = self.sendArticleId[indexPath!.row] as! String
            destinationController.acceptArticleContent = self.sendArticleContent[indexPath!.row] as! String
            destinationController.acceptArticleImage = self.sendArticleImage[indexPath!.row] as! NSData
            destinationController.acceptFanspagePictureImage = self.sendFanspagePictureImage[indexPath!.row] as! NSData
            destinationController.acceptPostDateLabel = self.sendPostDateLabel[indexPath!.row] as! String
            destinationController.acceptFanspageNameLabel = self.sendFanspageNameLabel[indexPath!.row] as! String
        }
    }
}

