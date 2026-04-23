import SwiftUI

struct OrderView: View {
    @ObservedObject var dataManager: DataManager
    
    @State private var allItems: [ItemWithCategory] = []
    @State private var currentIndex: Int = -1
    @State private var orderItems: [OrderItem] = []
    @State private var currentQuantity: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                if currentIndex == -1 {
                    Spacer()
                    Text("Заявка на товары")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    
                    Button("Начать заявку") {
                        startOrder()
                    }
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 22)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(.horizontal, 40)
                    
                    Spacer()
                }
                else if currentIndex < allItems.count {
                    let current = allItems[currentIndex]
                    
                    // Счётчики
                    HStack {
                        Text("\(currentIndex + 1)/\(allItems.count)")
                            .font(.title3)
                            .foregroundColor(.gray)
                        Spacer()
                        Text(getCategoryProgress())
                            .font(.title3)
                            .foregroundColor(.orange)
                    }
                    .padding(.horizontal)
                    
                    Text(current.categoryName)
                        .font(.title2)
                        .foregroundColor(.orange)
                        .bold()
                    
                    Text(current.item.name)
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                    
                    Spacer()
                    
                    // Поле количества
                    TextField("Количество", text: $currentQuantity)
                        .font(.system(size: 55, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(16)
                        .frame(maxWidth: 260)
                    
                    Spacer(minLength: 8)
                    
                    // Кастомная клавиатура
                    CustomNumericKeyboard(text: $currentQuantity)
                        .padding(.horizontal, 20)
                    
                    Spacer(minLength: 8)
                    
                    // Панель Backspace и Ввод
                    HStack(spacing: 12) {
                        // Backspace (1/3)
                        Button {
                            if !currentQuantity.isEmpty {
                                currentQuantity.removeLast()
                            }
                        } label: {
                            Image(systemName: "delete.left")
                                .font(.title2)
                                .frame(maxWidth: .infinity)
                                .frame(height: 70)
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(16)
                        }
                        
                        // Ввод (2/3)
                        Button("Ввод") {
                            saveAndNext()
                        }
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .frame(height: 70)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    }
                    .padding(.horizontal, 20)
                    
                    // Нижние кнопки: Пропустить остальное и Назад
                    HStack(spacing: 20) {
                        Button {
                            currentIndex = allItems.count
                        } label: {
                            Image(systemName: "forward.end")
                                .font(.title2)
                        }
                        .foregroundColor(.red)
                        
                        Button {
                            if currentIndex > 0 {
                                currentIndex -= 1
                                currentQuantity = ""
                            }
                        } label: {
                            Image(systemName: "arrowshape.turn.up.left")
                                .font(.title2)
                        }
                        .foregroundColor(.gray)
                    }
                    .padding(.top, 12)
                }
                else {
                    VStack(spacing: 30) {
                        Text("Заявка завершена")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("Выбрано позиций: \(orderItems.count)")
                            .font(.title2)
                            .foregroundColor(.gray)
                        
                        Button("Скопировать") {
                            copyToMarkdown()
                        }
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .padding(.horizontal, 40)
                        
                        Button("Новая заявка") {
                            resetOrder()
                        }
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.gray.opacity(0.25))
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .padding(.horizontal, 40)
                    }
                }
            }
            .navigationTitle("Заявка")
            .background(Color.black.ignoresSafeArea())
            .onAppear(perform: loadItems)
        }
    }
    
    private func loadItems() {
        var list: [ItemWithCategory] = []
        for category in dataManager.categories {
            for item in category.items {
                list.append(ItemWithCategory(item: item, categoryName: category.category))
            }
        }
        allItems = list
    }
    
    private func startOrder() {
        currentIndex = 0
        orderItems = []
        currentQuantity = ""
    }
    
    private func saveAndNext() {
        guard let qty = Int(currentQuantity), qty > 0 else {
            nextItem()
            return
        }
        
        let current = allItems[currentIndex]
        
        // Проверяем, есть ли уже этот товар в заявке
        if let index = orderItems.firstIndex(where: {
            $0.name == current.item.name && $0.category == current.categoryName
        }) {
            // Если товар уже есть — ЗАМЕНЯЕМ количество на новое
            orderItems[index].quantity = qty
        } else {
            // Если товара ещё нет — добавляем новый
            orderItems.append(OrderItem(
                name: current.item.name,
                quantity: qty,
                category: current.categoryName
            ))
        }
        
        nextItem()
    }
      
    
    private func nextItem() {
        currentQuantity = ""
        currentIndex += 1
    }
    
    private func getCategoryProgress() -> String {
        guard currentIndex < allItems.count else { return "" }
        let currentCat = allItems[currentIndex].categoryName
        let catItems = allItems.filter { $0.categoryName == currentCat }
        let position = catItems.firstIndex { $0.item.name == allItems[currentIndex].item.name } ?? 0
        return "\(position + 1)/\(catItems.count)"
    }
    private func resetOrder() {
            currentIndex = -1
            orderItems = []
    }
        
    private func copyToMarkdown() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        var text = "# Заявка на товары от \(dateFormatter.string(from: Date()))\n\n"
        
        let grouped = Dictionary(grouping: orderItems, by: { $0.category })
        
        for (category, items) in grouped.sorted(by: { $0.key < $1.key }) {
            text += "## \(category)\n"
            for item in items {
                text += "- **\(item.name)** — \(item.quantity) шт.\n"
            }
            text += "\n"
        }
        
        UIPasteboard.general.string = text
        
        // Вибрация успеха
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
}

// MARK: - Кастомная клавиатура
struct CustomNumericKeyboard: View {
    @Binding var text: String
    
    let buttons = [
        ["1", "2", "3", "4", "5"],
        ["6", "7", "8", "9", "0"]
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { number in
                        Button {
                            text += number
                        } label: {
                            Text(number)
                                .font(.title)
                                .frame(maxWidth: .infinity)
                                .frame(height: 70)
                                .background(Color.gray.opacity(0.25))
                                .cornerRadius(12)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Вспомогательная структура
struct ItemWithCategory {
    let item: Item
    let categoryName: String
}

