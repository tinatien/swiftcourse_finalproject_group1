//
//  ArticleTableViewController.swift
//  Fang0
//
//  Created by TinaTien on 2015/12/20.
//  Copyright © 2015年 TinaTien. All rights reserved.
//

import UIKit
import Alamofire

class ArticleTableViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var acceptIndex = Int()
    var articleDataArray = []
    var begin = 30
    let refreshController: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //設定sidebar
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = 200
            
        }
        
        //設定navigationbar顏色
        navigationController!.navigationBar.barTintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha:1 )
        
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")!.imageWithRenderingMode(.AlwaysOriginal)
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")!.imageWithRenderingMode(.AlwaysOriginal)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        refreshController.addTarget(self, action: "uiRefreshControlAction", forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshController)
        
        getArticlesData("http://140.119.19.13:30080/articles?categorylist=[\(acceptIndex)]")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getArticlesData(urlString :String){
        let parameter = ["begin":String(begin)]
        Alamofire.request(.GET, urlString, parameters: parameter).responseJSON { response in
            if let JSON = response.result.value {
                self.articleDataArray = JSON as! NSArray
                self.tableView.reloadData()
            }
        }
    }
    
    func uiRefreshControlAction() {
        begin -= 2
        self.getArticlesData("http://140.119.19.13:30080/articles?categorylist=[\(acceptIndex)]")
        self.tableView.reloadData()
        refreshController.endRefreshing()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return articleDataArray.count
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
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let rowData: NSDictionary = self.articleDataArray[indexPath.row] as? NSDictionary {
            articleId = rowData["id"] as? String
            
            picture = rowData["picture"] as? String
            pictureImgURL = NSURL(string: picture!)!
            pictureImgData = NSData(contentsOfURL: pictureImgURL!)
            
            message = rowData["message"] as? String
            
            fanspagePicture = rowData["fanpage_picture"] as? String
            fanspagePictureImgURL = NSURL(string: fanspagePicture!)!
            fanspagePictureImgData = NSData(contentsOfURL: fanspagePictureImgURL!)!
            
            createTime = rowData["created_time"] as? String
            
            fanspageName = rowData["fanpage_name"] as? String
            
            sendArticleContent.append(message!)
            sendArticleId.append(articleId!)
            sendArticleImage.append(pictureImgData!)
            sendFanspagePictureImage.append(fanspagePictureImgData!)
            sendPostDateLabel.append(createTime!)
            sendFanspageNameLabel.append(fanspageName!)
            
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("articleCell", forIndexPath: indexPath) as! ArticleTableViewCell
        
        cell.articleImage.image = UIImage(data: pictureImgData!)
        cell.articleContent.text = message
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showArticleDetail"{
            if let indexPath = self.tableView.indexPathForSelectedRow {
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
