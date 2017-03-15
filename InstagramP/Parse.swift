//
//  Parse.swift
//  InstagramP
//
//  Created by John Law on 7/3/2017.
//  Copyright © 2017 Chi Hon Law. All rights reserved.
//

import UIKit
import Parse

class Post: NSObject {
    /**
     * Other methods
     */
    
    var author: PFUser?
    var media: PFFile?
    var caption: String?
    
    init(object: PFObject) {
        self.author = object["author"] as? PFUser
        self.media = object["media"] as! PFFile
        self.caption = object["caption"] as? String
    }

    class func loadPost(user: PFUser?, success: @escaping ([Post]) -> (), failure: @escaping (Error) -> ()){
        let query = PFQuery(className: "Post")
        query.order(byDescending: "_created_at")
        query.includeKey("author")
        query.limit = 20

        query.findObjectsInBackground { (objects, error) in
            if error == nil{
                
                var posts = [Post]()
                
                if objects != nil {
                    for object in objects! {
                        let post = Post(object: object)
                        posts.append(post)
                    }
                }
                
                success(posts)
            }
            else{
                failure(error!)
            }
        }
    }

    
    /**
     Method to add a user post to Parse (uploading image file)
     
     - parameter image: Image that the user wants upload to parse
     - parameter caption: Caption text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let post = PFObject(className: "Post")
        
        let postSize = CGSize(width: 375, height: 375)
        let resizedImage = resize(image: image, newSize: postSize) as UIImage?
        // Add relevant fields to the object
        post["media"] = getPFFileFromImage(image: resizedImage) // PFFile column type
        post["author"] = PFUser.current() // Pointer column type that points to PFUser
        post["caption"] = caption
        post["likesCount"] = 0
        post["commentsCount"] = 0
        
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackground(block: completion)
    }
    
    /**
     Method to convert UIImage to PFFile
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
    
    class func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    class func resize(image: UIImage?, newSize: CGSize) -> UIImage? {
        if let image = image {
            let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
            resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
            resizeImageView.image = image
            
            UIGraphicsBeginImageContext(resizeImageView.frame.size)
            resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage!
        }
        
        return nil
    }

}
