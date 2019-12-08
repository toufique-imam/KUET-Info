//
//  SearchFooter.swift
//  KuetBus
//
//  Created by Nuhash on 7/12/19.
//  Copyright © 2019 Main Uddin Chisty. All rights reserved.
//

import UIKit

class SeachFooter: UIView {
	let label = UILabel();
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureView()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		configureView();
	}
	override func draw(_ rect: CGRect){
		label.frame = bounds
	}
	func setNotFiltering() {
		label.text = ""
		hideFooter()
	}
	func setIsFilteringTOShow(filteredItemCount: Int, of totalItemCount: Int)
	{
		if(filteredItemCount == totalItemCount) {
			setNotFiltering()
		}
		else if(filteredItemCount == 0){
			label.text = "NO Items Match Your Query"
			showFooter()
		}
		else{
			label.text = "Filtering \(filteredItemCount) of \(totalItemCount)"
			showFooter()
		}
	}
	func hideFooter() {
		UIView.animate(withDuration: 0.7){
			self.alpha = 0.0
		}
	}
	func showFooter() {
		UIView.animate(withDuration: 0.7)
		{
			self.alpha = 1.0
		}
	}
	func configureView() {
		backgroundColor = UIColor.blue
		alpha = 0.0
		label.textAlignment = .center
		label.textColor = UIColor.white
		addSubview(label)
	}
}
