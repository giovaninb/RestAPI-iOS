//
//  MainViewController.swift
//  Selecao4All
//
//  Created by Giovani Nícolas Bettoni on 08/08/19.
//  Copyright © 2019 Giovani Nícolas Bettoni. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import SDWebImage

class MainViewController: UIViewController {

    let defaults = UserDefaults.standard
    var numberOfRows: Int? = 0
    
    var locationManager = CLLocationManager()
    var pinLocations = CLLocation(latitude: -30.0306551, longitude: -51.1846846)
    
    var lists: Lista = Lista(id: "", cidade: "", bairro: "", urlFoto: "", urlLogo: "", titulo: "", telefone: "", texto: "", endereco: "", latitude: 0.0, longitude: 0.0, comentarios: [])
    var modelList: [Lista] = []
    
    var listComment: [Comentario] = []
    
    // Outlets
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var sectionComments: UIView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var appTitle: UINavigationItem!
    @IBOutlet weak var titleMain: UILabel!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var mainText: UITextView!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        // Comments section
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("-- didAppear")
        getData()
        fetchListItem()
        
        // Map on Center
        let lati = defaults.double(forKey: "latitude")
        let longi = defaults.double(forKey: "longitude")
        pinLocations = CLLocation(latitude: lati, longitude: longi)
        
        centerMap(on: pinLocations.coordinate)
        let pinLocals = MapLocation(coordinate: pinLocations.coordinate, title: "")
        mapView.addAnnotation(pinLocals)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("*********** willAppear")
        getData()
        fetchListItem()
        
        // Map on Center
        let lati = defaults.double(forKey: "latitude")
        let longi = defaults.double(forKey: "longitude")
        pinLocations = CLLocation(latitude: lati, longitude: longi)
        
        centerMap(on: pinLocations.coordinate)
        let pinLocals = MapLocation(coordinate: pinLocations.coordinate, title: "")
        mapView.addAnnotation(pinLocals)
        
    }
    
    func fetchListItem() {
        let id = defaults.string(forKey: "id")
        let jsonUrlString = "http://dev.4all.com:3003/tarefa/\(id ?? "1")"
        print(jsonUrlString)
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            
            guard let jsonData = data else { return }
            
            self.lists = try! JSONDecoder().decode(Lista.self, from: jsonData)
            self.modelList.append(self.lists)
            ListCache.save(self.lists)
            
            print("<<< Comment section >>>")
            print(self.lists.comentarios)
            self.listComment = self.lists.comentarios
            DispatchQueue.main.async {
                self.commentsTableView.reloadData()
            }
            
            
            }.resume()
    }
    
    func getData() {
        print("**** Retrieve data from UserDefaults ****")
        let urlPhoto = URL(string: defaults.string(forKey: "urlPhoto")!)
        photo.sd_setImage(with: urlPhoto, placeholderImage: UIImage(named: "photo.png"))
        appTitle.title = defaults.string(forKey: "appTitle")
        titleMain.text = defaults.string(forKey: "title")
        let urlLogo = URL(string: defaults.string(forKey: "urlLogo")!)
        logo.sd_setImage(with: urlLogo, placeholderImage: UIImage(named: "logo.png"))
        mainText.text = defaults.string(forKey: "mainText")
        labelAddress.text = defaults.string(forKey: "address")
        
    }
    
    @IBAction func addressAction(_ sender: UIButton) {
        print("address action")
        showAdressAlert()
    }
    
    @IBAction func callAction(_ sender: UIButton) {
        print("call action")
        guard let number = URL(string: "tel://" + defaults.string(forKey: "phone")!) else { return }
        UIApplication.shared.open(number)
    }
    
    @IBAction func commentsAction(_ sender: UIButton) {
        print("redirect to comments section")
        scrollview.setContentOffset(CGPoint(x: 0, y: (scrollview.contentSize.height - 314)), animated: true)
    }
    
    
    func showAdressAlert() {
        let defaultAction = UIAlertAction(title: "Ok", style: .default) { (action) in }
        
        // Create and configure the alert controller.
        let alert = UIAlertController(title: "Endereço",
                                      message: defaults.string(forKey: "address"),
                                      preferredStyle: .alert)
        alert.addAction(defaultAction)
        self.present(alert, animated: true)
    }
    
    
}

// Extension for Centralize and put Pins
extension MainViewController : MKMapViewDelegate {
    private func centerMap(on coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate,
                                        span: MKCoordinateSpan(latitudeDelta: 0.02,
                                                               longitudeDelta: 0.02))
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MapLocation else { return nil }
        
        let id = "marker"
        let view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation,
                                          reuseIdentifier: id)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: -5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count:\(listComment.count)")
        return (listComment.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Comment") as? CommentsViewCell
        
        print("index:\(indexPath.row)")
        print(listComment)
        cell?.profilePhoto.sd_setImage(with: URL(string: listComment[indexPath.row].urlFoto), placeholderImage: UIImage(named: "profile.png"))
        cell?.nameUser.text = listComment[indexPath.row].nome
        cell?.commentTitle.text = listComment[indexPath.row].titulo
        cell?.comment.text = listComment[indexPath.row].comentario
        cell?.ratingBar.rating = Double(listComment[indexPath.row].nota)
        
        return cell!
    }
    
    
}


// Code to pick up image from URL and parse into ImageView without Pods
//        DispatchQueue.global(qos: .background).async {
//            let dataLogo = try? Data(contentsOf: urlLogo!)
//            //i'm sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//            DispatchQueue.main.async {
//                self.logo.image = UIImage(data: dataLogo!)
//            }
//        }

