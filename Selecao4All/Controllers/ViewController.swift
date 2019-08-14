//
//  ViewController.swift
//  Selecao4All
//
//  Created by Giovani Nícolas Bettoni on 07/08/19.
//  Copyright © 2019 Giovani Nícolas Bettoni. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var modelList: Lista = Lista(id: "", cidade: "", bairro: "", urlFoto: "", urlLogo: "", titulo: "", telefone: "", texto: "", endereco: "", latitude: 0.0, longitude: 0.0, comentarios: [])
    
    var listId: [String] = []
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var progressBar: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(listId.count)
        tableView.dataSource = self
        tableView.delegate = self
        
        // method to request data
        fetchListResponse()
        
        // animation
        showProgressBar()
        //progressBar.isHidden = true // to hide only for tests
    }
    
    func showProgressBar(){
        print("animating...")
        progressBar.startAnimating()
        progressBar.isHidden = false
    }
    
    // MARK: - GET1
    func fetchListResponse() {
        let jsonUrlString = "http://dev.4all.com:3003/tarefa"
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            //print("come right here..")
            
            guard let jsonData = data else { return }
            
            let listaResponse = try? JSONDecoder().decode(ListaResponse.self, from: jsonData)
            //print(listaResponse?.lista ?? "FetchJSON")
            self.listId = listaResponse!.lista

            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.progressBar.stopAnimating()
                self.progressBar.isHidden = true
            }
        }.resume()
            
    }
    
    // MARK: - GET2
    func fetchListItem(item: String) {
        let jsonUrlString = "http://dev.4all.com:3003/tarefa/\(item)"
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            
            guard let jsonData = data else { return }
            
            let lista = try? JSONDecoder().decode(Lista.self, from: jsonData)
            self.modelList = lista!
            
            
            
            // Save data on UserDefaults
            print("---- Saving data on UserDefaults ----")
            let id = lista?.id ?? "1"
            print(id)
            self.defaults.set(id, forKey: "id")
            // Titulo Tela Principal
            let appTitle = "\(lista?.cidade ?? "Porto Alegre"), \(lista?.bairro ?? "Bairro")"
            print(appTitle)
            self.defaults.set(appTitle, forKey: "appTitle")
            // URL Foto
            let urlPhoto = "\(lista?.urlFoto ?? "foto_01")"
            print(urlPhoto)
            self.defaults.set(urlPhoto, forKey: "urlPhoto")
            // URL Logo
            let urlLogo = "\(lista?.urlLogo ?? "logo_01")"
            print(urlLogo)
            self.defaults.set(urlLogo, forKey: "urlLogo")
            // Titulo
            let title = "\(lista?.titulo ?? "LOREM")"
            print(title)
            self.defaults.set(title, forKey: "title")
            // Telefone
            let phone = "\(lista?.telefone ?? "5122333311")"
            print(phone)
            self.defaults.set(phone, forKey: "phone")
            // Texto Principal
            let text = "\(lista?.texto ?? "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus finibus consequat nulla, a laoreet ipsum blandit ac. Donec vitae convallis nisi. Mauris molestie id lorem quis dignissim. Cum sociis natoque penatibus et magnis dis parturient montes.")"
            print(text)
            self.defaults.set(text, forKey: "mainText")
            // Endereco
            let address = "\(lista?.endereco ?? "Avenida Carlos Gomes, 532")"
            print(address)
            self.defaults.set(address, forKey: "address")
            // Latitude
            let latitude = lista?.latitude ?? -30.0209728
            let sLatitude = String(latitude)
            print(sLatitude)
            self.defaults.set(latitude, forKey: "latitude")
            // Longitude
            let longitude = lista?.longitude ?? -51.1921976
            let sLongitude = String(longitude)
            print(sLongitude)
            self.defaults.set(longitude, forKey: "longitude")

            }.resume()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TelaPrincipal" {
            let segueLista = segue.destination as! MainViewController
            segueLista.lists = sender as! Lista
            
        }
    }
    
}
            

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(listId.count)
        return listId.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListaInicial")
        cell?.textLabel?.text = listId[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(listId[indexPath.row])
        fetchListItem(item: listId[indexPath.row])
        performSegue(withIdentifier: "TelaPrincipal", sender: modelList)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
}
