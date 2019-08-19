import Routing
import Vapor
import Leaf
import PostgreSQL
import Fluent

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    
    // MARK: - GET /categories (JSON)
    
    router.get("categories") { req -> Future<[Category]> in
        return Category.query(on: req).all()
    }
    
    router.get("words", Int.parameter) { req -> Future<[CategoryWord]> in
        // Получаем ID категории
        let categoryID = try req.parameters.next(Int.self)
        
        // Получаем категорию из Базы Данных
        return Category.find(categoryID, on: req).flatMap(to: [CategoryWord].self) { category in
            guard let category = category else {
                throw Abort(.notFound)
            }
            
            return CategoryWord.query(on: req)
                .filter(\.category == category.id!)
                .all()
        }
    }
    
    router.get() { req -> Future<View> in
        return try req.view().render("users-welcome")
    }
    
    // MARK: - GET - /firstsetup (LEAF)
    
    router.get("firstsetup") { req -> String in
        
        let categories = [
            Category(id: 1, name: "Муз.инструменты"),
            Category(id: 2, name: "Города"),
            Category(id: 3, name: "Имена")
        ]
        
        categories.forEach {
            _ = $0.create(on: req)
        }
        
        return "Настройка БД завершена (Добавлены Категории)"
    }
    
    // MARK: - GET - /secondsetup (LEAF)
    
    router.get("secondsetup") { req -> String in
        
        let words = [
            CategoryWord(id: 1, category: 1, title: "Гитара", user: "admin", date: Date()),
            CategoryWord(id: 2, category: 1, title: "Барабаны", user: "admin", date: Date()),
            CategoryWord(id: 3, category: 1, title: "Фортепиано", user: "admin", date: Date()),
            CategoryWord(id: 4, category: 2, title: "Москва", user: "admin", date: Date()),
            CategoryWord(id: 5, category: 2, title: "Токио", user: "admin", date: Date()),
            CategoryWord(id: 6, category: 2, title: "Денвер", user: "admin", date: Date()),
            CategoryWord(id: 7, category: 2, title: "Осло", user: "admin", date: Date()),
            CategoryWord(id: 8, category: 2, title: "Стокгольм", user: "admin", date: Date()),
            CategoryWord(id: 9, category: 2, title: "Рио", user: "admin", date: Date()),
            CategoryWord(id: 10, category: 3, title: "Андрей", user: "admin", date: Date()),
            CategoryWord(id: 11, category: 3, title: "Екатерина", user: "admin", date: Date()),
            CategoryWord(id: 12, category: 3, title: "Мария", user: "admin", date: Date()),
            CategoryWord(id: 13, category: 3, title: "Алексей", user: "admin", date: Date()),
            CategoryWord(id: 14, category: 3, title: "Александр", user: "admin", date: Date()),
            CategoryWord(id: 15, category: 3, title: "Евгений", user: "admin", date: Date()),
        ]
        
        words.forEach {
            _ = $0.create(on: req)
        }
        
        return "Настройка БД завершена (Добавлены слова для Категорий)"
    }
    
    
}
