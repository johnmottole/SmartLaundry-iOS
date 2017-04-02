//
//  HelpViewController.swift
//  Laundry
//
//  Created by John Mottole on 2/19/17.
//  Copyright © 2017 John Mottole. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class HelpViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    var user : FIRUser!
    var ref: FIRDatabaseReference!
    var refHandle : FIRDatabaseHandle!
    var currentIndex = 0
    let otherText = ["Once your cycle has started, simply push start to begin monitoring your laundry", "During the cycle simply say to Alexa 'Ask smart laundry if it's done'","Remember to enable the Smart Laundry Alexa skill and to link it to the same Facebook account"]
    override func viewDidLoad() {
        super.viewDidLoad()
        user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference().child("users").child((user?.uid)!)
        refHandle = ref.observe(FIRDataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : Bool] ?? [:]
            if let inSession = postDict["inSession"]
            {
                if inSession
                {
                    print("WE IN SESSION")
                }else{
                    print("WE NOT IN SESSION")
                }
            }
            
            
            
        })
        // Do any additional setup after loading the view.
    }
    @IBAction func nextButton(_ sender: UIButton) {
        if currentIndex == 3
        {
            ref.child("users").child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let data = value?["inSession"] as? Bool
                if let theData = data
                {
                    if theData == true
                    {
                        self.infoLabel.text = "You already have another device monitoring your laundry"
                    }else {
                        self.performSegue(withIdentifier: "HelpToMonitor", sender: self)
                    }
                } else {
                    self.performSegue(withIdentifier: "HelpToMonitor", sender: self)
                }
               
            })
            
        } else
        {
            infoLabel.text = otherText[currentIndex]
            currentIndex += 1
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pageChange(_ sender: UIPageControl) {
        print("new page \(sender.currentPage)")
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
