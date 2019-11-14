//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Stephanie Le on 11/4/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    
    let myRefreshControl = UIRefreshControl()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // when your view loads, loads the API request
        self.loadTweets()
        
        // reload tweets every time someone pulls to refresh
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        
        //
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()
    }
    
    // Request tweets from API and load in a dictionary
    @objc func loadTweets(){
        
        //sets number of tweets to 20 whenever screen is refreshed
        numberOfTweets = 20
        
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberOfTweets]
        
        // if successful, call the requested dictionaries "tweets"
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            //empties tweet array before adding
            self.tweetArray.removeAll()
            
            //appends requested tweets into tweet array
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            // every time we repopulate the tweet array, reload the content
            self.tableView.reloadData()
            
            // after reloading the tweet, stop the refreshing icon
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print("No tweets for you")
        })
        
    }
    
    func loadMoreTweets(){
        
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweets = numberOfTweets + 20
        let myParams = ["count": numberOfTweets]
        
        // same as loadTweet
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            //empties tweet array before adding
            self.tweetArray.removeAll()
            
            //appends requested tweets into tweet array
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            // every time we repopulate the tweet array, reload the content
            self.tableView.reloadData()
            
            
        }, failure: { (Error) in
            print("No tweets for you")
        })

    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell // created a tweetcell class and cast the cell as that type to access tweet cell's variables
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        cell.userNameLabel.text = user["name"] as! String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        // set color to whether the tweet is favorited or not
    cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
        
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        // when user gets to the end of the page
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }
    
    
    //What happens when we click log out button
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout() // log out in the background (API)
        // dismiss the home screen
        self.dismiss(animated: true, completion: nil)
        // tell User Defaults that user is logged out
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }



}
