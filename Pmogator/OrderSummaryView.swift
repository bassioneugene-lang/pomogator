//
//  OrderSummaryView.swift
//  Pmogator
//
//  Created by kusok_tortika on 31.03.2026.
//


import SwiftUI

struct OrderSummaryView: View {
    let orderItems: [OrderItem]
    let onRestart: () -> Void
    let onCopy: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Заявка завершена")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
                .padding(.top, 40)
            
            Text("Всего позиций: \(orderItems.count)")
                .font(.title2)
                .foregroundColor(.gray)
            
            // Группировка по категориям
            List {
                let grouped = Dictionary(grouping: orderItems, by: { $0.category })
                
                ForEach(grouped.keys.sorted(), id: \.self) { category in
                    Section(header: Text(category).font(.headline).foregroundColor(.orange)) {
                        ForEach(grouped[category] ?? []) { item in
                            HStack {
                                Text(item.name)
                                    .font(.body)
                                Spacer()
                                Text("\(item.quantity) шт.")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.green)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            
            Spacer()
            
            // Кнопки внизу
            VStack(spacing: 16) {
                Button(action: onCopy) {
                    Text("Скопировать")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                }
                
                Button(action: onRestart) {
                    Text("Начать новую заявку")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.gray.opacity(0.25))
                        .foregroundColor(.white)
                        .cornerRadius(16)
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
        }
        .background(Color.black.ignoresSafeArea())
    }
}
