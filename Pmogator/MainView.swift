import SwiftUI

struct MainView: View {
    @ObservedObject var dataManager: DataManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 50) {
                    // Логотип и название
                    Image("chef")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 180, height: 180)
                        .clipShape(Circle())
                        .shadow(radius: 15)
                    
                    Text("Сытый Папик")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    
                    VStack(spacing: 20) {
                        // Кнопка Заявка
                        NavigationLink(destination: OrderView(dataManager: dataManager)) {
                            MainButton(title: "Заявка", color: .blue)
                        }
                        
                        // Кнопка Меню — теперь настоящая!
                        NavigationLink(destination: MenuView(dataManager: dataManager)) {
                            MainButton(title: "Меню", color: .orange)
                        }
                    }
                    .padding(.horizontal, 40)
                }
            }
        }
    }
}

// Вспомогательная кнопка
struct MainButton: View {
    let title: String
    let color: Color
    
    var body: some View {
        Text(title)
            .font(.title2)
            .bold()
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(16)
    }
}
