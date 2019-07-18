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
self.questionsLeftField.text = String(questionsLeft)
        // Do any additional setup after loading the view.
        userNameField.text! = username123
        userNameField.isUserInteractionEnabled = false
        //Do the same with the email
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        dynamoDBObjectMapper.load(UserDataModel.self, hashKey: username123, rangeKey:nil).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
            if let error = task.error as NSError? {
                print("The request failed. Error: \(error)")
            } else if let result = task.result as? UserDataModel {
                // Do something with task.result.
                DispatchQueue.main.async {
                    self.emailField.text! = result._email!
                    self.emailField.isUserInteractionEnabled = false
                    self.questionsLeftField.text! = result._questions!.stringValue
                    self.questionsLeftField.isUserInteractionEnabled = false
                    questionsLeft = Int(result._questions!)
                }
            }
            return nil
        })
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
