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
    // 仮データを扱うクラス
    @EnvironmentObject var testData: TestData
    // 選択されるテンプレート
    @Binding var selectedTemplate: TestTemplate?
    // 編集モードの切り替えフラグ
    @State private var isEditMode = false
    // 編集ダイアログ表示フラグ
    @State private var showDialog = false
    // テンプレート編集画面の遷移フラグ
    @State private var showEditView = false
    // 編集されるテンプレートのインデックス番号
    @State private var editIndex: Int?
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
                    // テンプレートがない状態を返し前の画面に戻る
                    selectedTemplate = nil
                    dismiss()
                }
            }
            // テンプレートリスト
            Section {
                ForEach(testData.templates) { template in
                    Button(action: {
                        if isEditMode {
                            // 編集モードの場合、インデックス番号を変数に代入し
                            editIndex = testData.templates.firstIndex(where: {$0.id == template.id})
                            // ダイアログ表示
                            showDialog.toggle()
                        } else {
                            // 編集モードでない場合、文章作成画面にテンプレートの値を渡し
                            selectedTemplate = template
                            // 前の画面に戻る
                            dismiss()
                        }
                    }) {
                        ListRowView(titleText: template.title,
                                    bodyText: template.body,
                                    date: template.createdDate)
                    }
                }// ForEach
            }
            // 新規作成ボタン
            Button(action: {
                // インデックス番号をnil
                editIndex = nil
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
                if let editIndex = editIndex {
                    // テンプレート削除
                    testData.templates.remove(at: editIndex)
                }
            }
        }// confirmationDialog
        // 編集画面へのリンク
        .navigationDestination(isPresented: $showEditView) {
            TemplateEditView(editIndex: $editIndex)
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
}

struct TemplateListView_Previews: PreviewProvider {
    static var previews: some View {
        TemplateListView(selectedTemplate: .constant(nil))
    }
}
