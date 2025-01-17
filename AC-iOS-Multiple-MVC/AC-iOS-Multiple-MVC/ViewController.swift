//
//  ViewController.swift
//  AC-iOS-Multiple-MVC
//
//  Created by Tom Seymour on 11/2/17.
//  Copyright © 2017 AC-iOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var zooAnimals: [[ZooAnimal]] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        zooAnimals = filterAnimalsByClassification(ZooAnimal.zooAnimals)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow, let segueReference = segue.destination as? DetailViewController else {
            return
        }
        segueReference.anAnimal = zooAnimals[indexPath.section][indexPath.row]
    }

    func filterAnimalsByClassification(_ arr: [ZooAnimal]) -> [[ZooAnimal]]{
        
        let tempArr = arr
        
        let sortedAnimals = tempArr.sorted { $0.classification < $1.classification}
        let animalSet: Set<String> = Set(sortedAnimals.map {$0.classification})
        var animalMatrix = Array(repeating: [ZooAnimal](), count: animalSet.count)
        
        var currentIndex = 0
        var currentClass = sortedAnimals.first?.classification ?? "Unknown"
        for animal in sortedAnimals{
            if animal.classification == currentClass{
                animalMatrix[currentIndex].append(animal)
            } else {
                currentClass = animal.classification
                currentIndex += 1
                animalMatrix[currentIndex].append(animal)
            }
        }
        
        return animalMatrix
    }
}

extension  ViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return zooAnimals.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zooAnimals[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let xCell = tableView.dequeueReusableCell(withIdentifier: "animalCell", for: indexPath)
        xCell.textLabel?.text = zooAnimals[indexPath.section][indexPath.row].name
        xCell.imageView?.image = UIImage(named:zooAnimals[indexPath.section][indexPath.row].imageNumber.description)
        xCell.detailTextLabel?.text = zooAnimals[indexPath.section][indexPath.row].origin
        return xCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return zooAnimals[section][0].classification
    }
}
