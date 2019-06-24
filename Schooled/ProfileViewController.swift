//
//  ProfileViewController.swift
//  Schooled
//
//  Created by Omar Dadabhoy on 6/24/19.
//  Copyright © 2019 Hussein  Syed. All rights reserved.
//

import UIKit
import AWSDynamoDB
import Foundation
import AWSCognitoIdentityProvider

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var questionsLeftField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //set the userName fields to the username and do not allow the user to edit them only see them
        userNameTextField.text! = username123
        userNameTextField.isUserInteractionEnabled = false
        //Do the same with the email
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        dynamoDBObjectMapper.load(UserDataModel.self, hashKey: username123, rangeKey:nil).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
            if let error = task.error as NSError? {
                print("The request failed. Error: \(error)")
            } else if let result = task.result as? UserDataModel {
                // Do something with task.result.
                DispatchQueue.main.async {
                    self.emailTextField.text! = result._email!
                    self.emailTextField.isUserInteractionEnabled = false
                    self.questionsLeftField.text! = result._questions!.stringValue
                    self.questionsLeftField.isUserInteractionEnabled = false
                }
            }
            return nil
        })
        
    }
    
    @IBAction func goBackToMain(_ sender: Any) {
        
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
