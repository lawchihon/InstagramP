//
//  PhotoLibraryViewController.swift
//  InstagramP
//
//  Created by John Law on 7/3/2017.
//  Copyright © 2017 Chi Hon Law. All rights reserved.
//

import UIKit
import Photos
import Parse
import MBProgressHUD

class PhotoLibraryViewController: UIViewController {

    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var captionField: UITextField!
    @IBOutlet weak var selectButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Get the current authorization state.
        let status = PHPhotoLibrary.authorizationStatus()
        
        if (status == PHAuthorizationStatus.authorized) {
            // Access has been granted.
        }
            
        else if (status == PHAuthorizationStatus.denied) {
            // Access has been denied.
            self.dismiss(animated: true, completion: nil)
        }
            
        else if (status == PHAuthorizationStatus.notDetermined) {
            
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if (newStatus == PHAuthorizationStatus.authorized) {
                    // Aurthorized Access
                }
                    
                else {
                    // UnAuthorized Access
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
            
        else if (status == PHAuthorizationStatus.restricted) {
            // Restricted access - normally won't happen.
        }
        
        self.tabBarController?.tabBar.isHidden = true
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

    @IBAction func onSelectButton(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary

        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func onPostButton(_ sender: Any) {
        //let postObject = PFObject(className: "Post")
        //postObject["photo"] = editedImage
        MBProgressHUD.showAdded(to: self.view, animated: true)

        Post.postUserImage(image: selectedImage.image, withCaption: captionField.text) {
            (uploaded, error) in
            if error == nil{
                self.exit()
            }
            else{
                print(error!.localizedDescription)
            }
        }
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        exit()
    }

    func exit() {
        self.captionField.text = ""
        self.selectedImage.image = nil
        self.selectButton.setTitle("Click to select image",for: .normal)
        self.view.endEditing(true)
        MBProgressHUD.hide(for: self.view, animated: true)

        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.selectedIndex = 0
    }
}

extension PhotoLibraryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        //let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        self.selectedImage.image = editedImage

        selectButton.setTitle("",for: .normal)
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
}
