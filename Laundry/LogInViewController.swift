//
//  LogInViewController.swift
//  Laundry
//
//  Created by John Mottole on 2/12/17.
//  Copyright © 2017 John Mottole. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
class LogInViewController: UIViewController, FBSDKLoginButtonDelegate  {
    
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        facebookLoginButton.delegate = self
    }
    
    
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }

    
    /**
     Sent to the delegate when the button was used to login.
     - Parameter loginButton: the sender
     - Parameter result: The results of the login
     - Parameter error: The error (if any) from the login
     */
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        else if result.isCancelled
        {
            return
        }
        
        print(result.grantedPermissions)
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            if error != nil {
                return
            }
            self.performSegue(withIdentifier: "LoginToHelp", sender: self)
        }
    }


    
    
    override func viewDidAppear(_ animated: Bool) {
        if (FIRAuth.auth()?.currentUser != nil)
        {
            performSegue(withIdentifier: "LoginToHelp", sender: self)
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        // ...
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

}
