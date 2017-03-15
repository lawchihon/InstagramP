//
//  LoginViewController.swift
//  InstagramP
//
//  Created by John Law on 7/3/2017.
//  Copyright © 2017 Chi Hon Law. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    func login(username: String, password: String) {
        PFUser.logInWithUsername(inBackground: username, password: password) {
            (user, error) -> Void in
            if let error = error {
                print("User login failed.")
                print(error.localizedDescription)
                MBProgressHUD.hide(for: self.view, animated: true)
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)

                print("User logged in successfully")
                // display view controller that needs to shown after successful login
                
                self.performSegue(withIdentifier: "signInSegue", sender: nil)
            }
        }
    }

    @IBAction func onSignInButton(_ sender: Any) {
        MBProgressHUD.showAdded(to: self.view, animated: true)

        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        
        login(username: username, password: password)
        
    }

    @IBAction func onSignUpButton(_ sender: Any) {
        MBProgressHUD.showAdded(to: self.view, animated: true)

        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""

        let newUser = PFUser()
        
        // set user properties
        newUser.username = username
        newUser.password = password
        
        // call sign up function on the object
        newUser.signUpInBackground {
            (success, error) in
            if let error = error {
                MBProgressHUD.hide(for: self.view, animated: true)
                print(error.localizedDescription)
            } else {
                print("User Registered successfully")
                // manually segue to logged in view
                self.login(username: username, password: password)
            }
        }
    }
}
