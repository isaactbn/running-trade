//
//  HomeEntity.swift
//  ios-base-viper
//
//  Created by Isaac on 11/1/22.
//

import Foundation

struct HomeBodyRequest: Codable {
    var interval: String
    var range: String
}

struct HomeBodyResponse: Codable {
    let chart: HomeBodyFullResponse?
    
    typealias response = HomeBodyFullResponse?
}

struct HomeBodyFullResponse: Codable {
    let result: [ResultModel]?
}

struct ResultModel: Codable {
    let meta: MetaModel?
    let timestamp: [Int64]?
    let indicators: IndicatorsModel?
}

struct MetaModel: Codable {
    let currency: String?
    let symbol: String?
    let exchangeName: String?
    let instrumentType: String?
    let regularMarketPrice: Float?
    let previousClose: Float?
}

struct IndicatorsModel: Codable {
    let quote: [QuoteModel]?
}

struct QuoteModel: Codable {
    let open: [Float?]
    let close: [Double?]
    let high: [Float?]
    let low: [Float?]
    let volume: [Int?]
}

struct ShowModel: Codable {
    
    var timeStamp: [ShowModelDetailWithPrice]?
    var volume: [ShowModelDetailInt]?
    var price: [ShowModelDetailDouble]?
}

struct ShowModelDetailWithPrice: Codable {
    let chg: Double
    let price: Double
    let type: String
    let value: Date
}

struct ShowModelDetailInt: Codable {
    let type: String
    let value: Int
}

struct ShowModelDetailDouble: Codable {
    let type: String
    let value: Double
}
