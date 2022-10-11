//
//  DayDetailsViewController.swift
//  Forecast_Codable
//
//  Created by Karl Pfister on 2/6/22.
//

import UIKit

class DayDetailsViewController: UIViewController {
    
    
    //MARK: - Outlets
    @IBOutlet weak var dayForecastTableView: UITableView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentHighLabel: UILabel!
    @IBOutlet weak var currentLowLabel: UILabel!
    @IBOutlet weak var currentDescriptionLabel: UILabel!
    
    //MARK: - Properties
    var days: [Day] = []
    var forecastData: TopLevelDictionary?
    
    //MARK: - View Lifecyle
    
    func setUpTable(){
        dayForecastTableView.delegate = self
        dayForecastTableView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTable()
        
        NetworkController.fetchDays { forecastData in
            guard let forecastData = forecastData else { return }
            self.forecastData = forecastData
            self.days = forecastData.days
            DispatchQueue.main.async {
                self.updateViews()
                self.dayForecastTableView.reloadData()
                
            }
        }
    }
    func updateViews() {
        let currentDate = days[0]
        cityNameLabel.text = forecastData?.cityName
        currentTempLabel.text = "\(currentDate.temp)"
        currentHighLabel.text = "\(currentDate.highTemp)"
        currentLowLabel.text = "\(currentDate.lowTemp)"
        currentDescriptionLabel.text = currentDate.weather.description
    }
}
      
extension DayDetailsViewController: UITableViewDataSource, UITableViewDelegate {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return days.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as? DayForcastTableViewCell else {return UITableViewCell()}
            
            let day = days[indexPath.row]
            cell.updateView(day: day)
            return cell
        }
    }
