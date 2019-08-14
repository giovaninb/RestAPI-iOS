//
//  Lista.swift
//  Selecao4All
//
//  Created by Giovani Nícolas Bettoni on 07/08/19.
//  Copyright © 2019 Giovani Nícolas Bettoni. All rights reserved.
//

import Foundation

import Foundation

// MARK: - Lista
struct ListaResponse: Codable {
    let lista: [String]
}

// MARK: - Lista
struct Lista: Codable {
    let id, cidade, bairro: String
    let urlFoto: String
    let urlLogo: String
    let titulo, telefone, texto, endereco: String
    let latitude, longitude: Double
    let comentarios: [Comentario]
}

// MARK: - Comentario
struct Comentario: Codable {
    let urlFoto: String
    let nome: String
    let nota: Int
    let titulo, comentario: String
}
