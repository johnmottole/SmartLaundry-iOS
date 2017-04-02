//
//  MonitorViewController.swift
//  Laundry
//
//  Created by John Mottole on 2/19/17.
//  Copyright © 2017 John Mottole. All rights reserved.
//

import UIKit
import CoreMotion
import Firebase
import FBSDKLoginKit
class MonitorViewController: UIViewController {

    @IBOutlet weak var monitoringLabel: UILabel!
    var manager : CMMotionManager!
    var theDatax = [Double]()
    var theDatay = [Double]()
    var theDataz = [Double]()
    var ref: FIRDatabaseReference!
    var isMonitoring = false
    var amountStill = 0
    var totalTimeInLast15Sec = 0
    var countingToFinish = false
    var user : FIRUser!
    @IBOutlet weak var circle: LoadingCircle!
    @IBOutlet weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        monitoringLabel.isHidden = true
        manager = CMMotionManager()
        manager.accelerometerUpdateInterval = 0.1
        ref = FIRDatabase.database().reference()
        user = FIRAuth.auth()?.currentUser
        UIApplication.shared.isIdleTimerDisabled = true
        let noticationCenter = NotificationCenter.default
        noticationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        noticationCenter.addObserver(self, selector: #selector(appMovedBack), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        button.layer.cornerRadius = 10

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startAccelometer()
    {
        manager.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
            if let data = data
            {
                self.theDatax.append(data.acceleration.x)
                self.theDatay.append(data.acceleration.y)
                self.theDataz.append(data.acceleration.z)
                if (self.theDatax.count > 10)
                {
                    self.theDatax.remove(at: 0)
                }
                if (self.theDatay.count > 10)
                {
                    self.theDatay.remove(at: 0)
                }
                if (self.theDataz.count > 10)
                {
                    self.theDataz.remove(at: 0)
                }
                let SDx = self.getSD(data: self.theDatax)
                let SDy = self.getSD(data: self.theDatay)
                let SDz = self.getSD(data: self.theDataz)
                
                print("X: \(SDx))")
                print("Y: \(SDy))")
                print("Z: \(SDz))")
                if SDx < 0.01 && SDy < 0.01 && SDz < 0.01
                {
                    self.amountStill += 1
                    self.countingToFinish = true
                }
                if self.countingToFinish
                {
                    self.totalTimeInLast15Sec += 1
                    if self.totalTimeInLast15Sec > 150
                    {
                        if self.amountStill > 120
                        {
                            self.ref.child("users").child((self.user?.uid)!).setValue(["inSession": true, "done" : true])
                            self.manager.stopAccelerometerUpdates()
                            self.amountStill = 0
                            self.totalTimeInLast15Sec = 0
                            self.countingToFinish = false
                        } else {
                            self.amountStill = 0
                            self.totalTimeInLast15Sec = 0
                            self.countingToFinish = false
                        }
                    }
                }
                
                
            }
            
        }

    }
    
    func getSD(data : [Double]) -> Double
    {
        let mean = average(data: data)
        var newNums = [Double]()
        for a in data
        {
            let aNum : Double = pow((mean - a), 2)
            newNums.append(aNum)
        }
        let mean2 = average(data: newNums)
        return (pow(mean2,0.5))
    }
    
    func average(data:[Double]) -> Double
    {
        if (data.count == 0)
        {
            return 0
        }
        var sum : Double = 0;
        for a in data
        {
            sum += a
        }
        return (sum / Double(data.count))
    }
    
    func stopMonitoring()
    {
        let user = FIRAuth.auth()?.currentUser
        button.setTitle("Start", for: .normal)
        self.ref.child("users").child((user?.uid)!).setValue(["inSession": false])
        manager.stopAccelerometerUpdates()
        monitoringLabel.isHidden = true
        isMonitoring = !isMonitoring
        circle.stopAnimation()
    }
    
    func startMonitoring()
    {
        monitoringLabel.isHidden = false
        button.setTitle("Stop", for: .normal)
        self.ref.child("users").child((user?.uid)!).setValue(["inSession": true, "done" : false])
        startAccelometer()
        isMonitoring = !isMonitoring
        circle.startAnimation()

    }
    
    @IBAction func start(_ sender: Any) {
        if isMonitoring
        {
            stopMonitoring()
        } else {
            startMonitoring()

            
        }
        
    }
    
    func appMovedToBackground()
    {
        print("Moved BACKK")
        stopMonitoring()
    }
    func appMovedBack()
    {
        startMonitoring()

    }

    @IBAction func logOut(_ sender: Any) {
        //self.ref.child("users").child((user?.uid)!).setValue(["inSession": false])
        //manager.stopAccelerometerUpdates()
        stopMonitoring()
        do{
            try FIRAuth.auth()?.signOut()
            FBSDKLoginManager.init().logOut()
        } catch{}
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        performSegue(withIdentifier: "monitorToLogin", sender: self)
        
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
