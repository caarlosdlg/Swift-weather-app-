import Foundation

struct Weather: Codable {  // Cambiado de WeatherData a Weather
    let temperature: Double
    let description: String
    let cityName: String
    let humidity: Int
    let windSpeed: Double
}
