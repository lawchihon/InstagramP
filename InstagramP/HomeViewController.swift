//
//  HomeViewController.swift
//  InstagramP
//
//  Created by John Law on 7/3/2017.
//  Copyright © 2017 Chi Hon Law. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var posts: [Post]?
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension

        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        refreshControlAction(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        print("refresh")
        // ... Create the URLRequest `myRequest` ...
        Post.loadPost(
            user: nil,
            success: {
                (posts) in
                self.posts = posts
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            },
            failure: { (error) in
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
            }
        )
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        PFUser.logOutInBackground {
            (error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogout"), object: nil)

                //_ = self.navigationController?.tabBarController?.popoverPresentationController
                // self.performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
            }
        }
    }

}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let posts = posts {
            return posts.count
        }
        return 0
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostView", for: indexPath) as! PostViewCell
        
        cell.post = posts?[indexPath.row]
        cell.updateCell()

        cell.selectionStyle = .none
        
        /*
         let backgroundView = UIView()
         backgroundView.backgroundColor = UIColor(red: 224/255.0, green: 215/255.0, blue: 247/255.0, alpha: 1.00)
         cell.selectedBackgroundView = backgroundView
         */
        
        
        return cell
    }

}
