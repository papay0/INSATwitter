//
//  TweetTableViewCell.swift
//  SmashTag
//
//  Created by Arthur Papayo on 6/13/15.
//  Copyright © 2015 Arthur Papayo. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    var tweet:Tweet?{
        didSet{
            updateUI()
        }
    }
   
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!

    func updateUI() {
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
//        tweetCreatedLabel?.text = nil
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet
        {
            tweetTextLabel?.text = tweet.text
            if tweetTextLabel?.text != nil  {
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
            }
            
            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
            
            // TODO: Unblock the main thread !
            if let profileImageURL = tweet.user.profileImageURL {
                let qos = Int(QOS_CLASS_USER_INITIATED.rawValue) // qos = quality of service (if it's slow, importante...)
                dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                    if let imageData = NSData(contentsOfURL: profileImageURL) {
                        dispatch_async(dispatch_get_main_queue(), {
                                    tweetProfileImageView?.image = UIImage(data: imageData)
                            }
                        )
                    }
                }

                if let imageData = NSData(contentsOfURL: profileImageURL) { // blocks main thread!
                    tweetProfileImageView?.image = UIImage(data: imageData)
                }
            }
            
            /*
            if let url = imageURL{
                spinner?.startAnimating()
                let qos = Int(QOS_CLASS_USER_INITIATED.rawValue) // qos = quality of service (if it's slow, importante...)
                dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                    let imageData = NSData(contentsOfURL: url)
                    dispatch_async(dispatch_get_main_queue(), {
                        if url == self.imageURL { // in order to check if I still ask for the same image
                            if imageData != nil {
                                self.image = UIImage(data: imageData!)
                            } else {
                                self.image = nil
                            }
                        }
                    })
                }
            }
            */

            
            
            
//            
//            let formatter = NSDateFormatter()
//            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
//                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
//            } else {
//                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
//            }
//            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
        }
        
    }

    
}
