//
//  TestingScreenController.swift
//  firebase testing database
//
//  Created by Dakota Brown on 11/14/18.
//  Copyright © 2018 Dakota Brown. All rights reserved.
//

import UIKit
import Firebase

class TestingScreenController: UIViewController {
    
    var docRef: DocumentReference!
    var quoteListener: ListenerRegistration!
    
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var quoteText: UITextField!
    @IBOutlet weak var author: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        docRef = Firestore.firestore().document("sampleData/inspiration")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       quoteListener = docRef.addSnapshotListener { (docSnapshot, error) in
            let myData = docSnapshot?.data()
            let latestQuote = myData?["quote"] as? String ?? ""
            let quoteAuthor = myData?["author"] as? String ?? "(none)"
            self.quoteLabel.text = "\"\(latestQuote)\" -- \(quoteAuthor)"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        quoteListener.remove()
    }
    @IBAction func buttonTapped(_ sender: Any) {
        guard let quoteText = quoteText.text, !quoteText.isEmpty else { return }
        guard let quoteAuthor = author.text, !quoteAuthor.isEmpty else { return }
        let dataSave: [String: Any] = ["quote": quoteText, "author": quoteAuthor ]
        docRef.setData(dataSave) { (error) in
            if let error = error {
                print("got error \(error.localizedDescription)")
            } else {
                print("Data saved")
            }
        }
    }
}
