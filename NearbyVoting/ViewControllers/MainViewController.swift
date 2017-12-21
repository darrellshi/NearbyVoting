//
//  MainViewController.swift
//  NearbyVoting
//
//  Created by Darrell Shi on 12/18/17.
//  Copyright © 2017 Darrell Shi. All rights reserved.
//

import UIKit
import Messages
import TransitionButton
import DotsLoading

class MainViewController: UIViewController {
    @IBOutlet weak var createVoteButton: TransitionButton!
    
    var finishedVoting = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .default
        
        if ViewsManager.dotsLoadingView == nil {
            ViewsManager.dotsLoadingView = DotsLoadingView(colors: [UIColor(rgb: 0x4CAF50), UIColor(rgb: 0x66BB6A), UIColor(rgb: 0x81C784), UIColor(rgb: 0xA5D6A7)])
        }
        self.view.addSubview(ViewsManager.dotsLoadingView)
        ViewsManager.dotsLoadingView.show()
        
        self.listenForVote()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.button()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func button() {
        createVoteButton.backgroundColor = UIColor(rgb: 0x7CB342)
        createVoteButton.tintColor = UIColor.white
        createVoteButton.cornerRadius = createVoteButton.frame.height / 2
        createVoteButton.spinnerColor = .white
        createVoteButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
    
    @IBAction func buttonAction(_ button: TransitionButton) {
        button.startAnimation()
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            sleep(1)
            DispatchQueue.main.async(execute: { () -> Void in
                ViewsManager.dotsLoadingView.stop()
                button.stopAnimation(animationStyle: .expand, completion: {
                    self.performSegue(withIdentifier: "ToCreateVoteViewController", sender: nil)
                })
            })
        })
    }
    
    private func listenForVote() {
        let subscription = MessageController.messageManager.subscription(messageFoundHandler: { (message) in
            guard let message = message else { return }
            
            switch message.type {
            case "VOTE":
                if let content = message.content {
                    if (self.finishedVoting) { return }
                    let vote = Vote(data: content)
                    VotesManager.receivedVote = vote
                    self.finishedVoting = true
                    self.performSegue(withIdentifier: "ToRespondVoteViewController", sender: nil)
                }
            case "RESULT":
                if let content = message.content {
                    let vote = Vote(data: content)
                    VotesManager.publishedVote = vote
                    self.performSegue(withIdentifier: "ToResultViewController", sender: nil)
                }
            default:
                print("unknown type")
            }
            if message.type != "VOTE" { return }
            if let content = message.content {
                let vote = Vote(data: content)
                VotesManager.receivedVote = vote
                self.performSegue(withIdentifier: "ToRespondVoteViewController", sender: nil)
            }
        }, messageLostHandler: { (message) in
            print("message loss")
        }) { (params) in
            guard let params = params else { return }
            params.strategy = GNSStrategy(paramsBlock: { (params) in
                guard let params = params else { return }
                params.discoveryMediums = .default
                params.discoveryMode = .scan
            })
        }
        
        MessageController.voteSubscription = subscription
    }
    
//    private func listenForResult() {
//        let subscription = MessageController.messageManager.subscription(messageFoundHandler: { (message) in
//            guard let message = message else { return }
//            if message.type != "RESULT" { return }
//            if let content = message.content {
//                let vote = Vote(data: content)
//                VotesManager.publishedVote = vote
//                self.performSegue(withIdentifier: "ToResultViewController", sender: nil)
//            }
//        }, messageLostHandler: { (message) in
//            print("message loss")
//        }) { (params) in
//            guard let params = params else { return }
//            params.strategy = GNSStrategy(paramsBlock: { (params) in
//                guard let params = params else { return }
//                params.discoveryMediums = .default
//                params.discoveryMode = .scan
//            })
//        }
//
//        MessageController.resultSubscription = subscription
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        MessageController.voteSubscription = nil
        MessageController.resultSubscription = nil
        
        if segue.identifier == "ToResultViewController" {
            let nav = segue.destination as! UINavigationController
            let view = nav.viewControllers.first! as! ResultsViewController
            view.isMyPublication = false
        }
    }
}
