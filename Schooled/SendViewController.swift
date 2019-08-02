//
//  SendViewController.swift
//  Schooled
//
//  Created by Omar Dadabhoy on 6/7/19.
//  Copyright © 2019 Hussein  Syed. All rights reserved.
//

//This class is connected to the ViewController that controls the sending and adding of photos

import UIKit
import AWSS3
import AWSDynamoDB
class SendViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var subtopic: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var choosePic: UIButton!
    var activity: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var imagePicker = UIImagePickerController()
    var text = ""
    var summary = ""
    var sub = ""
    var subjectPicker: UIPickerView = UIPickerView()
    var pickerData: [String] = ["Calculus M408C", "Calculus M408D", "Statistics SDS 321", "Probability M326K", "Computer Architecture CS 429", "Introduction to Computing Systems EE 306", "Introduction to Embedded Systems EE319K"]
    let toolBar = UIToolbar()
    @IBOutlet weak var Summary: UITextField!
    
    @IBOutlet weak var questionDirections: UITextView!
    
    var textSaved = false
    var picSaved  = false
    
  
    var localPath: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // adding the loading icon
        self.activity.center = self.view.center
        self.activity.hidesWhenStopped = true
        self.activity.style = UIActivityIndicatorView.Style.gray;
        self.activity.color = UIColor.black
        let transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        self.activity.transform = transform
        
        view.addSubview(activity);        // Do any additional setup after loading the view.
        questionDirections.delegate = self
        self.questionDirections.layer.borderWidth = 2.0
        self.questionDirections.layer.borderColor = UIColor.gray.cgColor
        
        questionDirections.text = "Please elaborate on your question, the more accurate the description the better!"
        questionDirections.textAlignment = .left
        
        imagePicker.delegate = self
        subjectPicker.delegate = self
        //make the questionDirections what ever the user picks
        Summary.inputView = subjectPicker
        
        //set up the toolbar for the picker
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.Summary.inputAccessoryView = toolBar
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        subtopic.delegate = self
    }
    
    //dismisses the text view when return it hit
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    //disables the keyboard after hitting return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
    
    //when the user clicks done in the toolbar the picker will exit
    @objc func donePicker(){
        self.Summary.resignFirstResponder()
    }
    
    //number of columns in the picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //number of rows in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //The current item
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    //contains what is selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Summary.text = pickerData[row]
    }
    
    //This function adds a photo into the UIImageView either through camera or photo library
    @IBAction func addPhoto(_ sender: Any) {
        showActionSheet()
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
    
    //removes the text when the sub topic is picked
    @IBAction func clickSubTopic(_ sender: Any) {
        if(subtopic.text == "Please enter the subtopic"){
            subtopic.text = ""
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView){
        if(questionDirections.text == "Please elaborate on your question, the more accurate the description the better!") {
            questionDirections.text = ""
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
   // function to send the photo and
    // post it on the main feed
    // just make the subject now math add in scroll wheel later
    // then name of the photo will be the user
    @IBAction func SendPhoto(_ sender: Any) {
        // this adds the needed data to the plist
             // converting the data to a png reprisentation
    // end the function if empty
        self.textSaved = false;
        self.picSaved = false
        
         self.activity.startAnimating();
        UIApplication.shared.beginIgnoringInteractionEvents();
        
        guard let image = imageView.image else {
            let alertController = UIAlertController(title: "ALERT", message:
                "Please add a Photo", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
             UIApplication.shared.endIgnoringInteractionEvents()
            self.activity.stopAnimating();
            return
            
        }
        let data = image.pngData()
        let remoteName = "test.png"
        self.text = self.questionDirections.text!
        // grabbing the summary data
        self.summary = self.Summary.text!
        self.sub = self.subtopic.text!
        if(self.sub == "What Subject are you taking ?" || self.summary == "Please enter the subtopic" || self.text == "Please elaborate on your question, the more accurate the description the better!"){
            let alertController = UIAlertController(title: "ALERT", message:
                "Please fill out the entire post ", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
          
            
            self.activity.stopAnimating();
            UIApplication.shared.endIgnoringInteractionEvents()
            return;
        }
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(remoteName)
        do {
            try data?.write(to: fileURL)
            localPath = fileURL
            let uploadRequest = AWSS3TransferManagerUploadRequest()
            uploadRequest?.body = fileURL
            // no point of folder because storing all of the photos
            // username dash and the time for splitting up the data
            let time = String(Int64(Date().timeIntervalSince1970 * 1000));
            var keydata = username123;
            keydata = keydata + "-";
            keydata = keydata + time
            keydata = keydata + ".png"
            // reason still png because we have to move it into the dynamo db the same
            var textkey = username123;
            textkey = textkey + "-";
            textkey = textkey + time
            textkey = textkey + ".png"
            
            uploadRequest?.key = keydata
            
            
            // sending over the bucket name and the type
            // name scheme being
            // lets en
            uploadRequest?.bucket = bucket
            uploadRequest?.contentType = "image/png"
            // one sends high likleyhood other sends 
             self.sendText(key:textkey,summ: self.summary,sub:self.sub);
            
            let transferManager = AWSS3TransferManager.default()
            
            
            
        transferManager.upload(uploadRequest!).continueWith { (task) -> AnyObject? in
                if let error = task.error {
                    // check if internet was bad
                    print("Upload failed (\(error))")
                    let alertController = UIAlertController(title: "ALERT", message:
                        "Your Question was not able to be posted at this time", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                                       // error because not posted
                    self.activity.stopAnimating();
                    UIApplication.shared.endIgnoringInteractionEvents()
            }else{
                    
                    // now we can send
                    DispatchQueue.main.async {
                        self.activity.stopAnimating()
                        questionsLeft -= 1
                        
                        self.updateQuestionCount()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        self.navigationController?.popViewController(animated: true)
                        
                        
                    }
                
            }
            return nil
            }
        } catch {
            print("File not save failed")
        }
        
    }
       
        
        
        func sendText(key:String,summ:String,sub:String){
            
          
            // now sending the text
            let photoadder = Phototext();
            // creating the user object
            photoadder?._userId = key;
            photoadder?._noteId = text;
            // adding a subject to be displayed to the user
            // the changed subject
            photoadder?._subject = summ
            // adding the user summary but of the main ui thread
            photoadder?._summary = sub
           
            // crendtials for aws access not the user model
            let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
            
            dynamoDBObjectMapper.save(photoadder!).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
                // taking it off the main ui thread
                
                
                if let error = task.error as NSError? {
                   // only once you gotta check for internet connection just tick back the numbers
                    let alertController = UIAlertController(title: "ALERT", message:
                        "Your Question was not able to be posted at this time", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                    
                    self.present(alertController, animated: true, completion: nil)
                    self.activity.stopAnimating();
                    UIApplication.shared.endIgnoringInteractionEvents()
                } else {
                   
                    
                    
                
                }
                
                return nil
            })
        }
    func updateQuestionCount(){
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        let user = UserDataModel()
        user?._phoneNumber = userphoneNumber
        user?._email = useremail
        user?._userId = username123
       
        user?._questions = questionsLeft as NSNumber
        
        dynamoDBObjectMapper.save(user!).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
            
            
            } else {
               
            }
            return nil
        })
        
    }
    
    
    
    }


