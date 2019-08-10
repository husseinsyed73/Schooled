//
//  AnswersViewController.swift
//  Schooled
//
//  Created by Omar Dadabhoy on 7/20/19.
//  Copyright © 2019 Hussein  Syed. All rights reserved.
//

import UIKit
import AWSDynamoDB
import AWSS3
import AWSCognito

class AnswersViewController: UIViewController, UIImagePickerControllerDelegate, UITextViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var answerDescription: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker = UIImagePickerController()
    var currentQuestionData: Phototext? = nil
    @IBOutlet weak var choosePic: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.imagePicker.delegate = self
        answerDescription.delegate = self
        self.answerDescription.layer.borderWidth = 2.0
        self.answerDescription.layer.borderColor = UIColor.gray.cgColor
        answerDescription.text = "Describe or provide any explanation to your answer here!"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //adds the photo
    @IBAction func addPhoto(_ sender: Any) {
        
        showActionSheet()
        if(imageView.image != nil){
            self.choosePic.setTitle("", for: .normal)
        }
    }
    
    //Sends the answer to the user
    @IBAction func send(_ sender: Any) {
        if(self.imageView.image == nil){
        
            let alert = UIAlertController(title: "Alert", message: "Please add an image", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        //get the username
        let userName: String = buildUserName(userId: self.currentQuestionData!._userId!)
        //get the userdatamodel for the name
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        //Sends the answer to the users phone and email
        dynamoDBObjectMapper.load(UserDataModel.self, hashKey: userName, rangeKey:nil).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
            if let error = task.error as NSError? {
                print("The request failed. Error: \(error)")
            } else if let result = task.result as? UserDataModel {
                // Do something with task.result.
                DispatchQueue.main.async {
                    
                        
                    let send: Send = Send(image: self.imageView.image!, phoneNumber: result._phoneNumber!, email: result._email!, answerDescription: self.answerDescription.text!)
                    // omar twilio api
                    if(result._phoneNumber != "123"){
                        send.sendToPhone()
                    }
                    send.sendEmail()
                   
                    
                    
                }
            }
            return nil
        })
        
        //deletes the current question off the database
        let photoTextToDelete = Phototext()
        photoTextToDelete?._userId = self.currentQuestionData?._userId
        dynamoDBObjectMapper.remove(photoTextToDelete!).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
            if let error = task.error as NSError? {
                print("The request failed. Error: \(error)")
            } else {
                // Item deleted.
            }
            return nil
        })
        
        
        //delete the photo from the s3 bucket
        let s3 = AWSS3.default()
        let deleteObject = AWSS3DeleteObjectRequest()
        deleteObject?.bucket = bucket
        deleteObject?.key = currentQuestionData?._userId
        s3.deleteObject(deleteObject!).continueWith { (task:AWSTask) -> AnyObject? in
            if let error = task.error {
                print("Error occurred: \(error)")
                return nil
            }
            print("Bucket object deleted successfully.")
            return nil
        }
        questionsLeft += 1
        let dynamoDBObjectMapper1 = AWSDynamoDBObjectMapper.default()
        let user = UserDataModel()
        user?._phoneNumber = userphoneNumber
        user?._email = useremail
        user?._userId = username123
        
        user?._questions = questionsLeft as NSNumber
        
        dynamoDBObjectMapper1.save(user!).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
                
                
            } else {
                
            }
            return nil
        })
        
        
        //go back home and notify the user they are done
        let alertController = UIAlertController(title: "Your answer has been sent", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: { alert -> Void in
            if let navController = self.navigationController{
                navController.popViewController(animated: true)
                navController.popViewController(animated: true)
            }
        })
        alertController.addAction(alertAction)
        self.present(alertController, animated: true)
    }
    
    //returns the username
    func buildUserName(userId: String) -> String {
        var i: Int = 0
        var found: Bool = false
        while(!found){
            if(userId[i] == "-"){
                found = true
            }
            i += 1
        }
        return userId[0..<i-1]
    }
    
    //shows the action sheet which will allow the user to pick camera or gallery
    func showActionSheet(){
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    //This function is hooked up to the camera which will allow the user to shoot a photo
    func camera(){
        //if we can pick a picture then enter this
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            //print the button capture to indicate we will pick a picture
            print("Button capture")
            //set the source of the pictures to the saved pictures on the users phone
            imagePicker.sourceType = .camera
            //we do not want to allow the user to edit the picture in this functio
            imagePicker.allowsEditing = true
            
            //present the imagePicker in this view controller
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //This function is hooked up to the photolibrary which will allow the user to pick a photo
    func photoLibrary() {
        //if we can pick a picture then enter this
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            //print the button capture to indicate we will pick a picture
            print("Button capture")
            //set the source of the pictures to the saved pictures on the users phone
            imagePicker.sourceType = .photoLibrary
            //we do not want to allow the user to edit the picture in this functio
            imagePicker.allowsEditing = true
            
            //present the imagePicker in this view controller
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //This function puts the image in the imageView to display for the user
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //if the image is an UIImage then display it into the imageView
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = image
            self.choosePic.setTitle("", for: .normal)
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    //pops the view up when the keyboard appears
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    //hides the view when the keyboard is gone
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    //dismisses the text view when return it hit
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView){
        if(answerDescription.text == "Describe or provide any explanation to your answer here!") {
            answerDescription.text = ""
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

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ..< end]
    }
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        return self[start ... end]
    }
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ... end]
    }
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ..< end]
    }
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}
extension Substring {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ..< end]
    }
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        return self[start ... end]
    }
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ... end]
    }
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ..< end]
    }
}
