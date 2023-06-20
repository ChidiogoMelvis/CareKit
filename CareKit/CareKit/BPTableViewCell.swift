//
//  BPTableViewCell.swift
//  CareKit_
//
//  Created by Mac on 20/06/2023.
//

import UIKit

class BPTableViewCell: UITableViewCell {

    var identifier = "BPTableViewCell"
       
       lazy var systolicLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
           
       }()
       
       lazy var diastolicLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
           
       }()
       
       lazy var dateLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
           
       }()

       override func awakeFromNib() {
           super.awakeFromNib()
           setupViews()
       }

       override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)
           setupViews()
       }
       
    func setupViews() {
           self.addSubview(systolicLabel)
           self.addSubview(diastolicLabel)
           self.addSubview(dateLabel)
           
           NSLayoutConstraint.activate([
               systolicLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
               systolicLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
               
               diastolicLabel.topAnchor.constraint(equalTo: systolicLabel.bottomAnchor, constant: 10),
               diastolicLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
               
               dateLabel.topAnchor.constraint(equalTo: diastolicLabel.bottomAnchor, constant: 20),
               dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)
           ])
       }
       
       func configure(with reading: BPReading) {
              systolicLabel.text = "\(reading.systolic)"
              diastolicLabel.text = "\(reading.diastolic)"
              dateLabel.text = formatDate(reading.date)
          }

          private func formatDate(_ date: Date) -> String {
              let dateFormatter = DateFormatter()
              dateFormatter.dateStyle = .medium
              dateFormatter.timeStyle = .short
              return dateFormatter.string(from: date)
          }

   }



