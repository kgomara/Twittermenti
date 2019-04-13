//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML


class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let TWEET_COUNT = 100
    
    let sentimentClassifier = TweetSentimentClassifier()
    
    let swifter = Swifter(consumerKey: API_KEY, consumerSecret: API_SECRET_KEY)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    fileprivate func updateUI(with sentimentScore: Int) {
        
        if sentimentScore > 20 {
            sentimentLabel.text = "😍"
        }
        else if sentimentScore > 10 {
            sentimentLabel.text = "😀"
        }
        else if sentimentScore > 0 {
            sentimentLabel.text = "🙂"
        }
        else if sentimentScore == 0 {
            sentimentLabel.text = "😐"
        }
        else if sentimentScore > -10 {
            sentimentLabel.text = "😕"
        }
        else if sentimentScore > -20 {
            sentimentLabel.text = "🥵"
        }
        else {
            sentimentLabel.text = "🤮"
        }
    }
    
    
    fileprivate func makePrediction(with tweets: [TweetSentimentClassifierInput]) {
        do {
            let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
            
            var sentimentScore = 0
            for prediction in predictions {
                let sentiment = prediction.label
                
                if sentiment == "Pos" {
                    sentimentScore += 1
                }
                else if sentiment == "Neg" {
                    sentimentScore -= 1
                }
            }
            updateUI(with: sentimentScore)
            
        } catch {
            print("Eror with making a prediction: \(error)")
        }
    }
    
    
    fileprivate func fetchTweets() {
        if let searchText = textField.text {
            swifter.searchTweet(using: searchText, lang: "en", count: TWEET_COUNT, tweetMode: .extended, success: { (results, metadata) in
                
                var tweets = [TweetSentimentClassifierInput]()
                for i in 0..<self.TWEET_COUNT {
                    if let tweet = results[i]["full_text"].string {
                        let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                        tweets.append(tweetForClassification)
                    }
                }
                
                self.makePrediction(with: tweets)
            }) { (error) in
                print("Search failed: \(error)")
            }
        }
    }
    
    
    @IBAction func predictPressed(_ sender: Any) {
        
        fetchTweets()

    }
    
}

