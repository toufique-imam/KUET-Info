//
//  DatabaseM.swift
//  KuetBus
//
//  Created by Nuhash on 4/12/19.
//  Copyright © 2019 Main Uddin Chisty. All rights reserved.
//

import Foundation
import SQLite3
import os.log
class busdata {
	var remarks,starting_spot_time,starting_time_from_campus,tripname: String
	init(remarks: String,starting_spot_time:String,starting_time_from_campus:String,tripname:String){
		self.remarks = remarks;
		self.starting_spot_time = starting_spot_time;
		self.starting_time_from_campus = starting_time_from_campus;
		self.tripname = tripname;
	}
}
class phone {
	var NameDesignation,MobileNo : String;
	init(NameDesignation:String,MobileNo:String){
		self.NameDesignation = NameDesignation;
		self.MobileNo = MobileNo;
	}
}
class teachers {
	var name,weblink,designation,image,phone,mail,dept:String;
	init(name: String,weblink:String,designation:String,image:String,phone:String,mail:String,dept:String){
		self.name = name;
		self.weblink = weblink;
		self.designation = designation;
		self.image = image;
		self.phone = phone;
		self.mail = mail;
		self.dept = dept;
	}
	func contains_val(searchstr: String)->Bool {
		if(self.name.lowercased().contains(searchstr)){
			return true;
		}
		if(self.designation.lowercased().contains(searchstr)){
			return true;
		}
		if(self.phone.lowercased().contains(searchstr)){
			return true;
		}
		if(self.mail.lowercased().contains(searchstr)){
			return true;
		}
		if(self.dept.lowercased().contains(searchstr)){
			return true;
		}
		return false;
	}
}
class SqliteDbStore {
	let dbURL: URL
	let datatype: Int
	var db: OpaquePointer?
	
	var insertEntryStmt: OpaquePointer?
	var readEntryStmt: OpaquePointer?
	var updateEntryStmt: OpaquePointer?
	var deleteEntryStmt: OpaquePointer?
	
	let oslog = OSLog(subsystem: "sabertooth", category: "sqliteintegration")
	
	init(databasename:String){
		if(databasename == "BUSDATA"){
			datatype = 1;
		}
		else if(databasename == "TEACHERS"){
			datatype = 2;
		}
		else if(databasename == "PHONE"){
			datatype = 3;
		}
		else{
			datatype = 0;
		}
		do{
			do {
				dbURL = try FileManager.default
					.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
					.appendingPathComponent(databasename+".db")
				os_log("URL: %s", dbURL.absoluteString)
			} catch {
				os_log("Some error occurred. Returning empty path.")
				dbURL = URL(fileURLWithPath: "")
				return
			}
			try openDB()
			try createTables()
		} catch {
			os_log("Some error occurred. Returning.")
			return
		}
	}
	func openDB() throws {
		if sqlite3_open(dbURL.path, &db) != SQLITE_OK {
			os_log("error opening database at %s",log:oslog,type: .error,dbURL.absoluteString)
			throw SqliteError(message: "error opening database \(dbURL.absoluteString)")
		}
	}
	func deleteDB(dbURL: URL){
		os_log("removing db",log:oslog)
		do{
			try FileManager.default.removeItem(at: dbURL)
		}catch {
			os_log("exception while removing db %s",log:oslog,error.localizedDescription)
		}
	}
	func createTables() throws {
		if(datatype == 1){
			let ret =  sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS busdata (tripname TEXT NOT NULL,starting_time_from_campus TEXT NOT NULL, starting_spot_time TEXT NOT NULL,remarks TEXT)", nil, nil, nil)
			if (ret != SQLITE_OK){
				logDbErr("Error creating db table - Records")
				throw SqliteError(message: "unable to create table Records")
			}
		}
		else if(datatype == 2){
			let ret =  sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS teachers (name TEXT NOT NULL,weblink TEXT NOT NULL, designation TEXT NOT NULL,image TEXT,phone TEXT NOT NULL,mail TEXT NOT NULL,dept TEXT NOT NULL)", nil, nil, nil)
			if (ret != SQLITE_OK){
				logDbErr("Error creating db table - Records")
				throw SqliteError(message: "unable to create table Records")
			}
		}
		else if(datatype == 3){
			let ret =  sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS phone (NameDesignation TEXT NOT NULL,MobileNo TEXT NOT NULL)", nil, nil, nil)
			if (ret != SQLITE_OK){
				logDbErr("Error creating db table - Records")
				throw SqliteError(message: "unable to create table Records")
			}
		}
	}
	func logDbErr(_ msg: String){
		let errmsg = String(cString: sqlite3_errmsg(db))
		os_log("ERROR %s : %s", log: oslog, type: .error, msg, errmsg)
	}
}
class SqliteError : Error {
	var messeage = ""
	var error = SQLITE_ERROR
	init(message: String = ""){
		self.messeage = message;
	}
	init(error: Int32) {
		self.error = error
	}
}
