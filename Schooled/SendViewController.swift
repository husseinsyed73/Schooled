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
class SendViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var choosePic: UIButton!
    var imagePicker = UIImagePickerController()
    var text = ""
    
    @IBOutlet weak var Summary: UITextField!
   
    @IBOutlet weak var Questiondirections: UITextView!
    
    
    var localPath: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
    }
    //This function adds a photo into the UIImageView to be sent
    @IBAction func addPhoto(_ sender: Any) {
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
        }
        dismiss(animated: true, completion: nil)
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
        guard let image = imageView.image else {return}
        let data = image.pngData()
        let remoteName = "test.png"
        self.text = self.Questiondirections.text!
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(remoteName)
        do {
            try data?.write(to: fileURL)
            localPath = fileURL
            let uploadRequest = AWSS3TransferManagerUploadRequest()
            uploadRequest?.body = fileURL
            // no point of folder because storing all of the photos
            // username dash and the time for splitting up the data
            var keydata = username123;
            keydata = keydata + "-";
            keydata = keydata + String(Int64(Date().timeIntervalSince1970 * 1000));
            keydata = keydata + ".png"
            // reason still png because we have to move it into the dynamo db the same
            var textkey = username123;
            textkey = textkey + "-";
            textkey = textkey + String(Int64(Date().timeIntervalSince1970 * 1000));
            textkey = textkey + ".png"
            
            uploadRequest?.key = keydata
            
            // sending over the bucket name and the type
            // name scheme being
            // lets en
            uploadRequest?.bucket = bucket
            uploadRequest?.contentType = "image/png"
            
            let transferManager = AWSS3TransferManager.default()
            
            transferManager.upload(uploadRequest!).continueWith { (task) -> AnyObject? in
                if let error = task.error {
                    print("Upload failed (\(error))")
                }
                // once we return lets now upload the text to the s3 server also
                sendText(key:textkey);
                return nil
            }
        }
        catch {
            print("File not save failed")
        }
       
        
        
        func sendText(key:String){
            // now sending the text
            let photoadder = Phototext();
            // creating the user object
            photoadder?._userId = key;
            photoadder?._noteId = text;
            // adding a subject to be displayed to the user 
            photoadder?._subject = "data structures"
            
            photoadder?._summary = self.Summary.text
           
            // crendtials for aws access not the user model
            let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
            
            dynamoDBObjectMapper.save(photoadder!).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
                // taking it off the main ui thread
                
                
                if let error = task.error as NSError? {
                    print("The request failed. Error: \(error)")
                } else {
                    // Do something with task.result or perform other operations.
                    DispatchQueue.main.async {
                         self.navigationController?.popViewController(animated: true)
                        
                    }
                   
                    
                }
                
                return nil
            })
        }
    
    
    }
}

