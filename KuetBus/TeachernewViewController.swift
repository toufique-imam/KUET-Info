//
//  TeachernewViewController.swift
//  KuetBus
//
//  Created by Nuhash on 7/12/19.
//  Copyright © 2019 Main Uddin Chisty. All rights reserved.
//

import UIKit
import SwiftyJSON

class TeachernewViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource,UISearchBarDelegate {
	

	@IBOutlet weak var myTableView: UITableView!
	@IBOutlet weak var search: UISearchBar!
	var searching = false;
	var searchstr = [String]()
	var filteredTeachers = Array<teachers>()
	var finaldata=Array<teachers>()
	var sqlitedb = SqliteDbStore(databasename: "TEACHERS");
	func getDataBus()
	{
		let headers = [
			"x-rapidapi-host": "kuet-teachers.p.rapidapi.com",
			"x-rapidapi-key": "ba038ea6d2mshd549857dcbf5602p1a12a5jsn7a54774039e6"
		]
		
		let request = NSMutableURLRequest(url: NSURL(string: "https://kuet-teachers.p.rapidapi.com/data/all")! as URL,
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
						let vdata = jsonstr?.data(using: .utf8)!
						do{
							let fjson = try JSON(data:vdata!);
							var tempara = Array<teachers>();
							var id = 0;
							for(deptx,dtx):(String,JSON) in fjson {
								for (_,dt):(String,JSON) in dtx {
									let temp = teachers(name: dt["name"].string!, weblink: dt["weblink"].string!, designation: dt["designation"].string!, image: dt["image"].string!, phone: dt["phone"].string!, mail: dt["mail"].string!, dept: deptx);
									tempara.append(temp);
									//break;
								}
							}
							self.finaldata = tempara;
							print(self.finaldata.count);
							group.leave()
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
			for teacher in self.finaldata {
				self.sqlitedb.create_teacher(record: teacher)
			}
			return;
		}
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if searching{
			return filteredTeachers.count
		}
		else{
			return finaldata.count
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell=tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
		if searching {
			let nowdata = filteredTeachers[indexPath.row]
			cell.textLabel?.text = nowdata.name
			cell.textLabel?.text = nowdata.phone
		}
		else{
			let nowData = finaldata[indexPath.row]
			cell.textLabel?.text=nowData.name
		}
		return cell
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		filteredTeachers = finaldata.filter({$0.name.lowercased().contains(searchText.lowercased())})
		searching = true;
		myTableView.reloadData()
	}
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searching = false;
		searchBar.text = "";
		myTableView.reloadData()
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		do{
			try self.finaldata = self.sqlitedb.readdata_teacher();
		}
		catch let error as NSError {
			print(error)
		}
		search.delegate = self;
		myTableView.dataSource=self
		myTableView.delegate=self
		
        // Do any additional setup after loading the view.
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
