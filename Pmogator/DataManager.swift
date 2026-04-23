import Foundation
import Combine

class DataManager: ObservableObject {
    @Published var categories: [Category] = []
    @Published var menuData: MenuData? = nil   // ← Эта строка обязательна
    
    init() {
        loadQuestions()
        loadMenu()
    }
    
    private func loadQuestions() {
        guard let url = Bundle.main.url(forResource: "questions", withExtension: "json") else { return }
        do {
            let data = try Data(contentsOf: url)
            categories = try JSONDecoder().decode([Category].self, from: data)
        } catch {
            print("Ошибка questions.json: \(error)")
        }
    }
    
    private func loadMenu() {
        guard let url = Bundle.main.url(forResource: "menu", withExtension: "json") else {
            print("menu.json не найден в бандле")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            menuData = try JSONDecoder().decode(MenuData.self, from: data)
            print("✅ Меню успешно загружено: \(menuData?.categories.count ?? 0) категорий")
        } catch {
            print("❌ Ошибка загрузки menu.json: \(error)")
        }
    }

}
