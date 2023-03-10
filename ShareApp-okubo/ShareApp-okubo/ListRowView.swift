//
//  ListRowView.swift
//  ShareApp-okubo
//
//  Created by 大久保徹郎 on 2023/03/06.
//

import SwiftUI

struct ListRowView: View {
    // MARK: - プロパティ
    // タイトル
    var titleText: String
    // 本文
    var bodyText: String
    // 作成日
    var date: Date
    // 日付フォーマットで変換した文字列
    private var dateText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateStyle = .medium
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    // MARK: - View
    var body: some View {
        VStack {
            HStack {
                Text(titleText)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                Spacer()
                Text(dateText)
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 1)
            Text(bodyText)
                .font(.callout)
                .fontWeight(.regular)
                .foregroundColor(.gray)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .lineLimit(3)
        }// VStack
    }// body
}

struct ListRowView_Previews: PreviewProvider {
    static var previews: some View {
        ListRowView(titleText: "タイトル", bodyText: "本文", date: Date())
    }
}
