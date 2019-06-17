

import Foundation
import AWSDynamoDB
import AWSCognitoIdentityProvider
import UIKit
// this will be the main feed class showing the user data 
class UserDetailTableViewController : UIViewController {
    // attributes for the custome cell
    
    @IBOutlet weak var testing: UITextField!
   
    @IBOutlet var Table: UITableView!
    var response: AWSCognitoIdentityUserGetDetailsResponse?
    var user: AWSCognitoIdentityUser?
    var pool: AWSCognitoIdentityUserPool?
    var questiondata : Array<Phototext> = Array()
    
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        self.pool = AWSCognitoIdentityUserPool(forKey: AWSCognitoUserPoolsSignInProviderKey)
        if (self.user == nil) {
            self.user = self.pool?.currentUser()
            
        }
             // grabbing data from our aws table
        updateData()
        
        self.refresh()
       
        
    }
   
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
   
    @IBAction func Questions(_ sender: Any) {
        performSegue(withIdentifier: "ask", sender: self)
    }
    
    
    // MARK: - IBActions
    
    @IBAction func signOut(_ sender: AnyObject) {
        self.user?.signOut()
        self.title = nil
        self.response = nil
        self.refresh()
    }
    
    // reloads the prior view
    func refresh() {
        self.user?.getDetails().continueOnSuccessWith { (task) -> AnyObject? in
            DispatchQueue.main.async(execute: {
                self.response = task.result
                self.title = self.user?.username
                // saving the user name from the main menu 
                username123 = self.user?.username! ?? "broken"
            })
            return nil
        }
    
    
}
    
        
        
        
        
    }
    

extension UserDetailTableViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 100 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // returning the number of rows
        return questiondata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Questionpost", for: indexPath) as! QuestionCell
        
        cell.QuestionText.text = questiondata[indexPath.row]._noteId
        cell.Subject.text = questiondata[indexPath.row]._subject
        
        return cell
        
        
    }
    // function that calls to our aws dynamodb to grab data from the user and re update questions
    // the array list
    func updateData(){
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.limit = 20
        // testing to grabt the table data upon startup
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        dynamoDBObjectMapper.scan(Phototext.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
            if let error = task.error as NSError? {
                print("The request failed. Error: \(error)")
            } else if let paginatedOutput = task.result {
                // passes down an array of object
                for Photo in paginatedOutput.items as! [Phototext] {
                    // loading in the arraylist of objects
                    // adding the objects to an arraylist
                    self.questiondata.append(Photo)
                    
                    
                    
                    
                }
                
                DispatchQueue.main.async {
                    //code for updating the UI
                self.Table.reloadData()
                }
                
            }
            
            return ()
            
        })
    
        
        
}
    
}






