//
//  TextCreateView.swift
//  ShareApp-okubo
//
//  Created by 大久保徹郎 on 2023/02/17.
//

import SwiftUI
import VisionKit
// 文章作成画面
struct TextCreateView: View {
    // MARK: - プロパティ
    // CoreDataから取得したテンプレート
    @FetchRequest(entity: Template.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Template.createdDate, ascending: false)]) private var templates: FetchedResults<Template>
    // 使用中のテンプレートのIDの文字列（UserDefaults）
    @AppStorage("selectedID") private var selectedID = ""
    // 本文に表示する文字列
    @State private var bodyText = ""
    // 文字認識カメラの起動フラグ
    @State private var showDataScanner = false
    // フォーカス制御する変数
    @FocusState private var fieldFocus: Bool
    // テンプレートのタイトル
    private var templateTitle: String {
        // UserDefaultsに保存したIDの文字列と一致するIDのテンプレートを検索
        if let title = templates.first(where: { $0.id?.uuidString == selectedID })?.title {
            // タイトルの文字列を返す
            return title
        }
        return "テンプレート無し"
    }
    // 自動スクロールのID
    private let scrollPoint = 0
    // MARK: - View
    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollProxy in
                Form {
                    // テンプレート選択
                    Section {
                        NavigationLink(templateTitle) {
                            TemplateListView()
                        }
                    } header: {
                        Text("テンプレート選択")
                            .font(.subheadline)
                    }
                    // シェアする文章
                    Section {
                        TextField("シェアする文章を入力してください", text: $bodyText, axis: .vertical)
                            .focused($fieldFocus)
                            .id(scrollPoint)
                    } header: {
                        Text("本文")
                            .font(.subheadline)
                    } footer: {
                        if DataScannerViewController.isSupported {
                            Text("カメラで認識した文字をタップしてコピー&ペーストができます。")
                        } else {
                            Label("デバイスがLive Text機能に対応していません。", systemImage: "exclamationmark.circle")
                                .foregroundColor(.red)
                        }
                    }
                    // シェア機能
                    ShareLink(item: bodyText) {
                        Label("本文をシェアする", systemImage: "square.and.arrow.up")
                    }
                }// Form
                .onChange(of: fieldFocus) { focus in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        withAnimation {
                            if focus == true {
                                scrollProxy.scrollTo(scrollPoint, anchor: .center)
                            }
                        }
                    }
                }// onChange
            }// ScrollViewReader
            .sheet(isPresented: $showDataScanner) {
                DataScannerView()
            }
            .navigationTitle("文章作成")
            .navigationBarTitleDisplayMode(.large)
            .toolbar(content: {
                // キーボードの上に追加するツールバー
                ToolbarItemGroup(placement: .keyboard, content: {
                    if DataScannerViewController.isSupported {
                        // カメラ起動ボタン
                        Button(action: {
                            // カメラ画面を呼び出す
                            showDataScanner.toggle()
                        }) {
                            HStack {
                                Image(systemName: "text.viewfinder")
                                Text("文字認識")
                            }
                        }
                    }
                    Spacer()
                    // キーボードを閉じるボタン
                    Button("完了") {
                        // フォーカスを無効にする
                        fieldFocus.toggle()
                    }
                })
            })// toolbar
            .onAppear {
                // UserDefaultsに保存したIDの文字列と一致するIDのテンプレートを検索
                if let templateBody = templates.first(where: { $0.id?.uuidString == selectedID })?.body {
                    // 本文の値をテキストフィールドに反映
                    bodyText = templateBody
                } else {
                    bodyText = ""
                }
            }
        }// NavigationStack
    }// body
}

struct TextCreateView_Previews: PreviewProvider {
    static var previews: some View {
        TextCreateView()
    }
}
