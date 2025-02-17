//
//  Persistence.swift
//  TodoItem
//
//  Created by 長橋和敏 on 2025/02/16.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        // モデルファイルの名前（TodoModel.xcdatamodeld）に合わせる
        // TodoModel -> TodoItem
        container = NSPersistentContainer(name: "TodoItem")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("永続化ストアの読み込みに失敗しました: \(error), \(error.userInfo)")
            }
        }
    }
}
