//
//  ContentView.swift
//  TodoItem
//
//  Created by 長橋和敏 on 2025/02/16.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    // TodoItemをタイトル順にしてソートして取得
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TodoItem.title, ascending: true)],
        animation: .default)
    // FetchResultじゃなくてFetchedResultsな！間違えないように！
    var todoItems: FetchedResults<TodoItem>
    
    @State private var newTaskTitle: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // タスク追加用のフォーム部分
                HStack {
                    TextField("新しいタスクを入力", text: $newTaskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: addTask) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                    }
                    .disabled(newTaskTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding()
                
                // タスク一覧表示
                List {
                    ForEach(todoItems) { item in
                        HStack {
                            Button(action: {
                                toggleCompletion(for: item)
                            }) {
                                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(item.isCompleted ? .green : .gray)
                            }
                            Text(item.title ?? "Untitled")
                                .strikethrough(item.isCompleted, color: .black)
                        }
                    }
                    .onDelete(perform: deleteTasks)
                }
            }
            .navigationTitle("TODOリスト")
        }
    }
                                      
    // タスクの追加処理
    private func addTask() {
        withAnimation {
            let newItem = TodoItem(context: viewContext)
            newItem.id = UUID()
            newItem.title = newTaskTitle
            newItem.isCompleted = false
                                        
            do {
                try viewContext.save()
                newTaskTitle = "" // 保存後に入力欄をクリア
            } catch {
                print("タスクの保存に失敗しました: \(error.localizedDescription)")
            }
        }
    }
                                
    // タスクの完了状態を切り替える処理
    private func toggleCompletion(for item: TodoItem) {
        withAnimation {
            item.isCompleted.toggle()
            do {
                try viewContext.save()
            } catch {
                print("タスク更新に失敗しました: \(error.localizedDescription)")
            }
        }
    }
                                      
    // タスクの削除処理
    private func deleteTasks(offsets: IndexSet) {
        withAnimation {
            offsets.map { todoItems[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                print("タスク削除に失敗しました: \(error.localizedDescription)")
            }
        }
    }
}

/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
*/
