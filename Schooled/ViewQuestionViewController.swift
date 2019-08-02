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
    var activity: UIActivityIndicatorView = UIActivityIndicatorView()
    var activity2 : UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionField: UITextView!
    var currentQuestionData: Phototext? = nil
    var image: UIImage? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // adding the loading icon
        
        self.activity.hidesWhenStopped = true
        self.activity.style = UIActivityIndicatorView.Style.gray;
        self.activity.color = UIColor.white
        
        let transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        
        self.activity.transform = transform
        self.activity.frame = CGRect(x: self.view.center.x, y: (self.imageView.center.y + self.view.center.y)/2.2, width: 00.0, height: 00.0)
        view.addSubview(activity);
        
        
        self.activity2.hidesWhenStopped = true
        self.activity2.center = self.view.center
        self.activity2.style = UIActivityIndicatorView.Style.gray;
        self.activity2.color = UIColor.red
        let transform2 = CGAffineTransform(scaleX: 2.0, y: 2.0)
        
        self.activity2.transform = transform2
        
        view.addSubview(activity2);
        // Do any additional setup after loading the view.
        topicTextField.textAlignment = NSTextAlignment.center
        topicTextField.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        topicTextField.text! = currentQuestionData!._subject!
        topicTextField.isUserInteractionEnabled = false
        descriptionField.text! = currentQuestionData!._noteId!
        getPicture()
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTap)))
        // making it not editable
        self.descriptionField.isEditable = false
        self.descriptionField.isSelectable = false
        
    }
    
    @IBAction func answer(_ sender: Any) {
        // loading in the question data
        if(userLoaded){
       self.performSegue(withIdentifier: "answer", sender: self)
        }else{
            self.activity2.startAnimating()
            // then we have to load in the user data
            let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
            dynamoDBObjectMapper.load(UserDataModel.self, hashKey: username123, rangeKey:nil).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
                if let error = task.error as? NSError {
                    print("The request failed. Error: \(error)")
                } else if let result = task.result as? UserDataModel {
                    // updating the questions and user data
                    questionsLeft = result._questions as! Int
                    userphoneNumber = result._phoneNumber!
                    useremail = result._email!
                    
                    userLoaded = true
                    DispatchQueue.main.async {
                        self.activity2.stopAnimating()
                        self.performSegue(withIdentifier: "answer", sender: self)
                    }
                    
                }
                return nil
            })
        }
    }
    
    @IBAction func savePhoto(_ sender: Any) {
        let imageData = imageView.image!.pngData()
        let compresedImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compresedImage!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Saved", message: "Your image has been saved", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //downloads the picture from the database
    func getPicture() {
        self.activity.startAnimating()
        
        
        let tranferUtility = AWSS3TransferUtility.default()
        let expression = AWSS3TransferUtilityDownloadExpression()
        expression.progressBlock = {(task, progress) in DispatchQueue.main.async(execute: {
            
        })
        }
        tranferUtility.downloadData(fromBucket: bucket, key: self.currentQuestionData!._userId!, expression: expression){ (task, url, data, error) in
            if error != nil{
                DispatchQueue.main.async {
                self.activity.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                let alertController = UIAlertController(title: "ALERT", message:
                    "This question has been answered please refresh your feed", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
            
                }

            }else{
            DispatchQueue.main.async(execute: {
                
                self.imageView.image = UIImage(data: data!)
                self.image = self.imageView.image
                self.activity.stopAnimating()
                
            })
            
            }}
    }
    
    //Saves the image to the users phone when long pressed
   
    
    
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
        if segue.destination is AnswersViewController {
            let vc = segue.destination as? AnswersViewController
            vc?.currentQuestionData = self.currentQuestionData
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
