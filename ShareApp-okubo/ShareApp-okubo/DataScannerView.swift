//
//  DataScannerView.swift
//  ShareApp-okubo
//
//  Created by 大久保徹郎 on 2023/02/24.
//

import SwiftUI
import VisionKit
import AVFoundation

struct DataScannerView: UIViewControllerRepresentable {
    // MARK: - プロパティ
    // 環境変数で取得したdismissハンドラー
    @Environment(\.dismiss) var dismiss
    // コーディネーター
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        let parent: DataScannerView
        // 初期化
        init(_ parent: DataScannerView) {
            self.parent = parent
        }
        // MARK: - デリゲートメソッド
        // スキャンした文字がタップされた時の処理
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            switch item {
            case .text(let text):
                print("タップ： \(text.transcript)")
                // スキャン停止
                dataScanner.stopScanning()
                // 確認アラート作成
                let alert = UIAlertController(title: "以下の文字をコピーします。", message: text.transcript, preferredStyle: .alert)
                // OKボタン
                let ok = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    // クリップボードにコピー
                    UIPasteboard.general.string = text.transcript
                    // カメラを閉じる
                    self.parent.dismiss()
                })
                // キャンセルボタン
                let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: { _ in
                    // スキャン再開
                    try? dataScanner.startScanning()
                })
                // アラートにボタンを設置
                alert.addAction(ok)
                alert.addAction(cancel)
                // アラート表示
                dataScanner.present(alert, animated: true)
            default:
                break
            }
        }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    // MARK: - View
    // 画面起動時
    func makeUIViewController(context: UIViewControllerRepresentableContext<DataScannerView>) -> DataScannerViewController {
        // DataScannerViewControllerのパラメーター設定
        let scannerViewController = DataScannerViewController(recognizedDataTypes: [.text()], // テキスト検知
                                                              qualityLevel: .balanced, // スキャンの解像度: バランス
                                                              recognizesMultipleItems: true, // ビデオ内のすべての文字を認識
                                                              isHighFrameRateTrackingEnabled: false, // ジオメトリの更新頻度
                                                              isPinchToZoomEnabled: true, // ズーム ジェスチャ使用可
                                                              isGuidanceEnabled: true, // ライブ映像の上に案内文を表示
                                                              isHighlightingEnabled: true) // 認識された文字をハイライトする
        // デリゲート設定
        scannerViewController.delegate = context.coordinator
        // 非同期でカメラ映像の使用許可をチェック
        Task {
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            if granted {
                // 許可が降りてからスキャン開始
                print("スキャン開始")
                try? scannerViewController.startScanning()
            } else {
                // カメラの使用が拒否されている場合のアラート
                let alert = UIAlertController(title: "カメラを使用できません。", message: "この機能を使うには設定アプリでカメラの使用を許可する必要があります。", preferredStyle: .alert)
                // 設定アプリを開くボタン
                let setting = UIAlertAction(title: "設定", style: .default, handler: { _ in
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                })
                // キャンセルボタン
                let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: { _ in
                    // 画面を閉じる
                    dismiss()
                })
                // アラートにボタンを設置
                alert.addAction(setting)
                alert.addAction(cancel)
                // 拒否されてからアラート表示
                print("アラート表示")
                scannerViewController.present(alert, animated: true)
            }
        }// Task
        return scannerViewController
    }
    // 画面更新時
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: UIViewControllerRepresentableContext<DataScannerView>) {
        // 処理無し
    }
}


