//
//  ViewQuestionViewController.swift
//  Schooled
//
//  Created by Omar Dadabhoy on 7/5/19.
//  Copyright © 2019 Hussein  Syed. All rights reserved.
//

import UIKit
import AWSDynamoDB
import AWSCognitoIdentityProvider
import AWSS3
import AWSCore
import AWSMobileClient
import AWSCognitoIdentityProviderASF
import AWSAuthCore

class ViewQuestionViewController: UIViewController {
    @IBOutlet weak var topicTextField: UILabel!
    
   
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionField: UITextView!
    var currentQuestionData: Phototext? = nil
    var image: UIImage? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        topicTextField.textAlignment = NSTextAlignment.center
        topicTextField.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        topicTextField.text! = currentQuestionData!._subject!
        topicTextField.isUserInteractionEnabled = false
        descriptionField.text! = currentQuestionData!._noteId!
        getPicture()
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTap)))
    }
    
    //downloads the picture from the database
    func getPicture() {
        let tranferUtility = AWSS3TransferUtility.default()
        let expression = AWSS3TransferUtilityDownloadExpression()
        expression.progressBlock = {(task, progress) in DispatchQueue.main.async(execute: {
            
        })
        }
        tranferUtility.downloadData(fromBucket: bucket, key: self.currentQuestionData!._userId!, expression: expression){ (task, url, data, error) in
            if error != nil{
                print(error!)
            }
            DispatchQueue.main.async(execute: {
                self.imageView.image = UIImage(data: data!)
                self.image = self.imageView.image
            })
            
        }
    }
    
    //performs the segue to see the image larger when the user clicks the image
    @objc func imageTap() {
        self.performSegue(withIdentifier: "viewImageLarger", sender: self)
    }
    
    //sends the image to the ImageViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ImageViewController {
            let vc = segue.destination as? ImageViewController
            vc?.image = self.image
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

}
