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
    // テストデータを扱うクラス
    @EnvironmentObject var testData: TestData
    // 編集するテンプレートのインデックス番号
    @Binding var editIndex: Int?
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
                        if let editIndex = editIndex {
                            // 既存のテンプレートの上書き
                            testData.templates[editIndex].title = titleText
                            testData.templates[editIndex].body = bodyText
                        } else {
                            // 新規作成
                            let newTemplate = TestTemplate(title: titleText,
                                                           body: bodyText,
                                                           createdDate: Date())
                            testData.templates.append(newTemplate)
                        }
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
            if let editIndex = editIndex {
                let template = testData.templates[editIndex]
                // タイトルと本文を代入
                titleText = template.title
                bodyText = template.body
            }
        }
    }// body
}

struct TemplateEditView_Previews: PreviewProvider {
    static var previews: some View {
        TemplateEditView(editIndex: .constant(nil))
    }
}
