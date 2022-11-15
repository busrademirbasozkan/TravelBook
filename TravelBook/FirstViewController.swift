//
//  FirstViewController.swift
//  TravelBook
//
//  Created by Büşra Özkan on 15.11.2022.
//

import UIKit
import CoreData

class FirstViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UIBarbutton
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(barButton))

        
    }
    
    //BarButton Func
    @objc func barButton(){
        performSegue(withIdentifier: "toVC", sender: nil)
    }
    

    //TableView ayarları
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "test"
        return cell
    }

}
