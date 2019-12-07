//
//  DatabaseCRUD.swift
//  KuetBus
//
//  Created by Nuhash on 4/12/19.
//  Copyright © 2019 Main Uddin Chisty. All rights reserved.
//

import Foundation
import SQLite3

extension SqliteDbStore{
	//INSERT INTO busdata (tripname,starting_time_from_campus,starting_spot_time,remarks) values (?,?,?,?)"
	func create_bus (record: busdata){
		guard self.prepareInsertEntryStmt() == SQLITE_OK else { return }
		defer {
			sqlite3_reset(self.insertEntryStmt)
		}
		if(datatype==1){
			if sqlite3_bind_text(self.insertEntryStmt, 1, (record.tripname as NSString).utf8String, -1, nil) != SQLITE_OK
			{
				logDbErr("sqlite3_bind_text(insertEntryStmt)")
				return
			}
			if sqlite3_bind_text(self.insertEntryStmt, 2, (record.starting_time_from_campus as NSString).utf8String, -1, nil) != SQLITE_OK
			{
				logDbErr("sqlite3_bind_text(insertEntryStmt)")
				return
			}
			if sqlite3_bind_text(self.insertEntryStmt, 3, (record.starting_spot_time as NSString).utf8String, -1, nil) != SQLITE_OK
			{
				logDbErr("sqlite3_bind_text(insertEntryStmt)")
				return
			}
			if sqlite3_bind_text(self.insertEntryStmt, 4, (record.remarks as NSString).utf8String, -1, nil) != SQLITE_OK
			{
				logDbErr("sqlite3_bind_text(insertEntryStmt)")
				return
			}
			let r = sqlite3_step(self.insertEntryStmt)
			if r != SQLITE_DONE {
				logDbErr("sqlite3_step(insertEntryStmt) \(r)")
				return
			}
		}
		else{
			return;
		}
	}
	func create_teacher (record: teachers){
		//INSERT INTO teachers (name,weblink,designation,image,phone,mail,dept) values (?,?,?,?,?,?,?)
		guard self.prepareInsertEntryStmt() == SQLITE_OK else { return }
		defer {
			sqlite3_reset(self.insertEntryStmt)
		}
		if(datatype==2){
			if sqlite3_bind_text(self.insertEntryStmt, 1, (record.name as NSString).utf8String, -1, nil) != SQLITE_OK
			{
				logDbErr("sqlite3_bind_text(insertEntryStmt)")
				return
			}
			if sqlite3_bind_text(self.insertEntryStmt, 2, (record.weblink as NSString).utf8String, -1, nil) != SQLITE_OK
			{
				logDbErr("sqlite3_bind_text(insertEntryStmt)")
				return
			}
			if sqlite3_bind_text(self.insertEntryStmt, 3, (record.designation as NSString).utf8String, -1, nil) != SQLITE_OK
			{
				logDbErr("sqlite3_bind_text(insertEntryStmt)")
				return
			}
			if sqlite3_bind_text(self.insertEntryStmt, 4, (record.image as NSString).utf8String, -1, nil) != SQLITE_OK
			{
				logDbErr("sqlite3_bind_text(insertEntryStmt)")
				return
			}
			if sqlite3_bind_text(self.insertEntryStmt, 5, (record.phone as NSString).utf8String, -1, nil) != SQLITE_OK
			{
				logDbErr("sqlite3_bind_text(insertEntryStmt)")
				return
			}
			if sqlite3_bind_text(self.insertEntryStmt, 6, (record.mail as NSString).utf8String, -1, nil) != SQLITE_OK
			{
				logDbErr("sqlite3_bind_text(insertEntryStmt)")
				return
			}
			if sqlite3_bind_text(self.insertEntryStmt, 7, (record.mail as NSString).utf8String, -1, nil) != SQLITE_OK
			{
				logDbErr("sqlite3_bind_text(insertEntryStmt)")
				return
			}
			let r = sqlite3_step(self.insertEntryStmt)
			if r != SQLITE_DONE {
				logDbErr("sqlite3_step(insertEntryStmt) \(r)")
				return
			}
		}
		else{
			return;
		}
	}
	func create_phone (record: phone){
		//INSERT INTO phone (NameDesignation,MobileNo) values (?,?)
		guard self.prepareInsertEntryStmt() == SQLITE_OK else { return }
		defer {
			sqlite3_reset(self.insertEntryStmt)
		}
		if(datatype==1){
			if sqlite3_bind_text(self.insertEntryStmt, 1, (record.NameDesignation as NSString).utf8String, -1, nil) != SQLITE_OK
			{
				logDbErr("sqlite3_bind_text(insertEntryStmt)")
				return
			}
			if sqlite3_bind_text(self.insertEntryStmt, 2, (record.MobileNo as NSString).utf8String, -1, nil) != SQLITE_OK
			{
				logDbErr("sqlite3_bind_text(insertEntryStmt)")
				return
			}
			let r = sqlite3_step(self.insertEntryStmt)
			if r != SQLITE_DONE {
				logDbErr("sqlite3_step(insertEntryStmt) \(r)")
				return
			}
		}
		else{
			return;
		}
	}
	func delete(){
		guard self.prepareDeleteEntryStmt() == SQLITE_OK else { return }
		defer {
			sqlite3_reset(self.deleteEntryStmt);
		}
		let r = sqlite3_step(self.deleteEntryStmt)
		if r != SQLITE_DONE {
			logDbErr("sqlite3_step_deleteEntryStmt\n")
			return
		}
	}
	func readdata_bus() throws ->Array<busdata> {
		var res = Array<busdata>()
		guard self.prepareReadEntryStmt() == SQLITE_OK else {
			return res
		}
		defer {
			sqlite3_reset(self.readEntryStmt)
		}
		var r = sqlite3_step(self.readEntryStmt)
		if r != SQLITE_ROW {
			logDbErr("read error\n")
			return res;
		}
		while r == SQLITE_ROW {
			//CREATE TABLE IF NOT EXISTS busdata (tripname TEXT NOT NULL,starting_time_from_campus TEXT NOT NULL, starting_spot_time TEXT NOT NULL,remarks TEXT
			let tripname = String(cString: sqlite3_column_text(self.readEntryStmt, 0)!)
			let st_time_campus = String(cString: sqlite3_column_text(self.readEntryStmt, 1)!)
			let st_time_spot = String(cString: sqlite3_column_text(self.readEntryStmt, 2)!)
			let remarks = String(cString: sqlite3_column_text(self.readEntryStmt, 3)!)
			let nowdata = busdata(remarks: remarks, starting_spot_time: st_time_spot, starting_time_from_campus: st_time_campus, tripname: tripname)
			res.append(nowdata)
			r = sqlite3_step(self.readEntryStmt)
		}
		return res
	}
	func readdata_teacher() throws -> Array<teachers> {
		var res = Array<teachers>()
		guard self.prepareReadEntryStmt() == SQLITE_OK else { return res  }
		defer {
			sqlite3_reset(self.readEntryStmt)
		}
		var r = sqlite3_step(self.readEntryStmt)
		if(r != SQLITE_ROW) {
			logDbErr("read error\n");
			return res;
		}
		while( r == SQLITE_ROW ) {
			//CREATE TABLE IF NOT EXISTS teachers (name TEXT NOT NULL,weblink TEXT NOT NULL, designation TEXT NOT NULL,image TEXT,phone TEXT NOT NULL,mail TEXT NOT NULL,dept TEXT NOT NULL)
			let name = String(cString: sqlite3_column_text(self.readEntryStmt, 0)!);
			let weblink = String(cString: sqlite3_column_text(self.readEntryStmt, 1)!);
			let designation = String(cString: sqlite3_column_text(self.readEntryStmt, 2)!);
			let image = String(cString: sqlite3_column_text(self.readEntryStmt, 3)!);
			let phone = String(cString: sqlite3_column_text(self.readEntryStmt, 4)!);
			let mail = String(cString: sqlite3_column_text(self.readEntryStmt, 5)!);
			let dept = String(cString: sqlite3_column_text(self.readEntryStmt, 6)!);
			print(name,weblink,designation,image,phone,mail,dept)
			let nowdata = teachers(name: name, weblink: weblink, designation: designation, image: image, phone: phone, mail: mail, dept: dept)
			res.append(nowdata)
			r = sqlite3_step(self.readEntryStmt);
		}
		print(res.count)
		return res;
	}
	func prepareInsertEntryStmt()->Int32 {
		guard insertEntryStmt == nil else { return SQLITE_OK }
		if(datatype == 1){
			let sql = "INSERT INTO busdata (tripname,starting_time_from_campus,starting_spot_time,remarks) values (?,?,?,?)";
			let r = sqlite3_prepare(db, sql, -1, &insertEntryStmt, nil);
			if r != SQLITE_OK {
				logDbErr("sqlite3_prepare INSERT ENTRY stmt");
			}
			return r;
		}
		if(datatype == 2){
			let sql = "INSERT INTO teachers (name,weblink,designation,image,phone,mail,dept) values (?,?,?,?,?,?,?)";
			let r = sqlite3_prepare(db, sql, -1, &insertEntryStmt, nil);
			if r != SQLITE_OK {
				logDbErr("sqlite3_prepare INSERT ENTRY stmt");
			}
			return r;
		}
		if(datatype == 3){
			let sql = "INSERT INTO phone (NameDesignation,MobileNo) values (?,?)";
			let r = sqlite3_prepare(db, sql, -1, &insertEntryStmt, nil);
			if r != SQLITE_OK {
				logDbErr("sqlite3_prepare INSERT ENTRY stmt");
			}
			return r;
		}
		return 0;
	}
	func prepareReadEntryStmt()->Int32 {
		guard readEntryStmt == nil else { return SQLITE_OK }
		if(datatype == 1){
			let sql = "SELECT * from busdata";
			let r = sqlite3_prepare(db, sql, -1, &readEntryStmt, nil)
			if r != SQLITE_OK {
				logDbErr("sqlite3_prepare Read Entry Stmt");
			}
			return r;
		}
		if(datatype == 2){
			let sql = "SELECT * from teachers";
			let r = sqlite3_prepare(db, sql, -1, &readEntryStmt, nil)
			if r != SQLITE_OK {
				logDbErr("sqlite3_prepare Read Entry Stmt");
			}
			return r;
		}
		if(datatype == 3){
			let sql = "SELECT * from phone";
			let r = sqlite3_prepare(db, sql, -1, &readEntryStmt, nil)
			if r != SQLITE_OK {
				logDbErr("sqlite3_prepare Read Entry Stmt");
			}
			return r;
		}
		return 0;
	}
	func prepareDeleteEntryStmt()->Int32 {
		guard deleteEntryStmt == nil else { return SQLITE_OK }
		if(datatype==1){
			let sql = "DELETE FROM busdata";
			let r = sqlite3_prepare(db, sql, -1, &deleteEntryStmt, nil)
			if(r != SQLITE_OK) {
				logDbErr("sqlite3_prepare delete entry stmt");
			}
			return r;
		}
		else if(datatype==2){
			let sql = "DELETE FROM teachers";
			let r = sqlite3_prepare(db, sql, -1, &deleteEntryStmt, nil)
			if(r != SQLITE_OK) {
				logDbErr("sqlite3_prepare delete entry stmt");
			}
			return r;
		}
		else if(datatype==3){
			let sql = "DELETE FROM phone";
			let r = sqlite3_prepare(db, sql, -1, &deleteEntryStmt, nil)
			if(r != SQLITE_OK) {
				logDbErr("sqlite3_prepare delete entry stmt");
			}
			return r;
		}
		return 0;
	}
	
}
