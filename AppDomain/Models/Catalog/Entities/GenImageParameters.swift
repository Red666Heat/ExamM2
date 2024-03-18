//
//  GenImageParameters.swift
//  Exam(Gordeev)
//
//  Created by Максим Зимин on 13.02.2024.
//

import Foundation

// MARK: - GenImageRequest
public struct GenImageRequest: Codable {
    public let modelId: Int
    public let params: GenImageParameters

    enum CodingKeys: String, CodingKey {
        case modelId = "model_id"
        case params
    }

    public init(
        params: GenImageParameters
    ) {
        self.modelId = 4
        self.params = params
    }
}

// MARK: - GenImageParameters
public struct GenImageParameters: Codable {
    public let type: String
    public let style: String?
    public let width: Int
    public let height: Int
    public let numImages: Int
    public let negativePromptUnclip: String?
    public let generateParams: GenImageParametersQuery

    enum CodingKeys: String, CodingKey {
        case type, style, width, height
        case numImages = "num_images"
        case negativePromptUnclip, generateParams
    }

    public init(
        style: String?,
        width: Int,
        height: Int,
        numImages: Int,
        negativePromptUnclip: String?,
        generateParams: GenImageParametersQuery
    ) {
        self.type = "GENERATE"
        self.style = style
        self.width = width
        self.height = height
        self.numImages = numImages
        self.negativePromptUnclip = negativePromptUnclip
        self.generateParams = generateParams
    }
}

// MARK: - GenerateParams
public struct GenImageParametersQuery: Codable {
    public let query: String

    public init(query: String) {
        self.query = query
    }
}

// MARK: - StartGenerateResponse
public struct StartGenerateResponse: Codable {
    public let uuid, status: String
}

// MARK: - GenerateResponse
public struct GenerateResponse: Codable {
    public let uuid, status: String
    public let images: [String]?
    public let errorDescription: String?
    public let censored: Bool?
}

// MARK: - StyleModel
public struct StyleModel: Codable, Equatable {
    public let name, title, titleEn: String
    public let image: String
}
