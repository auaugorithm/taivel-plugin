//
//  ConvexResponse.swift
//  TaivelAppClip
//
//  Data models for Convex API responses
//

import Foundation

// MARK: - Request Models

struct ConvexRequest: Codable {
    let path: String
    let args: [String: Any]
    let format: String

    enum CodingKeys: String, CodingKey {
        case path, args, format
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(path, forKey: .path)
        try container.encode(format, forKey: .format)

        // Encode args as JSON object
        let argsData = try JSONSerialization.data(withJSONObject: args)
        let argsJson = try JSONSerialization.jsonObject(with: argsData)
        try container.encode(AnyCodable(argsJson), forKey: .args)
    }
}

struct LocationArgs: Codable {
    let latitude: Double
    let longitude: Double
}

// MARK: - Response Models

struct ConvexSuccessResponse: Codable {
    let status: String
    let value: AnyCodable?
    let logLines: [String]?
}

struct ConvexErrorResponse: Codable {
    let status: String
    let errorMessage: String?
    let errorData: AnyCodable?
    let logLines: [String]?
}

// MARK: - Helper for Any Codable Value

struct AnyCodable: Codable {
    let value: Any

    init(_ value: Any) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let intValue = try? container.decode(Int.self) {
            value = intValue
        } else if let doubleValue = try? container.decode(Double.self) {
            value = doubleValue
        } else if let stringValue = try? container.decode(String.self) {
            value = stringValue
        } else if let boolValue = try? container.decode(Bool.self) {
            value = boolValue
        } else if let arrayValue = try? container.decode([AnyCodable].self) {
            value = arrayValue.map { $0.value }
        } else if let dictValue = try? container.decode([String: AnyCodable].self) {
            value = dictValue.mapValues { $0.value }
        } else {
            value = NSNull()
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch value {
        case let intValue as Int:
            try container.encode(intValue)
        case let doubleValue as Double:
            try container.encode(doubleValue)
        case let stringValue as String:
            try container.encode(stringValue)
        case let boolValue as Bool:
            try container.encode(boolValue)
        case let arrayValue as [Any]:
            try container.encode(arrayValue.map { AnyCodable($0) })
        case let dictValue as [String: Any]:
            try container.encode(dictValue.mapValues { AnyCodable($0) })
        default:
            try container.encodeNil()
        }
    }
}
