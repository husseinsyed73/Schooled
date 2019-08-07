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
        self.accountSid = sendgridssid
        self.answerDescription = answerDescription
        //        self.authToken = ""
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //This method sends the photo as an sms text to the person
    func sendToPhone() {
        
        
        //Note replace + = %2B , for To and From phone number
        let fromNumber = "%2B13462585503"
        let toNumber = "%2B1" + self.phoneNumber
        let message = "The Schooled answer is in your email."
        
        // Build the request
        var request = NSMutableURLRequest(url: NSURL(string:"https://\(twilioSID):\(twilioSecret)@api.twilio.com/2010-04-01/Accounts/\(twilioSID)/SMS/Messages")! as URL)
        request.httpMethod = "POST"
        request.httpBody = "From=\(fromNumber)&To=\(toNumber)&Body=\(message)".data(using: String.Encoding.utf8)
        
        // Build the completion block and send the request
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            print("Finished")
            if let data = data, let responseDetails = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                // Success
                print("Response: \(responseDetails)")
            } else {
                // Failure
                print("Error: \(error)")
            }
        }).resume()
    
        
//        if let accountSID = ProcessInfo.processInfo.environment["TWILIO_ACCOUNT_SID"],
//            let authToken = ProcessInfo.processInfo.environment["TWILIO_AUTH_TOKEN"] {
//            print("in")
//            let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
//            let parameters = ["From": "3462585503", "To": phoneNumber, "Body": "Your Schooled question answer is: "]
//
//            Alamofire.request(url, method: .post, parameters: parameters)
//                .authenticate(user: accountSID, password: authToken)
//                .responseJSON { response in
//                    debugPrint(response)
//            }
//
//            RunLoop.main.run()
//        }
//
//        if let accountSID = ProcessInfo.processInfo.environment["TWILIO_ACCOUNT_SID"],
//            let authToken = ProcessInfo.processInfo.environment["TWILIO_AUTH_TOKEN"] {
//            print("in")
//            let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
//            let parameters = ["From": "3462585503", "To": phoneNumber, "Body": image] as [String : Any]
//
//            Alamofire.request(url, method: .post, parameters: parameters)
//                .authenticate(user: accountSID, password: authToken)
//                .responseJSON { response in
//                    debugPrint(response)
//            }
//
//            RunLoop.main.run()
//        }
//
//        if let accountSID = ProcessInfo.processInfo.environment["TWILIO_ACCOUNT_SID"],
//            let authToken = ProcessInfo.processInfo.environment["TWILIO_AUTH_TOKEN"] {
//            print("in")
//            let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
//            let parameters = ["From": "3462585503", "To": phoneNumber, "Body": self.answerDescription]
//
//            Alamofire.request(url, method: .post, parameters: parameters)
//                .authenticate(user: accountSID, password: authToken)
//                .responseJSON { response in
//                    debugPrint(response)
//            }
//
//            RunLoop.main.run()
//        }
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
//        session.authentication = Authentication.apiKey(myApiKey)
        Session.shared.authentication = Authentication.apiKey(myApiKey)
        let personalization = Personalization(recipients: self.email)
        let contents = Content.emailBody(
            plain: self.answerDescription,
            html: "<body>" + self.answerDescription + "</body>"
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

