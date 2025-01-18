import Foundation
import CoreLocation

class WeatherService {
    func fetchWeather(for city: String, completion: @escaping (Weather?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=364144128d77cfc10028ce99b0f8e2e7&units=metric"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data)
            completion(weatherResponse?.toWeather())
        }.resume()
    }
    
    func fetchWeatherByLocation(_ latitude: Double, _ longitude: Double, completion: @escaping (Weather?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=364144128d77cfc10028ce99b0f8e2e7&units=metric"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data)
            completion(weatherResponse?.toWeather())
        }.resume()
    }
}

struct WeatherResponse: Codable {
    let main: Main
    let weather: [WeatherElement]
    let name: String
    let wind: Wind
    
    func toWeather() -> Weather {
        return Weather(
            temperature: main.temp,
            description: weather.first?.description ?? "",
            cityName: name,
            humidity: main.humidity,
            windSpeed: wind.speed
        )
    }
}

struct Main: Codable {
    let temp: Double
    let humidity: Int
}

struct WeatherElement: Codable {
    let description: String
}

struct Wind: Codable {
    let speed: Double
}
