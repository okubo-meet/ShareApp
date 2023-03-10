//
//  TemplateEditView.swift
//  ShareApp-okubo
//
//  Created by 大久保徹郎 on 2023/03/03.
//

import SwiftUI

struct TemplateEditView: View {
    // MARK: - プロパティ
    // 環境変数で取得したdismissハンドラー
    @Environment(\.dismiss) var dismiss
    // 被管理オブジェクトコンテキスト（ManagedObjectContext）の取得
    @Environment(\.managedObjectContext) private var context
    // CoreDataから取得したテンプレート
    @FetchRequest(entity: Template.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Template.createdDate, ascending: false)], animation: .default) private var templates: FetchedResults<Template>
    // 編集するテンプレートの識別ID
    @Binding var editedID: UUID?
    // キーボードのフォーカスの列挙型
    enum Field: Hashable {
        case title
        case body
    }
    // フォーカス制御する変数
    @FocusState private var focusField: Field?
    // テンプレートのタイトル
    @State private var titleText = ""
    // テンプレートの本文
    @State private var bodyText = ""
    // 保存完了アラートのフラグ
    @State private var showAlert = false
    // 入力されていない項目がないか判定するフラグ
    private var emptyFieldExist: Bool {
        // 空白と改行を削除して
        let title = titleText.trimmingCharacters(in: .whitespacesAndNewlines)
        let body = bodyText.trimmingCharacters(in: .whitespacesAndNewlines)
        // 空の入力項目をチェック
        if title.isEmpty || body.isEmpty {
            return true
        }
        return false
    }
    // 編集される既存のテンプレート
    private var editedTemplate: Template? {
        // 識別IDから編集されるテンプレートを返す
        if let id = editedID {
            if let template = templates.first(where: { $0.id == id }) {
                return template
            }
        }
        return nil
    }
    // MARK: - View
    var body: some View {
        Form {
            Section {
                TextField("タイトルを入力してください（必須）", text: $titleText)
                    .focused($focusField, equals: .title)
            } header: {
                Text("タイトル")
                    .font(.subheadline)
            } footer: {
                Text("タイトルは改行できません。")
            }
            Section {
                TextField("テンプレートを入力してください（必須）", text: $bodyText, axis: .vertical)
                    .focused($focusField, equals: .body)
            } header: {
                Text("本文")
                    .font(.subheadline)
            } footer: {
                Text("本文は改行に対応しています。")
            }
            Section {
                HStack {
                    Spacer()
                    Button("保存") {
                        // テンプレートを保存する処理
                        saveTemplate(title: titleText, body: bodyText)
                        // 保存完了アラート表示
                        showAlert.toggle()
                    }
                    .font(.title3)
                    .fontWeight(.semibold)
                    .disabled(emptyFieldExist)
                    Spacer()
                }
            } footer: {
                 Text("入力されていない項目がある場合は保存されません。")
            }
        }// Form
        // 保存完了アラート
        .alert("保存しました。", isPresented: $showAlert, actions: {
            Button("OK") {
                // 前の画面に戻る
                dismiss()
            }
        }, message: {
            Text("前の画面に戻ります。")
        })// alert
        .navigationTitle("テンプレート設定")
        // ツールバー
        .toolbar(content: {
            ToolbarItemGroup(placement: .keyboard, content: {
                Spacer()
                // キーボードを閉じるボタン
                Button("完了") {
                    // フォーカスを無効にする
                    focusField = nil
                }
            })
        })// toolbar
        .onAppear {
            // 既存のテンプレート編集の場合
            if let editedTemplate = editedTemplate {
                titleText = editedTemplate.title!
                bodyText = editedTemplate.body!
            }
        }
    }// body
    // MARK: - メソッド
    // テンプレートを保存する関数
    private func saveTemplate(title: String, body: String) {
        // 既存のテンプレートの上書きか判定
        if let editedTemplate = editedTemplate {
            // 引数の値で上書きする
            editedTemplate.title = title
            editedTemplate.body = body
            print("上書き保存： \(editedTemplate)")
        } else {
            // 新規作成
            let newTemplate = Template(context: context)
            newTemplate.id = UUID()
            newTemplate.title = title
            newTemplate.body = body
            newTemplate.createdDate = Date()
            print("新規作成： \(newTemplate)")
        }
        // 保存
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}

struct TemplateEditView_Previews: PreviewProvider {
    static var previews: some View {
        TemplateEditView(editedID: .constant(nil))
    }
}
