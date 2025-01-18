import SwiftUI
import Combine

struct WeatherData: Decodable {
    let temperature: Double
    let description: String
    let cityName: String
    let humidity: Int
    let windSpeed: Double
}

class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherData?
    
    private var cancellable: AnyCancellable?
    
    func fetchWeather() {
        guard let url = URL(string: "https://api.example.com/weather") else { return }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: WeatherData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] weather in
                self?.weather = weather
            })
    }
}
