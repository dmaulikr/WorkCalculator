//
//  DisplayRangedWorkdaysViewController.swift
//  WorkCalculator
//
//  Created by Loaner on 6/5/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import UIKit
import Firebase

class DisplayRangedWorkdaysViewController: UIViewController {
    
    
    //MARK: Outlets
    @IBOutlet var displayTextField: UITextView!
    
    
    //MARK: FIREBASE
    let ref = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser
    let rUser = User(authData: (FIRAuth.auth()?.currentUser)!)
    
    //MARK: Array of WorkDays
    var workDays = [WorkDay]()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    private func configureView(){
        workDays.sort(by: { $0.timestamp.dateValue?.compare($1.timestamp.dateValue!) == ComparisonResult.orderedAscending})
        displayTextField.text = ""
        self.title = (workDays.first?.timestamp.dateValue?.shortDescription)! + " - " + (workDays.last?.timestamp.dateValue?.shortDescription)!
        
        for day in workDays{
            displayTextField.text = displayTextField.text + "\n" + day.description
        }
        
        let (storeD, deliveryD) = WorkDay.totalDurations(arrayOfDays: workDays)
        
        displayTextField.text = displayTextField.text + "\n\n Store Total: \(storeD.minuteToHours) \n Delivery Total: \(deliveryD.minuteToHours)"
    }
    
    
    @IBAction func shareDidTouch(_ sender: Any) {
        // text to share
        let text = displayTextField.text
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.setValue("subject test", forKey: "subject")
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
   


}
