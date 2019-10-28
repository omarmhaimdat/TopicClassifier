//
//  ViewController.swift
//  TopicClassifier
//
//  Created by M'haimdat omar on 26-10-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import CoreML
import NaturalLanguage

class ViewController: UIViewController {

    let cellId = "cellId"
    var cells = [Model]()
    var selectArray : [IndexPath] = []
    
    var newCollection: UICollectionView = {
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.backgroundColor = UIColor.clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = true
        collection.showsVerticalScrollIndicator = false
        collection.allowsMultipleSelection = true
        
        return collection
    }()
    
    var dictionarySelectedIndexPath: [IndexPath: Bool] = [:]
    
    enum Mode {
        case view
        case select
    }
    
    var mMode: Mode = .view {
        didSet {
            switch mMode {
            case .view:
                for (key, value) in dictionarySelectedIndexPath {
                    if value {
                        self.newCollection.deselectItem(at: key, animated: true)
                    }
                }
                
                dictionarySelectedIndexPath.removeAll()
                self.navigationItem.leftBarButtonItem = .init(barButtonSystemItem: .edit, target: self, action: #selector(editCell(_:)))
                newCollection.allowsMultipleSelection = false
                self.navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(addCell(_:)))
            case .select:
                self.navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .cancel, target: self, action: #selector(cancelCell(_:)))
                self.navigationItem.leftBarButtonItem = .init(barButtonSystemItem: .trash, target: self, action: #selector(didDeleteButtonClicked(_:)))
                newCollection.allowsMultipleSelection = true
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        } else {
            // Fallback on earlier versions
            view.backgroundColor = UIColor.white
        }
        setupTabBar()
        self.setupCollection()
        self.setupCollectionView()
    }
    
    
    func setupTabBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "News Classifier"
        if #available(iOS 13.0, *) {
            self.navigationController?.navigationBar.barTintColor = .systemBackground
             navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.label]
        } else {
            // Fallback on earlier versions
            self.navigationController?.navigationBar.barTintColor = .lightText
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black]
        }
        self.navigationController?.navigationBar.isHidden = false
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.barStyle = .default
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.label]
        } else {
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.black]
        }
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
            navigationController?.navigationBar.backgroundColor = .white
        }
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(addCell(_:)))
        self.navigationItem.leftBarButtonItem = .init(barButtonSystemItem: .edit, target: self, action: #selector(editCell(_:)))
    }
    
    func setupCollection() {
        
        self.view.addSubview(newCollection)
        
        newCollection.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        newCollection.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        newCollection.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        newCollection.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        newCollection.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        newCollection.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    func setupCollectionView() {
        if #available(iOS 13.0, *) {
            newCollection.backgroundColor = UIColor.systemBackground
        } else {
            // Fallback on earlier versions
           newCollection.backgroundColor = .white
        }
        newCollection.register(ViewControllerCell.self, forCellWithReuseIdentifier: cellId)
        newCollection.alwaysBounceVertical = true
        newCollection.delegate = self
        newCollection.dataSource = self
        
    }
    
    @objc func addCell(_ sender: UIBarButtonItem) {
        
        let model = TopicClassifier()
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Text"
        }
        let confirmAction = UIAlertAction(title: "Add", style: .default) { [weak alertController] _ in
            guard let alertController = alertController, let textField = alertController.textFields?.first else { return }
            if let text = textField.text {
                do {
                    let prediction = try model.prediction(text: text)
                    if prediction.label == "business" {
                        let cell = Model(text: text, color: UIColor.systemBlue, topic: prediction.label, secondaryColor: UIColor.systemGray6)
                        self.cells.append(cell)
                        self.newCollection.reloadData()
                    } else if prediction.label == "tech" {
                        let cell = Model(text: text, color: UIColor.systemGreen, topic: prediction.label, secondaryColor: UIColor.systemGray6)
                        self.cells.append(cell)
                        self.newCollection.reloadData()
                    } else if prediction.label == "entertainment" {
                        let cell = Model(text: text, color: UIColor.systemOrange, topic: prediction.label, secondaryColor: UIColor.systemGray6)
                        self.cells.append(cell)
                        self.newCollection.reloadData()
                    } else if prediction.label == "politics" {
                        let cell = Model(text: text, color: UIColor.systemRed, topic: prediction.label, secondaryColor: UIColor.systemGray6)
                        self.cells.append(cell)
                        self.newCollection.reloadData()
                    } else if prediction.label == "sport" {
                        let cell = Model(text: text, color: UIColor.systemTeal, topic: prediction.label, secondaryColor: UIColor.systemGray6)
                        self.cells.append(cell)
                        self.newCollection.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
        }
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
     @objc func editCell(_ sender: UIBarButtonItem) {
        mMode = mMode == .view ? .select : .view
    }
    
    @objc func didDeleteButtonClicked(_ sender: UIBarButtonItem) {
        var deleteNeededIndexPaths: [IndexPath] = []
        for (key, value) in dictionarySelectedIndexPath {
            if value {
                deleteNeededIndexPaths.append(key)
            }
        }
        
        for i in deleteNeededIndexPaths.sorted(by: { $0.item > $1.item }) {
            cells.remove(at: i.item)
        }
        
        newCollection.deleteItems(at: deleteNeededIndexPaths)
        dictionarySelectedIndexPath.removeAll()
    }
    @objc func cancelCell(_ sender: UIBarButtonItem) {
        mMode = mMode == .select ? .view : .select
    }


}

