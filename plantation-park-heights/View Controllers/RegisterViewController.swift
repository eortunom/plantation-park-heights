//
//  RegisterViewController.swift
//  plantation-park-heights
//
//  Created by O'Herin, Alice on 8/6/19.
//  Copyright © 2019 Ortuno Marroquin, Eduardo. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

class RegisterViewController: UIViewController, GIDSignInUIDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Automatically sign in the user.
        GIDSignIn.sharedInstance().signInSilently()
        
        // Configure the sign-in button look/feel if desired
    }
    
    @IBAction func showMessage(sender: UIButton) {
        let alertController = UIAlertController(title: "Welcome to My First App", message: "Hello World", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
