//
//  MenuViewController.swift
//  Schooled
//
//  Created by Omar Dadabhoy on 6/20/19.
//  Copyright © 2019 Hussein  Syed. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //This programs the settings button and brings the user to settings
    @IBAction func goToSettings(_ sender: Any) {
        self.performSegue(withIdentifier: "goToSettings", sender: self)
    }
    
    
    @IBAction func goToProfile(_ sender: Any) {
        self.performSegue(withIdentifier: "goToProfile", sender: self)
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
