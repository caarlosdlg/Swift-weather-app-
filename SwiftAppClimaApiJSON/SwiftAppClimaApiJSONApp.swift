//
//  SwiftAppClimaApiJSONApp.swift
//  SwiftAppClimaApiJSON
//
//  Created by Carlos Delgado on 16/12/24.
//

import SwiftUI

@main
struct SwiftAppClimaApiJSONApp: App {
    @StateObject private var weatherViewModel = WeatherViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(weatherViewModel)
        }
    }
}
