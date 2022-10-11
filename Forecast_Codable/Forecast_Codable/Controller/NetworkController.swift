//
//  NetworkController.swift
//  Forecast_Codable
//
//  Created by Jacob Perez on 10/10/22.
//

import Foundation

class NetworkController {
    private static let baseURLString = "https://api.weatherbit.io/v2.0"
// URL Keys
    private static let kForecastComponent = "forecast"
    private static let kDailyComponent = "daily"
    private static let kCitynameKey = "city"
    private static let kCityNameValue = "Honolulu"
    private static let kApiKeyKey = "key"
    
    static func fetchDays(completion: @escaping (TopLevelDictionary?) -> Void) {
        guard let baseURL = URL(string: baseURLString) else { return }
        
        let forecastURL = baseURL.appendingPathComponent(kForecastComponent)
        let dailyURL = forecastURL.appendingPathComponent(kDailyComponent)
        var urlComponents = URLComponents(url: dailyURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: kApiKeyKey, value: "8503276d5f49474f953722fa0a8e7ef8" )
        let cityQuery = URLQueryItem(name: kCitynameKey, value: kCityNameValue)
        let unitsQuery = URLQueryItem(name: "units", value: "I")
        urlComponents?.queryItems = [
            apiQuery,
            cityQuery,
            unitsQuery ]
        
        guard let finalURL = urlComponents?.url else { return }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { dayData, _, error in
            if let error = error {
                print("Error in dataTask. The url is \(finalURL), The error is \(error.localizedDescription)")
                completion(nil)
            }
            guard let data = dayData else {
                print("There was an error reciving the data!")
                completion(nil)
                return
            }
            do {
                let topLevelDictionary = try JSONDecoder().decode(TopLevelDictionary.self, from: data)
                completion(topLevelDictionary)
            } catch {
                print("Error in DO/Try/Catch: \(error.localizedDescription)")
                completion(nil)
            }
        } .resume()
    }
}
