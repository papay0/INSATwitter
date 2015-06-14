//
//  TweetTableViewCell.swift
//  SmashTag
//
//  Created by Arthur Papayo on 6/13/15.
//  Copyright © 2015 Arthur Papayo. All rights reserved.
//

import UIKit

protocol TweetTableViewCellDelegate  {
    func updateTweetHashTag(TweetTableViewCell)
//    func isOff(cell: CustomTableViewCell)
}

class TweetTableViewCell: UITableViewCell, UITextViewDelegate {
    
    var delegate : TweetTableViewCellDelegate?
    
    var tweet:Tweet?{
        didSet{
            print("I update my cell !")
            updateUI()

        }
    }
    
    var newHashTagInCell : String?
    
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
    
       // let tweetTableView = TweetTableViewController()
        
        let application:UIApplication = UIApplication.sharedApplication()
        if application.canOpenURL(URL){
            print("It's a valid URL")
        } else {
            print("ERROR URL no valid")
            //tweetTableView.searchText = URL.absoluteString
            newHashTagInCell = URL.absoluteString
            delegate?.updateTweetHashTag(self)
        }
        return true
    }
    
    
    /*
    func textView(textView: UITextView, shouldInteractWithTextAttachment textAttachment: NSTextAttachment, inRange characterRange: NSRange) -> Bool {
        print("haha")
        return true
    }
    */
    
    private func openURLWithSafari(urlString: String) {
        if let url = NSURL(string: urlString) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    

    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    @IBOutlet weak var tweetTextView: UITextView!
    
    func updateUI() {
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        //        tweetCreatedLabel?.text = nil
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet
        {
            //tweetTextLabel?.text = tweet.text
            tweetTextView?.text = tweet.text
            tweetTextView?.delegate = self
            /*
            if tweetTextLabel?.text != nil  {
                for media in tweet.media {
                    print(media)
                    tweetTextLabel.text! += " 📷"
                }
            }
            */
            
            
            let attributedText: NSMutableAttributedString = NSMutableAttributedString(string: tweet.text)
            
            let hashtagAttrs = [NSForegroundColorAttributeName : UIColor.grayColor()]
            for hashtag in tweet.hashtags {
                let hashtagLinksAttrs = [NSLinkAttributeName : hashtag.keyword]
                attributedText.setAttributes(hashtagAttrs, range: hashtag.nsrange)
                attributedText.setAttributes(hashtagLinksAttrs, range: hashtag.nsrange)
                

//                print("\(hashtag) ==> \(hashtag.nsrange)")
            }
            
            let urlAttrs = [NSForegroundColorAttributeName: UIColor.blueColor()]
            for url in tweet.urls {
                attributedText.setAttributes(urlAttrs, range: url.nsrange)
            }
            
            let userAttrs = [NSForegroundColorAttributeName: UIColor.brownColor()]
            for user in tweet.userMentions {
                attributedText.setAttributes(userAttrs, range: user.nsrange)
            }
            
          //  tweetTextLabel?.attributedText = attributedText
            tweetTextView?.attributedText = attributedText

            
            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
            
            
            if let profileImageURL = tweet.user.profileImageURL {
                let colorForBorder = UIColor.blackColor()
                let qos = Int(QOS_CLASS_USER_INITIATED.rawValue) // qos = quality of service (if it's slow, important...)
                dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                    if let imageData = NSData(contentsOfURL: profileImageURL) {
                        dispatch_async(dispatch_get_main_queue(), {
                            if let image = UIImage(data: imageData){
                                self.tweetProfileImageView?.image = image
                                //self.tweetProfileImageView?.layer.cornerRadius = self.tweetProfileImageView.frame.size.width / 2
                                self.tweetProfileImageView?.layer.cornerRadius = 10.0
                                self.tweetProfileImageView?.clipsToBounds = true
                                self.tweetProfileImageView?.layer.borderWidth = 3.0
                                self.tweetProfileImageView?.layer.borderColor = colorForBorder.CGColor
                            }
                            }
                        )
                    }
                }
            }
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
        }
        
    }
    
    
}
