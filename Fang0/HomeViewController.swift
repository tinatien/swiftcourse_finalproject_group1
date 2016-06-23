//
//  HomeViewController.swift
//  Fang0
//
//  Created by TinaTien on 2015/12/19.
//  Copyright © 2015年 TinaTien. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var newCollectionView: UICollectionView!
    @IBOutlet weak var hotCollectionView: UICollectionView!
    
    var newArticlesArray = []
    var hotArticlesArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newCollectionView.delegate = self
        hotCollectionView.delegate = self
        newCollectionView.dataSource = self
        hotCollectionView.dataSource = self
        
        navigationController!.navigationBar.barTintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha:1 )
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")!.imageWithRenderingMode(.AlwaysOriginal)
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")!.imageWithRenderingMode(.AlwaysOriginal)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = 200
        }
        
        if let userDefaultToken = NSUserDefaults.standardUserDefaults().objectForKey("token") {
            print("user",userDefaultToken)
        }
        
        self.getHotArticles("http://140.119.19.13:30080/articles?categorylist=[]&number=10&sort=hot")
        self.getNewArticles("http://140.119.19.13:30080/articles?categorylist=[]&number=10&sort=new")
        
        navigationController!.navigationBar.barTintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha:1 )
    }
    
    func getNewArticles(urlString: String) {
        Alamofire.request(.GET, urlString)
            .responseJSON { response in
                if let JSON = response.result.value {
                    if let dataArray :NSArray = JSON as? NSArray {
                        self.newArticlesArray = dataArray
                        self.newCollectionView.reloadData()
                    }
                }
        }
    }
    
    func getHotArticles(urlString: String) {
        Alamofire.request(.GET, urlString)
            .responseJSON { response in
                if let JSON = response.result.value {
                    if let dataArray: NSArray = JSON as? NSArray {
                        self.hotArticlesArray = dataArray
                        self.hotCollectionView.reloadData()
                    }
                }
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newArticlesArray.count
    }
    
    var newSendArticleId = [AnyObject]()
    var newSendArticleContent = [AnyObject]()
    var newSendArticleImage = [AnyObject]()
    var newSendFanspagePictureImage = [AnyObject]()
    var newSendPostDateLabel = [AnyObject]()
    var newSendFanspageNameLabel = [AnyObject]()
    
    var hotSendArticleId = [AnyObject]()
    var hotSendArticleContent = [AnyObject]()
    var hotSendArticleImage = [AnyObject]()
    var hotSendFanspagePictureImage = [AnyObject]()
    var hotSendPostDateLabel = [AnyObject]()
    var hotSendFanspageNameLabel = [AnyObject]()
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView == self.newCollectionView {
            let newCell = collectionView.dequeueReusableCellWithReuseIdentifier("newCollectionCell", forIndexPath: indexPath) as! HomeNewCollectionViewCell
            
            if let rowData: NSDictionary = self.newArticlesArray[indexPath.row] as? NSDictionary {
                
                let newArticleId = rowData["id"] as? String
                let newFanspagePicture = rowData["fanpage_picture"] as? String
                let newArticleContent = rowData["message"] as? String
                let newCreateTime = rowData["created_time"] as? String
                let newFanspageName = rowData["fanpage_name"] as? String
                let newPicture = rowData["picture"] as? String
                
                let newPictureImgURL = NSURL(string: newPicture!)!
                let newPictureImgData = NSData(contentsOfURL: newPictureImgURL)
                
                let newFanspagePictureImgURL = NSURL(string: newFanspagePicture!)!
                let newFanspagePictureImgData = NSData(contentsOfURL: newFanspagePictureImgURL)!
                newSendArticleId.append(newArticleId!)
                newSendArticleImage.append(newPictureImgData!)
                newSendFanspagePictureImage.append(newFanspagePictureImgData)
                newSendPostDateLabel.append(newCreateTime!)
                newSendFanspageNameLabel.append(newFanspageName!)
                newSendArticleContent.append(newArticleContent!)
                
                newCell.newArticleTitle.text = newArticleContent
                newCell.newImage.image = UIImage(data: newPictureImgData!)
                
            }
            return newCell
        }
        
        let hotCell =
        collectionView.dequeueReusableCellWithReuseIdentifier("hotCollectionCell", forIndexPath: indexPath) as! HomeHotCollectionViewCell
        
        if let rowData: NSDictionary = self.hotArticlesArray[indexPath.row] as? NSDictionary {
            let hotArticleId = rowData["id"] as? String
            let hotFanspagePicture = rowData["fanpage_picture"] as? String
            let hotArticleContent = rowData["message"] as? String
            let hotCreateTime = rowData["created_time"] as? String
            let hotFanspageName = rowData["fanpage_name"] as? String
            let hotPicture = rowData["picture"] as? String
            
            let hotPictureImgURL = NSURL(string: hotPicture!)!
            let hotPictureImgData = NSData(contentsOfURL: hotPictureImgURL)
            
            let hotFanspagePictureImgURL = NSURL(string: hotFanspagePicture!)!
            let hotFanspagePictureImgData = NSData(contentsOfURL: hotFanspagePictureImgURL)!
            
            hotSendArticleId.append(hotArticleId!)
            hotSendArticleImage.append(hotPictureImgData!)
            hotSendFanspagePictureImage.append(hotFanspagePictureImgData)
            hotSendPostDateLabel.append(hotCreateTime!)
            hotSendFanspageNameLabel.append(hotFanspageName!)
            hotSendArticleContent.append(hotArticleContent!)
            
            hotCell.hotArticleTitle.text = hotArticleContent
            hotCell.hotImage.image = UIImage(data: hotPictureImgData!)
        }
        
        return hotCell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showNewArticleDetail" {
            let newCell = sender as! HomeNewCollectionViewCell
            let newIndexPath = self.newCollectionView.indexPathForCell(newCell)
            let destinationController = segue.destinationViewController as! ArticleDetailViewController
            
            destinationController.acceptArticleId = self.newSendArticleId[newIndexPath!.row] as! String
            destinationController.acceptArticleContent = self.newSendArticleContent[newIndexPath!.row] as! String
            destinationController.acceptArticleImage = self.newSendArticleImage[newIndexPath!.row] as! NSData
            destinationController.acceptFanspagePictureImage = self.newSendFanspagePictureImage[newIndexPath!.row] as! NSData
            destinationController.acceptPostDateLabel = self.newSendPostDateLabel[newIndexPath!.row] as! String
            destinationController.acceptFanspageNameLabel = self.newSendFanspageNameLabel[newIndexPath!.row] as! String
        }
        
        if segue.identifier == "showHotArticleDetail"{
            let hotCell = sender as! HomeHotCollectionViewCell
            let hotIndexPath = self.hotCollectionView.indexPathForCell(hotCell)
            let destinationController = segue.destinationViewController as! ArticleDetailViewController
            
            destinationController.acceptArticleId = self.hotSendArticleId[hotIndexPath!.row] as! String
            destinationController.acceptArticleContent = self.hotSendArticleContent[hotIndexPath!.row] as! String
            destinationController.acceptArticleImage = self.hotSendArticleImage[hotIndexPath!.row] as! NSData
            destinationController.acceptFanspagePictureImage = self.hotSendFanspagePictureImage[hotIndexPath!.row] as! NSData
            destinationController.acceptPostDateLabel = self.hotSendPostDateLabel[hotIndexPath!.row] as! String
            destinationController.acceptFanspageNameLabel = self.hotSendFanspageNameLabel[hotIndexPath!.row] as! String
        }
        
    }
}
