//
//  SideBarViewController.swift
//  CareKit
//
//  Created by Mac on 07/05/2023.
//

import UIKit
import HealthKit
import CareKit

class SideBarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var bloodPressureReadings: [BPReading] = []
      let healthStore = HKHealthStore()
      
      //MARK: - Create and configure the table view
      lazy var tableView: UITableView = {
          let tableView = UITableView()
          tableView.translatesAutoresizingMaskIntoConstraints = false
          tableView.dataSource = self
          tableView.delegate = self
          tableView.backgroundColor = .green
          tableView.register(BPTableViewCell.self, forCellReuseIdentifier: "BPTableViewCell")
          return tableView
      }()
      
      override func viewDidLoad() {
          super.viewDidLoad()
          fetchBPReadings()
          setupViews()
          handleUserAuthorization()
          //title = "Menu"
          view.backgroundColor = .white
      }
      
      
      func fetchBPReadings() {
              guard let systolicType = HKQuantityType.quantityType(forIdentifier: .bloodPressureSystolic),
                    let diastolicType = HKQuantityType.quantityType(forIdentifier: .bloodPressureDiastolic) else {
                  return
              }

              let healthStore = HKHealthStore()

              let query = HKCorrelationQuery(type: HKObjectType.correlationType(forIdentifier: .bloodPressure)!, predicate: nil, samplePredicates: nil) { (query, correlations, error) in
                  guard let correlations = correlations else {
                      if let error = error {
                          print("Error fetching blood pressure readings: \(error.localizedDescription)")
                      }
                      return
                  }
              
              self.bloodPressureReadings = []

              for correlation in correlations {
                  guard let systolicSamples = correlation.objects(for: systolicType) as? [HKQuantitySample],
              let diastolicSamples = correlation.objects(for: diastolicType) as? [HKQuantitySample],
              let systolic = systolicSamples.first,
              let diastolic = diastolicSamples.first else {
                  continue
              }

              let systolicValue = systolic.quantity.doubleValue(for: HKUnit.millimeterOfMercury())
              let diastolicValue = diastolic.quantity.doubleValue(for: HKUnit.millimeterOfMercury())
              let reading = BPReading(systolic: systolicValue, diastolic: diastolicValue, date: correlation.endDate)
              self.bloodPressureReadings.append(reading)
              }

              DispatchQueue.main.async {
              self.tableView.reloadData()
                  }
              }

          healthStore.execute(query)
                 
      }
      
      // MARK: - Table view data source
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return bloodPressureReadings.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "BPTableViewCell", for: indexPath) as! BPTableViewCell
          let reading = bloodPressureReadings[indexPath.row]
              cell.configure(with: reading)
                //cell.detailTextLabel?.text = formatDate(reading.date)
          return cell
      }
      
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 200
      }
      
      private func formatDate(_ date: Date) -> String {
              let dateFormatter = DateFormatter()
              dateFormatter.dateStyle = .medium
              dateFormatter.timeStyle = .short
              return dateFormatter.string(from: date)
          }
      
      func setupViews() {
          view.addSubview(tableView)
          
          NSLayoutConstraint.activate([
              tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
              tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
              tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
              tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
          ])
      }
      
      func handleUserAuthorization() {
          let bloodPressureType = HKQuantityType.quantityType(forIdentifier: .bloodPressureSystolic)
              
              guard let bloodPressureQuantityType = bloodPressureType else {
                  // Handle the absence of blood pressure type
                  return
              }

              healthStore.requestAuthorization(toShare: nil, read: [bloodPressureQuantityType]) { (success, error) in
                  if let error = error {
                      // Handle the error
                      print("Error requesting HealthKit authorization: \(error.localizedDescription)")
                      return
                  }

                  if success {
                      // Authorization granted
                      // You can now access blood pressure data
                      
                      // Retrieve the blood pressure readings
                      self.fetchBPReadings()
                  } else {
                      // Authorization denied by the user
                      // Handle the denial or display an appropriate message
                      print("HealthKit authorization denied by the user")
                  }
              }
      }

}


