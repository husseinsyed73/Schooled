//
//  ProfileViewController.swift
//  Schooled
//
//  Created by Omar Dadabhoy on 6/24/19.
//  Copyright © 2019 Hussein  Syed. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    var email: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //set the userName fields to the username and do not allow the user to edit them only see them
        userNameTextField.text! = username123
        userNameTextField.isUserInteractionEnabled = false
        //Do the same with the email
        //mmcmc
        emailTextField.text! = email
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
