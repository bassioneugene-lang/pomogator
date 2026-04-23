import SwiftUI

@main
struct PomogatorApp: App {
    @StateObject private var dataManager = DataManager()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                // Главная
                MainView(dataManager: dataManager)
                    .tabItem {
                        Label("Главная", systemImage: "house.fill")
                    }
                
                // Меню
                MenuView(dataManager: dataManager)
                    .tabItem {
                        Label("Меню", systemImage: "menucard.fill")
                    }
                
                // История (пока заглушка)
                Text("История")
                    .tabItem {
                        Label("История", systemImage: "clock.fill")
                    }
            }
            .accentColor(.orange)
            .preferredColorScheme(.dark)
        }
    }
}
