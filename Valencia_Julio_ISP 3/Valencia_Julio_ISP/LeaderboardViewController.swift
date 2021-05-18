//
//  LeaderboardViewController.swift
//  Valencia_Julio_ISP
//
//  Created by Period Two on 1/23/19.
//  Copyright © 2019 Period Two. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController {
    @IBOutlet var scoreOutlets: [UILabel]!
    
    var scoreLeader = 0
    var playerScores: [Int] = []
    var limit = 0
    override func viewDidLoad() {
        
        if UserDefaults.standard.value(forKey: "scores") != nil{
            playerScores = UserDefaults.standard.value(forKey: "scores") as! [Int]
            playerScores.removeAll()
            print(playerScores.count)
            if limit > 10{
                playerScores.removeAll()
            }
            limit = playerScores.count - 1
            for index in 0...limit {
                scoreOutlets[index].text = "Score: \(playerScores[index])"
            }
        }
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
