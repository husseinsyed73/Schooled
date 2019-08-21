

import Foundation
import AWSDynamoDB
import AWSCognitoIdentityProvider
import UIKit
// this will be the main feed class showing the user data 
class UserDetailTableViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // attributes for the custome cell
    
    @IBOutlet weak var testing: UITextField!
    // refresh control object
    private let refreshControl = UIRefreshControl();
    var activity: UIActivityIndicatorView = UIActivityIndicatorView()
   
    @IBOutlet var Table: UITableView!
    var response: AWSCognitoIdentityUserGetDetailsResponse?
    var user: AWSCognitoIdentityUser?
    var pool: AWSCognitoIdentityUserPool?
    var questiondata : Array<Phototext> = Array()    
    var menuButton: UIBarButtonItem = UIBarButtonItem()
    var clicked: Phototext? = nil
    @IBOutlet weak var subjectPickerField: UITextField!
    var pickerData: [String] = ["All Subjects", "Calculus M408C", "Calculus M408D", "Statistics SDS 321", "Probability M326K", "Computer Architecture CS 429", "Introduction to Computing Systems EE 306", "Introduction to Embedded Systems EE319K"]
    var picker = UIPickerView()
    var toolbar = UIToolbar()
    var allData : Array<Phototext> = Array()
    var picked = "All Subjects"
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        //table color
//        self.tableView
        // creating the refresh control object
        // adding the loading icon
        self.activity.center = self.view.center
        self.activity.hidesWhenStopped = true
        self.activity.style = UIActivityIndicatorView.Style.gray;
        self.activity.color = UIColor.black
        let transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        self.activity.transform = transform
        
        view.addSubview(activity);
        //create the menuButton and the gesture to pull the menu
        if self.revealViewController() != nil {
            //initialize the menuButton
            menuButton = UIBarButtonItem.init(title: "Menu", style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            
            //set the leftBarButtonItem to the MenuButton
            navigationItem.leftBarButtonItem = menuButton
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            revealViewController()?.rearViewRevealWidth = 250
        }
        
        refreshControl.addTarget(self, action: #selector(self.handleTopRefresh(_:)), for: .valueChanged )
        
        self.pool = AWSCognitoIdentityUserPool(forKey: AWSCognitoUserPoolsSignInProviderKey)
        if (self.user == nil) {
            self.user = self.pool?.currentUser()
            
        }
             // grabbing data from our aws table
        updateData()
        
        // if ios is availble enable refresh control
        if #available(iOS 10.0, *) {
            self.Table.refreshControl = refreshControl
        } else {
           
            self.Table.addSubview(refreshControl)
            // creating the ui refreshcontrol object 
           
            
            
            
        }
        
        self.refresh()
       
        //set up the picker for the filter
        picker.delegate = self
        subjectPickerField.inputView = picker
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        toolbar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        toolbar.isUserInteractionEnabled = true
        self.subjectPickerField.inputAccessoryView = toolbar
        self.subjectPickerField.text = "Select Subjects"
        
    }
    
    //close the picker view when this is pressed
    @objc func onDoneButtonTapped() {
        toolbar.removeFromSuperview()
        picker.removeFromSuperview()
        subjectPickerField.endEditing(true)
    }
    
    // Configure Refresh Control
    @objc func handleTopRefresh(_ sender:UIRefreshControl){
      self.updateData()
        
        
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
        if(userLoaded == false){
         // grab all the data from the user information
            UIApplication.shared.beginIgnoringInteractionEvents();
            self.activity.startAnimating()
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
            dynamoDBObjectMapper.load(UserDataModel.self, hashKey: username123, rangeKey:nil).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
                if let error = task.error as? NSError {
                    print("The request failed. Error: \(error)")
                    // alert lack of connection to server
                    
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.activity.stopAnimating()
                    let alertController = UIAlertController(title: "ALERT", message:
                        "Questions cannot be posted at this time please check your internet connection ", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                    
                    self.present(alertController, animated: true, completion: nil)                } else if let result = task.result as? UserDataModel {
                    // Do something with task.result.
                    questionsLeft = result._questions as! Int
                    userphoneNumber = result._phoneNumber!
                    useremail = result._email!
                
                    userLoaded = true
                    if(questionsLeft == 0){
                        DispatchQueue.main.async {
                        
                        UIApplication.shared.endIgnoringInteractionEvents()
                        self.activity.stopAnimating()
                        let alertController = UIAlertController(title: "ALERT", message:
                            "You have no question tokens left, please answer a question to get more", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                        
                        self.present(alertController, animated: true, completion: nil)
                        }
                    }else{
                        DispatchQueue.main.async {
                            UIApplication.shared.endIgnoringInteractionEvents()
                            self.activity.stopAnimating()
                            self.performSegue(withIdentifier: "ask", sender: self)
                        }
                        
                    }
                }
                return nil
            })
        
        
        }else{
            if(questionsLeft != 0){
                DispatchQueue.main.async{
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.activity.stopAnimating()
                    self.performSegue(withIdentifier: "ask", sender: self)
                }
                
            }
            else {
                let alertController = UIAlertController(title: "ALERT", message:
                    "You have no question tokens left, please answer a question to get more", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
                
            }
        }
    }
    
    
    // MARK: - IBActions
    
    @IBAction func signOut(_ sender: AnyObject) {
        self.user?.signOut()
        self.title = nil
        self.response = nil
        // user data needs to be loaded again
        userLoaded = false
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
    
    //Sends the data of the clicked question to the ViewQuestionViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ViewQuestionViewController {
            let vc = segue.destination as? ViewQuestionViewController
            vc?.currentQuestionData = clicked
        }
    }
    
    //number of columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //number of rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //returns what the user is currently on
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    //what the user has selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //set the field to whatever they pick
        subjectPickerField.text = pickerData[row]
        //get the picked
        picked = pickerData[row]
        //display all if they pick all subjects
        if(picked == "All Subjects"){
            questiondata.removeAll()
            for data in allData{
                questiondata.append(data)
            }
            self.Table.reloadData()
            //else only display the ones they picked
        } else {
            questiondata.removeAll()
            for data in allData {
               
                if(data._subject == picked){
                    questiondata.append(data)
                }
            }
            
            self.Table.reloadData()
        }
        
    }
        
        
        
        
    }
    

extension UserDetailTableViewController: UITableViewDataSource, UITableViewDelegate{
    
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 65 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // returning the number of rows
        return questiondata.count
    }
    // cell click stuff
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Questionpost", for: indexPath) as! QuestionCell
        
        cell.QuestionText.text = questiondata[indexPath.row]._summary
        cell.QuestionText.isEditable = false
        cell.QuestionText.isSelectable = true
        cell.QuestionText.isUserInteractionEnabled = false
        // grabbing the summary of each question 
        cell.Subject.text = questiondata[indexPath.row]._subject
        
        cell.Subject.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        cell.Subject.isUserInteractionEnabled = false
        
        return cell
        
        
    }
    // function that calls to our aws dynamodb to grab data from the user and re update questions
    // the array list
    func updateData(){
        let scanExpression = AWSDynamoDBScanExpression()
        //scanExpression.limit = 20
        // testing to grabt the table data upon startup
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        dynamoDBObjectMapper.scan(Phototext.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
            if let error = task.error as NSError? {
                print("The request failed. Error: \(error)")
            } else if let paginatedOutput = task.result {
                // clearing the data for the new data
                self.questiondata.removeAll()
                self.allData.removeAll();
                // passes down an array of object
                for Photo in paginatedOutput.items as! [Phototext] {
                    // loading in the arraylist of objects
                    // adding the objects to an arraylist
                   // self.questiondata.append(Photo)
                    
                    self.allData.append(Photo)
                    
                    
                }
                print(self.allData.capacity)
                if(self.picked == "All Subjects"){
                    self.questiondata.removeAll()
                    for data in self.allData{
                       self.questiondata.append(data)
                    }
                   
                    //else only display the ones they picked
                } else {
                    self.questiondata.removeAll()
                    for data in self.allData {
                       
                        if(data._subject == self.picked){
                            self.questiondata.append(data)
                        }
                    }
                    
                   
                }
                // reload based on what the picker is set on
                
                DispatchQueue.main.async {
                    self.Table.reloadData();
                    self.refreshControl.endRefreshing()
                }
                
                
                
            }
            
            return ()
            
        })
        
}
    // making the text view unresponsive
    
    //Performs the segue to answer and view the question
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.clicked = questiondata[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "viewQuestion", sender: self)
    }
    
   
    
}
    








