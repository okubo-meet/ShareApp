//
//  TestData.swift
//  ShareApp-okubo
//
//  Created by 大久保徹郎 on 2023/03/06.
//

import Foundation

// 仮のテンプレート構造体（後でCoreDataで実装）
struct TestTemplate: Identifiable {
    // 識別ID
    let id = UUID()
    // タイトル
    var title: String
    // 本文
    var body: String
    // 作成日
    var createdDate: Date
}

// 仮データを扱うクラス
class TestData: ObservableObject {
    // テンプレートデータの配列
    @Published var templates = [TestTemplate(title: "テスト", body: "テストテンプレート\nこの文章をシェア機能で扱う。", createdDate: Date()),
                                TestTemplate(title: "タイトルは改行なし", body: "本文は改行あり\nテンプレートリストでは\n最大3行目まで表示\nそれ以外では何行でも表示できる", createdDate: Date())]
}
