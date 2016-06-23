//
//  CollectionArticlesViewController.swift
//  Fang0
//
//  Created by Chun Tie Lin on 2016/4/6.
//  Copyright © 2016年 TinaTien. All rights reserved.
//

import UIKit
import Alamofire

class CollectionArticlesViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var collectionArticlesTableView: UITableView!
    
    var acceptListName: String!
    var collectionArticlesArray = [AnyObject]()
    var idArray = [[String]]()
    
    var sendArticleId = [AnyObject]()
    var sendArticleContent = [AnyObject]()
    var sendArticleImage = [AnyObject]()
    var sendFanspagePictureImage = [AnyObject]()
    var sendPostDateLabel = [AnyObject]()
    var sendFanspageNameLabel = [AnyObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.barTintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha:1 )
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")!.imageWithRenderingMode(.AlwaysOriginal)
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")!.imageWithRenderingMode(.AlwaysOriginal)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        self.collectionArticlesTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        getCollectionList("http://140.119.19.13:30080/collections/articles")
    }
    
    func getCollectionList(urlString :String){
        Alamofire.request(.GET, urlString, parameters:["token":acceptToken, "collectionname":acceptListName])
            .responseJSON { response in
                if let JSON = response.result.value {
                    self.collectionArticlesArray = JSON as! NSArray as [AnyObject]
                    self.collectionArticlesTableView.reloadData()
                }
        }
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            if let rowData:NSDictionary = self.collectionArticlesArray[indexPath.row] as! NSDictionary{
                let articleId = rowData["id"] as! String
                let parameter = ["token":acceptToken, "collectionname":acceptListName, "articleid":articleId]
                Alamofire.request(.DELETE, "http://140.119.19.13:30080/collections/articles", parameters:parameter)
            }
            self.collectionArticlesArray.removeAtIndex(indexPath.row)
            self.collectionArticlesTableView.reloadData()
            
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionArticlesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.collectionArticlesTableView.dequeueReusableCellWithIdentifier("collectionArticlesCell") as! CollectionArticlesViewCell
        
        if let rowData: NSDictionary = self.collectionArticlesArray[indexPath.row] as? NSDictionary {
            let articleId = rowData["id"] as? String
            let fanspagePicture = rowData["fanpage_picture"] as? String
            let articleContent = rowData["message"] as? String
            let createTime = rowData["created_time"] as? String
            let fanspageName = rowData["fanpage_name"] as? String
            let picture = rowData["picture"] as? String
            
            let pictureImgURL = NSURL(string: picture!)!
            let pictureImgData = NSData(contentsOfURL: pictureImgURL)
            
            let fanspagePictureImgURL = NSURL(string: fanspagePicture!)!
            let fanspagePictureImgData = NSData(contentsOfURL: fanspagePictureImgURL)!
            
            sendArticleId.append(articleId!)
            sendArticleImage.append(pictureImgData!)
            sendFanspagePictureImage.append(fanspagePictureImgData)
            sendPostDateLabel.append(createTime!)
            sendFanspageNameLabel.append(fanspageName!)
            sendArticleContent.append(articleContent!)
            
            cell.articleNameLabel.text = articleContent
            cell.articleImageView.image = UIImage(data: pictureImgData!)
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showCollectionArticleDetail"{
            if let indexPath = self.collectionArticlesTableView.indexPathForSelectedRow {
                let destinationController = segue.destinationViewController as! ArticleDetailViewController
                
                destinationController.acceptArticleId = self.sendArticleId[indexPath.row] as! String
                destinationController.acceptArticleContent = self.sendArticleContent[indexPath.row] as! String
                destinationController.acceptArticleImage = self.sendArticleImage[indexPath.row] as! NSData
                destinationController.acceptFanspagePictureImage = self.sendFanspagePictureImage[indexPath.row] as! NSData
                destinationController.acceptPostDateLabel = self.sendPostDateLabel[indexPath.row] as! String
                destinationController.acceptFanspageNameLabel = self.sendFanspageNameLabel[indexPath.row] as! String
            }
        }
    }
    
}
