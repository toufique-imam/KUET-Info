//
//  TableViewController.swift
//  KuetBus
//
//  Created by Nuhash on 25/11/19.
//  Copyright © 2019 Main Uddin Chisty. All rights reserved.
//

import UIKit
import Foundation

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8,allowLossyConversion: false) else {return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
class teacherCell: UITableViewCell {
    
    @IBOutlet weak var mail: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var designation: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var weblink: UILabel!
}
class TableViewController: UITableViewController {
    var finaldata=Array<Dictionary<String,Any>>()
    func getDataBus()
    {
        
        let headers = [
            "x-rapidapi-host": "kuet-teachers.p.rapidapi.com",
            "x-rapidapi-key": "ba038ea6d2mshd549857dcbf5602p1a12a5jsn7a54774039e6"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://kuet-teachers.p.rapidapi.com/find/Dr")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let group = DispatchGroup();
        do{
            DispatchQueue.main.async {
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    group.enter();
                    if (error != nil) {
                        print(error)
                    } else {
                        let jsonstr = String(data: data!,encoding: .utf8)
                        //print(jsonstr)
                        let vdata = jsonstr?.data(using: .utf8)!
                        do {
                            let dict = jsonstr?.toJSON() as? [Dictionary<String,Any>]
                            self.finaldata = dict!;
                        }catch let error as NSError {
                            print(error)
                        }
                    }
                })
                dataTask.resume();
            }}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.getDataBus();
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3)
        {
            self.tableView.reloadData()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.finaldata.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherCell", for: indexPath) as! teacherCell
        let datanow = self.finaldata[indexPath.row]
        cell.designation?.text = (datanow["designation"]) as? String
        cell.mail?.text = (datanow["mail"]) as? String
        cell.name?.text = (datanow["name"]) as? String
        cell.phone?.text = (datanow["phone"]) as? String
        cell.weblink?.text = (datanow["weblink"]) as? String
        //cell.teacherimage
        // Configure the cell...

        return cell
    }
/*
     let cell = tableView.dequeueReusableCell(withIdentifier: "BusDataCell", for: indexPath) as! BusCellClass
     //cell.Tripname!.Text="nice"
     // Configure the cell..
     let datanow = self.finaldata[indexPath.row]
     //print(datanow);
     cell.Campus?.text = (datanow["StartingTimefromCampus"] as! String)
     cell.Tripname?.text = (datanow["TripName"] as! String)
     cell.Spot?.text = (datanow["StartingSpotTime"] as! String)
     cell.Remarks?.text = (datanow["Remarks"] as! String)
     return cell
     */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
