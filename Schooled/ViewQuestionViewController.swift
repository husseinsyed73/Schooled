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

    @IBOutlet weak var topicTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionField: UITextView!
    var currentQuestionData: Phototext? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        topicTextField.text! = currentQuestionData!._subject!
        topicTextField.isUserInteractionEnabled = false
        descriptionField.text! = currentQuestionData!._summary!
        descriptionField.isUserInteractionEnabled = false
        getPicture()
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
            })
            
        }
    }
    
//    //This gets the picture of the question to show in the view controller
//    func getPicture(){
//        let downloadedFile = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("test.png")
//        let transferManager = AWSS3TransferManager.default()
//        if let downloadRequest = AWSS3TransferManagerDownloadRequest(){
//            downloadRequest.bucket = bucket
//            downloadRequest.key = currentQuestionData?._userId!
//            downloadRequest.downloadingFileURL = downloadedFile
//                transferManager.download(downloadRequest).continueWith(block: { (task: AWSTask<AnyObject>) -> Any? in
//                    if( task.error != nil){
//                        print(task.error!.localizedDescription)
//                        print(self.currentQuestionData!._userId)
//                        return nil
//                    }
//
//                    print(task.result!)
//
//                    if let data = NSData(contentsOf: downloadedFile){
//                        print("getting image")
//                        DispatchQueue.main.async(execute: { () -> Void in
//                            self.imageView.image = UIImage(data: data as Data)
//                        })
//                    }
//                    return nil
//                })
//        }
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
