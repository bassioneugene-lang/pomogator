import SwiftUI

struct MenuView: View {
    @ObservedObject var dataManager: DataManager
    @State private var searchText = ""
    
    // Фильтрация
    var filteredCategories: [MenuCategory] {
        guard let menu = dataManager.menuData else { return [] }
        
        if searchText.isEmpty {
            return menu.categories
        }
        
        return menu.categories.filter { category in
            category.name.localizedCaseInsensitiveContains(searchText) ||
            category.dishes.contains { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredCategories) { category in
                    Section(header: Text(category.name).font(.headline).foregroundColor(.orange)) {
                        ForEach(category.dishes) { dish in
                            NavigationLink(destination: DishDetailView(dish: dish)) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(dish.name)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text(dish.description)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .lineLimit(2)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Меню")
            .searchable(text: $searchText, prompt: "Поиск блюда или категории")
            .background(Color.black)
            .scrollContentBackground(.hidden)
        }
    }
}

// MARK: - Детальный просмотр блюда
struct DishDetailView: View {
    let dish: MenuDish
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(dish.name)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                
                Text(dish.description)
                    .font(.body)
                    .foregroundColor(.gray)
                    .lineSpacing(8)
            }
            .padding()
        }
        .navigationTitle(dish.name)
        .background(Color.black.ignoresSafeArea())
    }
}
