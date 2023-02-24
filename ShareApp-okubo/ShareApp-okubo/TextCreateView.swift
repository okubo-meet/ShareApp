//
//  TextCreateView.swift
//  ShareApp-okubo
//
//  Created by 大久保徹郎 on 2023/02/17.
//

import SwiftUI
// 文章作成画面
struct TextCreateView: View {
    // MARK: - プロパティ
    // 本文に表示する文字列
    @State private var bodyText = ""
    // カメラで読み取った文字列
    @State private var resultText = ""
    // TextFieldのフォーカス
    enum Field: Int, Hashable {
        case body = 0
        case result = 1
    }
    // フォーカス制御する変数
    @FocusState private var focusField: Field?
    // MARK: - View
    var body: some View {
        ScrollViewReader { scrollProxy in
            Form {
                // テンプレート選択
                Section {
                    Button("テンプレート無し") {
                        // 後でNavigationLinkに変更する
                    }
                    
                } header: {
                    Text("テンプレート選択")
                        .font(.subheadline)
                }
                // シェアする文章
                Section {
                    TextField("シェアする文章を入力してください", text: $bodyText, axis: .vertical)
                        .focused($focusField, equals: .body)
                        .id(Field.body.rawValue)
                } header: {
                    Text("本文")
                        .font(.subheadline)
                }
                // 文字認識関連
                Section {
                    // カメラ起動ボタン
                    Button(action: {
                        // カメラ画面を呼び出す
                    }) {
                        Label("カメラを起動する", systemImage: "camera")
                    }
                    TextField("読み取った文字が表示されます", text: $resultText, axis: .vertical)
                        .focused($focusField, equals: .result)
                        .id(Field.result.rawValue)
                    Button(action: {
                        // クリップボードにコピーする（カメラ機能を作成してから）
                    }) {
                        Label("読み取った文字をコピーする", systemImage: "doc.on.doc")
                    }
                } header: {
                    Text("カメラで文字を読み取る")
                        .font(.subheadline)
                }
                // シェア機能
                ShareLink(item: bodyText) {
                    Label("本文をシェアする", systemImage: "square.and.arrow.up")
                }
            }// Form
            .onChange(of: focusField) { focus in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation {
                        if let focus = focus {
                            scrollProxy.scrollTo(focus.rawValue, anchor: .center)
                        }
                    }
                }
            }// onChange
        }// ScrollViewReader
        .navigationTitle("文章作成")
        .navigationBarTitleDisplayMode(.large)
        .toolbar(content: {
            // キーボードを閉じるボタン
            ToolbarItemGroup(placement: .keyboard, content: {
                Spacer()
                Button("閉じる") {
                    // フォーカスを無効にする
                    focusField = nil
                }
            })
        })// toolbar
    }// body
}

struct TextCreateView_Previews: PreviewProvider {
    static var previews: some View {
        TextCreateView()
    }
}
