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
	//@IBOutlet weak var Remarks: UITextField!
	@IBOutlet weak var Remarks: UILabel!
}
class busTableViewController: UITableViewController {
	var finaldata=Array< busdata >()
	var sqlitedb = SqliteDbStore(databasename: "BUSDATA")
	func getDataBus()
	{
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
							var tempara = Array<busdata>();
							for (_,dt):(String,JSON) in fjson {
								let temp = busdata(remarks: dt["Remarks"].string!, starting_spot_time: dt["StartingSpotTime"].string!, starting_time_from_campus: dt["StartingTimefromCampus"].string!, tripname: dt["TripName"].string!);
								tempara.append(temp);
							}
							self.finaldata = tempara;
							group.leave()
							//return
						}
						catch let error as NSError{
							print(error)
							exit(-1)
						}
					}
				})
				dataTask.resume();
			}}
	}
	func updatedata() {
		DispatchQueue.main.async {
			self.getDataBus()
		}
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+10)
		{
			print(self.finaldata.count)
			self.sqlitedb.delete();
			for busdata in self.finaldata {
				self.sqlitedb.create_bus(record: busdata)
			}
			self.tableView.reloadData()
			return;
		}
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		
		do{
			try self.finaldata = self.sqlitedb.readdata_bus();
			if(self.finaldata.count == 0){
				self.updatedata();
			}
		}
		catch let error as NSError {
			print(error)
			self.updatedata();
		}
		/*
		DispatchQueue.main.async {
			self.updatedata()
		}
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+10)
		{
			do{
				try self.finaldata = self.sqlitedb.readdata_bus();
				self.tableView.reloadData()
			}
			catch let error as NSError {
				print(error)
			}
		}*/
	}
	
	
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		print(self.finaldata.count)
		return self.finaldata.count
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "BusDataCell", for: indexPath) as! BusCellClass
		let datanow = self.finaldata[indexPath.row]
		cell.Campus?.text = (datanow.starting_time_from_campus)
		cell.Tripname?.text = (datanow.tripname)
		cell.Spot?.text = (datanow.starting_spot_time)
		cell.Remarks?.text = (datanow.remarks)
		cell.Remarks?.sizeToFit()
		//cell.Campus?.text = "KUET";
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

