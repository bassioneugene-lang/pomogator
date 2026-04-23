//
//  Category.swift
//  Pomogator
//
//  Created by kusok_tortika on 31.03.2026.
//


import Foundation

// База товаров
struct Category: Identifiable, Codable {
    let id = UUID()
    var category: String
    var items: [Item]
}

struct Item: Identifiable, Codable {
    let id = UUID()
    var name: String
}

// Заявка
struct OrderItem: Identifiable {
    let id = UUID()
    let name: String
    var quantity: Int      // ← Должно быть var, а не let
    let category: String
}
// MARK: - Меню (новая версия под массив)
struct MenuData: Codable {
    let categories: [MenuCategory]
}

struct MenuCategory: Codable, Identifiable {
    let id = UUID()
    let name: String
    let dishes: [MenuDish]
}

struct MenuDish: Codable, Identifiable {
    let id = UUID()
    let name: String
    let description: String
}
