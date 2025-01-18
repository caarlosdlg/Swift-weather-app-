//
//  ContentView.swift
//  SwiftAppClimaApiJSON
//
//  Created by Carlos Delgado on 16/12/24.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @State private var city: String = ""
    @State private var weather: Weather?  // Cambiado de WeatherData? a Weather?
    @State private var errorMessage: String?
    @FocusState private var isCityFocused: Bool // Nuevo estado para el foco

    var body: some View {
        ZStack {
            // Fondo azul claro
            Color.cyan.ignoresSafeArea()
            
            VStack {
                Text("Ingresa tu ubicación")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                HStack {
                    TextField("Enter city name", text: $city)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($isCityFocused) // Vincula el foco
                        .submitLabel(.search) // Cambia el botón de retorno a búsqueda
                        .onSubmit {
                            fetchWeather()
                            isCityFocused = false // Oculta el teclado después de buscar
                        }
                    
                    Button(action: {
                        fetchWeather()
                        isCityFocused = false // Oculta el teclado al presionar buscar
                    }) {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                    }
                }
                .padding()

                if let weather = weather {
                    VStack(spacing: 20) {
                        Text("Ciudad: \(weather.cityName)")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Temperatura: \(weather.temperature, specifier: "%.1f")°C")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                        
                        Text("Descripcion: \(weather.description)")
                            .font(.title2)
                        
                        HStack {
                            Text("Humedad: \(weather.humidity)%")
                            Spacer()
                            Text("Velocidad del Viento: \(weather.windSpeed, specifier: "%.1f") m/s")
                        }
                        .font(.body)
                        .padding(.horizontal)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.8)))
                    .padding()
                    
                    // Degradado según temperatura
                    ZStack {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        getTemperatureColor(weather.temperature).color,
                                        Color.white
                                    ]),
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            )
                        
                        Text(getTemperatureColor(weather.temperature).description)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                    }
                    .frame(height: 100)
                    .cornerRadius(15)
                    .padding()
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding()
            .onTapGesture {
                isCityFocused = false // Oculta el teclado al tocar fuera
            }
        }
        .onAppear {
            // Cargar el clima de Torreón al iniciar
            city = "Torreon"
            fetchWeather()
        }
    }
    
    // Función actualizada para devolver color y descripción
    func getTemperatureColor(_ temperature: Double) -> (color: Color, description: String) {
        switch temperature {
        case ...0:
            return (Color.purple, "Muy Frío ❄️")
        case 0...10:
            return (Color.blue, "Frío 🌨")
        case 10...20:
            return (Color.green, "Templado 🌤")
        case 20...30:
            return (Color.orange, "Caliente ☀️")
        default:
            return (Color.red, "Muy Caliente 🔥")
        }
    }

    func fetchWeather() {
        WeatherService().fetchWeather(for: city) { weather in
            DispatchQueue.main.async {
                if let weather = weather {
                    self.weather = weather  // Ahora coincide con el tipo Weather
                    self.errorMessage = nil
                } else {
                    self.weather = nil
                    self.errorMessage = "No se pudo obtener el clima"
                }
            }
        }
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
