//
//  WaitingViewController.swift
//  NearbyVoting
//
//  Created by Darrell Shi on 12/19/17.
//  Copyright © 2017 Darrell Shi. All rights reserved.
//

import UIKit
import TransitionButton
import DotsLoading

class WaitingViewController: UIViewController {
    @IBOutlet weak var showResultsButton: TransitionButton!
    @IBOutlet weak var responseCounterLabel: UILabel!
    var numOfResponses = 0

    var dotsLoadingView: DotsLoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dotsLoadingView = DotsLoadingView(colors: [UIColor(rgb: 0x4CAF50), UIColor(rgb: 0x66BB6A), UIColor(rgb: 0x81C784), UIColor(rgb: 0xA5D6A7)])
        self.view.addSubview(dotsLoadingView)
        dotsLoadingView.show()
        
        button()
        
        responseCounterLabel.layer.masksToBounds = true
        responseCounterLabel.layer.cornerRadius = 20
        
        listen()
    
    }
    
    private func button() {
        showResultsButton.backgroundColor = UIColor(rgb: 0x7CB342)
        showResultsButton.tintColor = UIColor.white
        showResultsButton.cornerRadius = showResultsButton.frame.height / 2
        showResultsButton.spinnerColor = .white
        showResultsButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
    
    @IBAction func buttonAction(_ button: TransitionButton) {
        button.startAnimation()
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            sleep(1)
            DispatchQueue.main.async(execute: { () -> Void in
                self.dotsLoadingView.stop()
                UIView.animate(withDuration: 0.5, animations: {
                    self.responseCounterLabel.alpha = 0
                })
                button.stopAnimation(animationStyle: .expand, completion: {
                    self.performSegue(withIdentifier: "ToResultsViewController", sender: nil)
                })
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addResponseToVote(response: Response, vote: Vote) {
        if response.optionIndex >= vote.numOfOptions {
            return
        }
        vote.options[response.optionIndex].addResponse(response: response)
    }
    
    private func increaseResponseCounter() {
        self.numOfResponses += 1
        self.responseCounterLabel.text = "\(numOfResponses)"
    }
    
    private func listen() {
        let subscription = MessageController.messageManager.subscription(messageFoundHandler: { (message) in
            if let content = message?.content {
                let response = Response(data: content)
                if let vote = VotesManager.publishedVote {
                    self.addResponseToVote(response: response, vote: vote)
                    self.increaseResponseCounter()
                }
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
        MessageController.responseSubscription = subscription
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
