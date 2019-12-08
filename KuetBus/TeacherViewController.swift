//
//  TeacherViewController.swift
//  KuetBus
//
//  Created by Nuhash on 7/12/19.
//  Copyright © 2019 Main Uddin Chisty. All rights reserved.
//

import UIKit

import Foundation
import SwiftyJSON

class TeacherViewController: UIViewController {

	@IBOutlet weak var tableview: UITableView!
	@IBOutlet weak var searchFooter: SeachFooter!
	
	let searchContoller = UISearchController(searchResultsController: nil)
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
	
	override func viewDidLoad() {
        super.viewDidLoad()
		do{
			try self.finaldata = self.sqlitedb.readdata_teacher();
		}
		catch let error as NSError {
			print(error)
		}
		
		searchContoller.searchResultsUpdater = self
		
		searchContoller.obscuresBackgroundDuringPresentation = false
		
		searchContoller.searchBar.placeholder = "Search For Teacher"
		
		navigationItem.searchController = searchContoller
		
		definesPresentationContext = true;
		
		searchContoller.searchBar.delegate = self;
		
		let notificationCenter = NotificationCenter.default;
		
		notificationCenter.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification,
									   object: nil, queue: .main) {
										(notification) in self.handleKeyboard(notification: notification)}
		notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification,
									   object: nil, queue: .main) { (notification) in
										self.handleKeyboard(notification: notification)}
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let indexpath = tableview.indexPathForSelectedRow {
			tableview.deselectRow(at: indexpath, animated: true)
		}
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard
			segue.identifier == "ShowDetailSegue",
			let indexPath = tableview.indexPathForSelectedRow
		
		else {
			return
		}
		let nowdata : teachers;
		if isFiltering {
			nowdata = filteredTeachers[indexPath.row]
		}
		else {
			nowdata = finaldata[indexPath.row]
		}
	}
	var isSearchBarEmpty: Bool {
		return searchContoller.searchBar.text?.isEmpty ?? true
	}
	
	var isFiltering: Bool {
		let searchBarScopeIsFiltering = searchContoller.searchBar.selectedScopeButtonIndex != 0
		return searchContoller.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
	}
	
	func filterContentForSearchText(_ searchText: String) {
		filteredTeachers = finaldata.filter { (nowdata: teachers) -> Bool in
			let doesMatch = true;
			if isSearchBarEmpty {
				return doesMatch;
			}
			else{
				 return doesMatch && nowdata.name.lowercased().contains((searchText.lowercased()))
			}
		}
		print("DEBUG",filteredTeachers.count)
		tableview.reloadData()
	}
	func handleKeyboard(notification: Notification){
		guard notification.name == UIResponder.keyboardWillChangeFrameNotification else {
			//searchFooterBottomConstraint.constant = 0;
			view.layoutIfNeeded()
			return
		}
		guard
			let info = notification.userInfo,
			let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
		else {
				return
		}
		let keyboardHeight = keyboardFrame.cgRectValue.size.height
		UIView.animate(withDuration: 0.1, animations: {
			()->Void in
			self.view.layoutIfNeeded()
		})
	}
}

class newTeacherCell: UITableViewCell{
	@IBOutlet weak var name: UILabel!
}

extension TeacherViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView,
				   numberOfRowsInSection section: Int) -> Int {
		if isFiltering {
			searchFooter.setIsFilteringTOShow(filteredItemCount:
				filteredTeachers.count, of: finaldata.count)
			return filteredTeachers.count
		}
		
		searchFooter.setNotFiltering()
		return finaldata.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "techcellnew", for: indexPath) as! newTeacherCell
		let candy: teachers
		if isFiltering {
			candy = filteredTeachers[indexPath.row]
		} else {
			candy = finaldata[indexPath.row]
		}
		cell.name?.text = candy.name;
		return cell
	}
}

extension TeacherViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		let searchBar = searchController.searchBar
		filterContentForSearchText(searchBar.text!)
	}
}

extension TeacherViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
		filterContentForSearchText(searchBar.text!)
	}
}

