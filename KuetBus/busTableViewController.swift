//
//  busTableViewController.swift
//  KuetBus
//
//  Created by Main Uddin Chisty on 23/11/19.
//  Copyright © 2019 Main Uddin Chisty. All rights reserved.
//

import UIKit
import Foundation
import SQLite3
import os.log
import SwiftyJSON

class BusCellClass: UITableViewCell{
	@IBOutlet weak var Tripname: UILabel!
	@IBOutlet weak var Campus: UILabel!
	@IBOutlet weak var Spot: UILabel!
	@IBOutlet weak var Remarks: UILabel!
}
class busTableViewController: UITableViewController {
	var finaldata=Array< Dictionary<String,Any> >()
	
	func getDataBus()
	{
		//var fresx = Array<Any>();
		let group = DispatchGroup();
		let headers = [
			"x-rapidapi-host": "kuet_bus.p.rapidapi.com",
			"x-rapidapi-key": "f78c624b37msh362a396b6bcee62p1843fcjsnbc034ed87c41"
		]
		
		let request = NSMutableURLRequest(url: NSURL(string: "https://kuet_bus.p.rapidapi.com/bus")! as URL,
										  cachePolicy: .useProtocolCachePolicy,
										  timeoutInterval: 10.0)
		request.httpMethod = "GET"
		request.allHTTPHeaderFields = headers
		
		let session = URLSession.shared
		do{
			DispatchQueue.main.async {
				let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
					group.enter();
					if (error != nil) {
						print(error)
					} else {
						let jsonstr = String(data: data!,encoding: .utf8)
						print(jsonstr)
						let vdata = jsonstr?.data(using: .utf8)!
						do{
							let fjson = try JSON(data:vdata!);
						}
						catch {
							
						}
						
						/*                       do {
						if let jsonara = try JSONSerialization.jsonObject(with: vdata!, options: .allowFragments) as? [Dictionary<String,Any>]
						{
						self.finaldata =  jsonara;
						print(jsonara.count)
						group.leave();
						
						}
						else
						{
						print("bad json")
						}
						}catch let error as NSError {
						print(error)
						}*/
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
		// self.navigationItem.rightBarButtonItem = self.editButtonItem
	}
	
	// MARK: - Table view data source
	
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		//var i=0;
		//while(i<self.finaldata.count)
		//{
		//    print(self.finaldata[i])
		//    i=i+1;
		//}
		return self.finaldata.count
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
	}
	
	
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

