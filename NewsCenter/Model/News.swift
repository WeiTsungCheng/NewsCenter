//
//  New.swift
//  NewsCenter
//
//  Created by WEI-TSUNG CHENG on 2024/4/7.
//

import Foundation

struct News: Decodable {
    let articles: [Article]
    /// e.g. "ok"
    let status: String
    /// e.g. 29
    let totalResults: Int
}

struct Article: Decodable {
    
    /// e.g. "ソニー・インタラクティブエンタテインメントは4月5日、PS5/PS4用ソフトウェア「グランツーリスモ7」の公式世界大会「グランツ－リスモ ワールドシリーズ 2024」の概要を公開した。"
    let description: String?

    /// e.g. "https://car.watch.impress.co.jp/img/car/list/1582/255/13.jpg"
    let urlToImage: String?

    /// e.g. "Copyright ©2018Impress Corporation. All rights reserved."
    let content: String?
    let source: Source

    /// e.g. "https://car.watch.impress.co.jp/docs/news/1582255.html"
    let url: URL

    /// e.g. "2024-04-05T12:14:36Z"
    let publishedAt: String
    let author: String?

    /// e.g. "「グランツーリスモ ワールドシリーズ 2024」が4月17日開幕 2024年はモントリオール、プラハ、東京でライブイベント開催 - Car Watch"
    let title: String
}

struct Source: Decodable {
    let id: String?

    /// e.g. "Impress.co.jp"
    let name: String
}
