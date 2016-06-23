//
//  SearchViewController.swift
//  Fang0
//
//  Created by Chun Tie Lin on 2015/12/22.
//  Copyright © 2015年 TinaTien. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!{
        didSet{
            self.loadingIndicator.hidden = true
        }
    }
    
    var searchResultArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")!.imageWithRenderingMode(.AlwaysOriginal)
        
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")!.imageWithRenderingMode(.AlwaysOriginal)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        searchBar.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getArticlesData(urlString :String){
        
        Alamofire.request(.GET, urlString).responseJSON { response in
            if let JSON = response.result.value {
                print(response.result.value)
                self.searchResultArray = JSON as! NSArray
                self.tableView.reloadData()
                
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.hidden = true
            }
            
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let input = searchBar.text as String!
        
        if input != nil{
            self.loadingIndicator.hidden = false
            self.loadingIndicator.startAnimating()
            getArticlesData("http://140.119.19.13:30080/articles/search?q=\(input)&auth=soslab2015")
        }else{
            print("no~~~~~")
        }
    }
    
    
    // MARK: - Table
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultArray.count
    }
    
    var sendArticleContent = [AnyObject]()
    var sendArticleImage = [AnyObject]()
    var sendFanspagePictureImage = [AnyObject]()
    var sendPostDateLabel = [AnyObject]()
    var sendArticleTitleLabel = [AnyObject]()
    var sendFanspageNameLabel = [AnyObject]()
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchResultCell", forIndexPath: indexPath) as! SearchTableViewCell
        if self.searchResultArray != []{
            if let rowData: NSDictionary = self.searchResultArray[indexPath.row] as? NSDictionary{
                
                let picture = rowData["picture"] as? String
                let pictureImgURL :NSURL
                
                if (picture != nil){
                    pictureImgURL = NSURL(string: picture!)!
                }else{
                    pictureImgURL = NSURL(string: "https://scontent-tpe1-1.xx.fbcdn.net/hphotos-xfa1/v/t1.0-9/11903936_10201108146742939_6231366530833832430_n.jpg?oh=2286fdc72b49dcae191d17733f02da74&oe=570AC07F")!
                }
                let pictureImgData = NSData(contentsOfURL: pictureImgURL)
                
                let message = rowData["message"] as? String
                
                let createTime = rowData["created_time"] as? String
                
                let articleTitle = rowData["id"] as? String
                
                cell.articleImage.image = UIImage(data: pictureImgData!)
                cell.articleContent.text = message
                cell.articleLabel.text = articleTitle
                
                
                if message != nil {
                    sendArticleContent.append(message!)
                }else{
                    sendArticleContent.append("")
                }
                
                if pictureImgData != nil {
                    sendArticleImage.append(pictureImgData!)
                }else{
                    sendArticleImage.append("")
                }
                
                if createTime != nil {
                    sendPostDateLabel.append(createTime!)
                }else{
                    sendPostDateLabel.append("")
                }
                
                if articleTitle != nil {
                    sendArticleTitleLabel.append(articleTitle!)
                }else{
                    sendArticleTitleLabel.append("")
                }
            }
        }
        return cell
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "searchArticleDetail"{
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let destinationController = segue.destinationViewController as! ArticleDetailViewController
                
                destinationController.acceptArticleContent = self.sendArticleContent[indexPath.row] as! String
                destinationController.acceptArticleImage = self.sendArticleImage[indexPath.row] as! NSData
                
                destinationController.acceptPostDateLabel = self.sendPostDateLabel[indexPath.row] as! String
                destinationController.acceptArticleTitleLabel = self.sendArticleTitleLabel[indexPath.row] as! String
            }
        }
    }
    
}
