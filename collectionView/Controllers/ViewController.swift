//
//  ViewController.swift
//  collectionView
//
//  Created by Shrishail Diggi on 06/05/19.
//  Copyright © 2019 Shrishail Diggi. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var names: [Names] = []
    
    var ref : DatabaseReference!
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return names.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        let friendName = names[indexPath.row]
        cell.countLabel.text = friendName.name
        cell.transform = CGAffineTransform(rotationAngle: .pi)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        myCollectionView.transform = CGAffineTransform.init(rotationAngle: (-(CGFloat)(Double.pi)))
        
        ref =  Database.database().reference(withPath: "friend-names")
        ref.queryOrdered(byChild: "name").observe(.value, with: { snapshot in
            var newItems: [Names] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let name = Names(snapshot: snapshot) {
                    newItems.append(name)
                }
            }
            
            self.names = newItems
            self.myCollectionView.reloadData()
        })
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func addFriend(_ sender: Any) {
        let alert = UIAlertController(title: "Friend Name",
                                      message: "Add a Name",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = alert.textFields?.first,
                let text = textField.text else { return }
            
            
            let groceryItem = Names(name: text)
            
            let groceryItemRef = self.ref.child(text.lowercased())
            
            groceryItemRef.setValue(groceryItem.toAnyObject())
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    


}

