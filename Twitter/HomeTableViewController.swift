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
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadTweet(){
        
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": 10]
        TwitterAPICaller.client?.getDictionariesRequest(url: <#T##String#>, parameters: <#T##[String : Any]#>, success: <#T##([NSDictionary]) -> ()#>, failure: <#T##(Error) -> ()#>)
        
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell // created a tweetcell class and cast the cell as that type to access tweet cell's variables
        
        cell.userNameLabel.text = "some name"
        cell.tweetContent.text = "something"
        
        return cell
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
        return 5
    }



}
