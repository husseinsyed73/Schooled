//
//  MenuViewController.swift
//  Schooled
//
//  Created by Omar Dadabhoy on 6/20/19.
//  Copyright © 2019 Hussein  Syed. All rights reserved.
//

import UIKit
import AWSDynamoDB
import Foundation
import AWSCognitoIdentityProvider

class MenuViewController: UIViewController {

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var questionsLeftField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        self.questionsLeftField.text = String(questionsLeft)
        // Do any additional setup after loading the view.
        userNameField.text! = username123
        userNameField.isUserInteractionEnabled = false
        //Do the same with the email
        
        self.emailField.text! = useremail
        self.emailField.isUserInteractionEnabled = false
        self.questionsLeftField.text! = String(questionsLeft)
        self.questionsLeftField.isUserInteractionEnabled = false
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


