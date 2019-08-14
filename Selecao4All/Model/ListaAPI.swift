//
//  ListaAPI.swift
//  Selecao4All
//
//  Created by Giovani Nícolas Bettoni on 08/08/19.
//  Copyright © 2019 Giovani Nícolas Bettoni. All rights reserved.
//

import UIKit
import Alamofire

class ListaAPI: NSObject {
    
    var comments: [Comentario] = []
    
    // MARK: - GET
    
    func returnList(id: String) {
        AF.request("http://dev.4all.com:3003/tarefa/\(id)", method: .get).responseJSON { response in
            
            switch response.result {
            case .success:
//                self.comments = response.value as? [Comentario] {
//                    print("JSON: \(self.comments)") // serialized json response
//                }
                break
            case .failure:
                print(response.error!)
                break
            }
            
//            if let json = response.value {
//                print("JSON: \(json)") // serialized json response
//            }
//
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
//            }
        }
    }

}
