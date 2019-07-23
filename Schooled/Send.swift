//
//  Send.swift
//  Schooled
//
//  Created by Omar Dadabhoy on 5/29/19.
//  Copyright © 2019 Hussein  Syed. All rights reserved.
//
/* This class takes in a phone number email and an image. The class has two main functions sendEmail and sendToPhone
 * which when called they each send the image to the inputed phone number and email.
 */

import Foundation
import PhotosUI
import Alamofire
import MessageUI
import SendGrid

class Send: UIViewController, MFMailComposeViewControllerDelegate {
    
    private var image: UIImage
    private var phoneNumber: String
    private var email: String
    private var answerDescription: String
    private let accountSid: String
    //    private let authToken: String
    
    //initializer forces you to pass in an image a phone number and an email which will
    //be used to send the image to the phonenumber and the email
    init(image: UIImage, phoneNumber: String, email: String, answerDescription: String) {
        self.image = image
        self.email = email
        self.phoneNumber = phoneNumber
        self.accountSid = "AC45c1dfece8ac6d4ee3c5d74760de388d"
        self.answerDescription = answerDescription
        //        self.authToken = ""
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //This method sends the photo as an sms text to the person
    func sendToPhone() {
        //send them an intro
        if let accountSID = ProcessInfo.processInfo.environment["TWILIO_ACCOUNT_SID"],
            let authToken = ProcessInfo.processInfo.environment["TWILIO_AUTH_TOKEN"]{
            let URL = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
            //Array contains the from to and the image we need to send
            let parameters = ["From": "3462585503", "To": phoneNumber, "Body": "Your Schooled questin answer is: "] as [String : String]
            //Use Alamofire in order to use the API and send the message
            Alamofire.request(URL, method: .post, parameters: parameters)
                .authenticate(user: accountSID, password: authToken)
                .responseJSON { response in
                    debugPrint(response)
            }
            RunLoop.main.run()
        }
        
        //Use the accountSID, authToken, and URL in order to use the API to send the message in a photo
        if let accountSID = ProcessInfo.processInfo.environment["TWILIO_ACCOUNT_SID"],
            let authToken = ProcessInfo.processInfo.environment["TWILIO_AUTH_TOKEN"]{
            let URL = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
            //Array contains the from to and the image we need to send
            let parameters = ["From": "3462585503", "To": phoneNumber, "Body": image] as [String : Any]
            //Use Alamofire in order to use the API and send the message
            Alamofire.request(URL, method: .post, parameters: parameters)
                .authenticate(user: accountSID, password: authToken)
                .responseJSON { response in
                    debugPrint(response)
            }
            RunLoop.main.run()
        }
        
        //send the description next
        if let accountSID = ProcessInfo.processInfo.environment["TWILIO_ACCOUNT_SID"],
            let authToken = ProcessInfo.processInfo.environment["TWILIO_AUTH_TOKEN"]{
            let URL = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
            //Array contains the from to and the image we need to send
            let parameters = ["From": "3462585503", "To": phoneNumber, "Body": answerDescription] as [String : String]
            //Use Alamofire in order to use the API and send the message
            Alamofire.request(URL, method: .post, parameters: parameters)
                .authenticate(user: accountSID, password: authToken)
                .responseJSON { response in
                    debugPrint(response)
            }
            RunLoop.main.run()
        }
    }
    
    //This method sends the photo to the email of the user
    func sendEmail(){
        sendWithSendGrid()
//        //only enter this if it is possible to send mail with the device
//        if MFMailComposeViewController.canSendMail(){
//            //Create the mail object
//            let mail = MFMailComposeViewController()
//            mail.mailComposeDelegate = self
//            //create an array with the person's email
//            let receipient = [email]
//            //set the receipients to the person's email
//            mail.setToRecipients(receipient)
//            //set the subject
//            mail.setSubject("Attached is the photo and description for the problem you requested")
//            //Create a data version of the image
//            guard let imageData = image.pngData() else {return}
//            //add the description in
//            mail.setMessageBody(answerDescription, isHTML: false)
//            //attach the image as a png to the file
//            mail.addAttachmentData(imageData, mimeType: "png", fileName: "image")
//            //let the user know that the email has been sent
//            present(mail, animated: true)
//        } else {
//            //show the alert
//            self.showSendMailAlert()
//        }
    }
    
    //
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    //shows an error if it impossible to send an email through the phone
    private func showSendMailAlert() {
        //set the error
        let sendMailErrorAlert = UIAlertView(title: "Could not send email", message: "Your device was unable to send the email check the email configuration and try again", delegate: self, cancelButtonTitle: "Ok")
        //display it on the screen
        sendMailErrorAlert.show()
    }
    
    //sends email with send grid
    private func sendWithSendGrid() {
        let session = Session()
        //        guard let myApiKey = ProcessInfo.processInfo.environment["SG_API_KEY"] else {
        //            print("Unable to retrieve API key")
        //            return
        //        }
        let myApiKey = "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"
//        session.authentication = Authentication.apiKey(myApiKey)
        Session.shared.authentication = Authentication.apiKey(myApiKey)
        let personalization = Personalization(recipients: self.email)
        let contents = Content.emailBody(
            plain: self.answerDescription,
            html: "<h1>" + self.answerDescription + "</h1>"
        )
        let email = Email(
            personalizations: [personalization],
            from: "no-reply@Schooled.com",
            content: contents,
            subject: "Schooled Answer"
        )
        do {
            let dataImage: Data = self.image.pngData()!
            let attachment = Attachment(
                filename: "answer.png",
                content: dataImage,
                disposition: .attachment,
                type: .png,
                contentID: nil
            )
            email.parameters?.attachments = [attachment]
            try Session.shared.send(request: email) { (result) in
                switch result {
                case .success(let response):
                    print(response.statusCode)
                case .failure(let err):
                    print(err)
                }
            }
        } catch {
            print(error)
        }
    }
    
}

