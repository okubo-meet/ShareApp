//
//  TemplateListView.swift
//  ShareApp-okubo
//
//  Created by 大久保徹郎 on 2023/03/03.
//

import SwiftUI

struct TemplateListView: View {
    // MARK: - プロパティ
    // 環境変数で取得したdismissハンドラー
    @Environment(\.dismiss) var dismiss
    // 被管理オブジェクトコンテキスト（ManagedObjectContext）の取得
    @Environment(\.managedObjectContext) private var context
    // CoreDataから取得したテンプレート
    @FetchRequest(entity: Template.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Template.createdDate, ascending: false)], animation: .default) private var templates: FetchedResults<Template>
    // 選択したのテンプレートのIDの文字列（UserDefaults）
    @AppStorage("selectedID") private var selectedID = ""
    // 編集モードの切り替えフラグ
    @State private var isEditMode = false
    // 編集ダイアログ表示フラグ
    @State private var showDialog = false
    // テンプレート編集画面の遷移フラグ
    @State private var showEditView = false
    // 編集されるテンプレートのID
    @State private var editedID: UUID?
    // ナビゲーションタイトルの文字列
    private var navigationTitle: String {
        if isEditMode {
            return "編集中"
        } else {
            return "テンプレート選択"
        }
    }
    // 編集ボタンの文字列
    private var editButtonText: String {
        if isEditMode {
            return "完了"
        } else {
            return "編集"
        }
    }
    // MARK: - View
    var body: some View {
        List {
            // 編集モードでない場合のみ表示
            if isEditMode == false {
                Button("テンプレート無し") {
                    // UserDefaultsに空の文字列を渡し
                    selectedID = ""
                    // 前の画面に戻る
                    dismiss()
                }
            }
            // テンプレートリスト
            Section {
                ForEach(templates) { template in
                    Button(action: {
                        if isEditMode {
                            // 編集モードの場合、識別IDを変数に代入し
                            editedID = template.id
                            // ダイアログ表示
                            showDialog.toggle()
                        } else {
                            // 編集モードでない場合UserDefaultsに識別IDを渡し
                            if let idString = template.id?.uuidString {
                                selectedID = idString
                            }
                            // 前の画面に戻る
                            dismiss()
                        }
                    }) {
                        ListRowView(titleText: template.title!,
                                    bodyText: template.body!,
                                    date: template.createdDate!)
                    }
                }// ForEach
            }
            // 新規作成ボタン
            Button(action: {
                // 識別IDをnil
                editedID = nil
                // テンプレート編集画面に遷移
                showEditView.toggle()
            }) {
                Label("新規テンプレート作成", systemImage: "plus")
            }
        }// List
        // 編集ダイアログ
        .confirmationDialog("テンプレート編集", isPresented: $showDialog, titleVisibility: .visible) {
            Button("編集") {
                showEditView.toggle()
            }
            Button("削除", role: .destructive) {
                // テンプレート削除の処理
                deleteTemplate(id: editedID)
            }
        }// confirmationDialog
        // 編集画面へのリンク
        .navigationDestination(isPresented: $showEditView) {
            TemplateEditView(editedID: $editedID)
        }
        .navigationTitle(navigationTitle)
        // ツールバー
        .toolbar(content: {
            // 画面右上
            ToolbarItem(placement: .navigationBarTrailing, content: {
                // 編集モード切り替えボタン
                Button(editButtonText) {
                    withAnimation {
                        isEditMode.toggle()
                    }
                }
            })
        })// toolbar
    }// body
    // MARK: - メソッド
    // テンプレートを削除する関数
    private func deleteTemplate(id: UUID?) {
        if let id = id {
            if let template = templates.first(where: { $0.id == id }) {
                print("削除するデータ： \(template)")
                // CoreDataから削除する
                context.delete(template)
                // 使用中のテンプレートを削除した場合
                if selectedID == id.uuidString {
                    // 選択状態を破棄する（UserDefaultsに空の文字列を代入）
                    selectedID = ""
                }
            }
        }
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}

struct TemplateListView_Previews: PreviewProvider {
    static var previews: some View {
        TemplateListView()
    }
}
