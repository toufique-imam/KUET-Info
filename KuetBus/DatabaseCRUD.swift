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
		//INSERT INTO teachers (name,weblink,designation,image,phone,mail) values (?,?,?,?,?,?)
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
	
	/*
	func read_bus() throws -> [busdata] {
		guard self.prepareReadEntryStmt() == SQLITE_OK else { throw SqliteError(message: "error in preparing read entry in statement" )}

		defer {
			sqlite3_reset(self.readEntryStmt)
		}
		
	}*/
	
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
			let sql = "INSERT INTO teachers (name,weblink,designation,image,phone,mail) values (?,?,?,?,?,?)";
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
			let sql = "DELETE * FROM busdata";
			let r = sqlite3_prepare(db, sql, -1, &deleteEntryStmt, nil)
			if(r != SQLITE_OK) {
				logDbErr("sqlite3_prepare delete entry stmt");
			}
			return r;
		}
		else if(datatype==2){
			let sql = "DELETE * FROM teachers";
			let r = sqlite3_prepare(db, sql, -1, &deleteEntryStmt, nil)
			if(r != SQLITE_OK) {
				logDbErr("sqlite3_prepare delete entry stmt");
			}
			return r;
		}
		else if(datatype==3){
			let sql = "DELETE * FROM phone";
			let r = sqlite3_prepare(db, sql, -1, &deleteEntryStmt, nil)
			if(r != SQLITE_OK) {
				logDbErr("sqlite3_prepare delete entry stmt");
			}
			return r;
		}
		return 0;
	}
}
