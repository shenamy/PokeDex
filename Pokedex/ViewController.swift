//
//  ViewController.swift
//  Pokedex
//
//  Created by SAMEER SURESH on 9/25/16.
//  Copyright © 2016 trainingprogram. All rights reserved.
//

import UIKit
import ASHorizontalScrollView


class ViewController: UIViewController, UISearchBarDelegate {
    
    var pokemons: [Pokemon] = PokemonGenerator.getPokemonArray()
    
    var searchBar: UISearchBar!
    var searchBarText: String!
    var imageView: UIImageView!
    var typeLabel: UILabel!
    var horizontalScrollView: ASHorizontalScrollView!
    var attributesLabel: UILabel!
    var attackPointsButton: RectButton!
    var attackPointsLabel: UILabel!
    var defensePointsButton: RectButton!
    var defensePointsLabel: UILabel!
    var healthPointsButton: RectButton!
    var healthPointsLabel: UILabel!
    var searchButton: RectButton!
    var randomButton: RectButton!
    
    var typeIconArray: [UIImageView] = []
    var typePicsArray = ["bug.png", "dark.png", "dragon.png", "electric.png", "fairy.png", "fighting.png", "fire.png", "flying.png", "ghost.png", "grass.png", "ground.png", "ice.png", "normal.png", "poison.png", "psychic.png", "rock.png", "steel.png", "water.png"]
    var typeNamesArray = ["bug", "dark", "dragon", "electric", "fairy", "fighting", "fire", "flying", "ghost", "grass", "ground", "ice", "normal", "poison", "psychic", "rock", "steel", "water"]
    var pikachu = [#imageLiteral(resourceName: "pikachu-1"), #imageLiteral(resourceName: "pikachu-2"), #imageLiteral(resourceName: "pikachu-3"), #imageLiteral(resourceName: "pikachu-4"), #imageLiteral(resourceName: "pikachu-5"), #imageLiteral(resourceName: "pikachu-6"), #imageLiteral(resourceName: "pikachu-7"), #imageLiteral(resourceName: "pikachu-8"), #imageLiteral(resourceName: "pikachu-9"), #imageLiteral(resourceName: "pikachu-10"), #imageLiteral(resourceName: "pikachu-11"), #imageLiteral(resourceName: "pikachu-12"), #imageLiteral(resourceName: "pikachu-13"), #imageLiteral(resourceName: "pikachu-14"), #imageLiteral(resourceName: "pikachu-15"), #imageLiteral(resourceName: "pikachu-16"), #imageLiteral(resourceName: "pikachu-17"), #imageLiteral(resourceName: "pikachu-18"), #imageLiteral(resourceName: "pikachu-19"), #imageLiteral(resourceName: "pikachu-20"), #imageLiteral(resourceName: "pikachu-21"), #imageLiteral(resourceName: "pikachu-22"), #imageLiteral(resourceName: "pikachu-23"), #imageLiteral(resourceName: "pikachu-24"), #imageLiteral(resourceName: "pikachu-25"), #imageLiteral(resourceName: "pikachu-26"), #imageLiteral(resourceName: "pikachu-27"), #imageLiteral(resourceName: "pikachu-28"), #imageLiteral(resourceName: "pikachu-29"), #imageLiteral(resourceName: "pikachu-30"), #imageLiteral(resourceName: "pikachu-31"), #imageLiteral(resourceName: "pikachu-32"), #imageLiteral(resourceName: "pikachu-33")]
    var noSelectedTypes = true //when no types are selected by user, all the types are selected by default
    var randomIndexesPicked: [Int] = [] //keep track of random indexes that have been picked to ensure no repeats
    
    //FOR ALL DATA THAT WILL BE PASSED TO THE DISPLAY VIEW
    var pokemonsToPass: [Pokemon] = PokemonGenerator.getPokemonArray()
    var pokemonDirectPass: Pokemon! // passes searched pokemon straight to profile view
    var typesToSearch: [String] = [] // strings of types that have been selected
    var minHP: Int = 0
    var minATK: Int = 0
    var minDEF: Int = 0
    //For handling alerts
    var alertController : UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSearchBar()
        initTypeLabelUI()
        initHorizontalScrollViewUI()
        initAttributesLabelUI()
        initAttackPointsButtonUI()
        initDefensePointsButtonUI()
        initHealthPointsButtonUI()
        initSearchButtonUI()
        initRandomButtonUI()
        initPikachu()
        
    }
    
    func initSearchBar() {
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        navigationController?.navigationBar.backgroundColor = UIColor.red
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap) // dismiss keyboard when user taps elsewhere
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchButtonClicked()
    }
    func dismissKeyboard() {
        navigationItem.titleView?.endEditing(true)
    }
    
    func initTypeLabelUI() {
        typeLabel = UILabel(frame: CGRect(x: 15, y: (navigationController?.navigationBar.frame.maxY)!, width: view.frame.width, height: 50))
        typeLabel.text = "TYPE"
        typeLabel.font = UIFont(name: "PokemonGB", size: 16.0)
        typeLabel.setTextSpacing(spacing: 7.0)
        view.addSubview(typeLabel)
    }
    
    func initHorizontalScrollViewUI() {
        typesToSearch = typeNamesArray.map{$0.capitalized} // make selected types all the types by defult
        horizontalScrollView = ASHorizontalScrollView(frame: CGRect(x: -1, y: typeLabel.frame.maxY, width: view.frame.width + 2, height: 80))
        horizontalScrollView.uniformItemSize = CGSize(width: 60, height: 70)
        horizontalScrollView.backgroundColor = UIColor.init(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
        horizontalScrollView.layer.borderWidth = 1
        horizontalScrollView.layer.borderColor = UIColor.init(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0).cgColor
        setHorizontalScrollViewMargins()
        populateTypesView()
        view.addSubview(horizontalScrollView)
    }
    
    // Add left and right margins
    func setHorizontalScrollViewMargins() {
        horizontalScrollView.marginSettings_320 = MarginSettings(leftMargin: 10, miniMarginBetweenItems: 0, miniAppearWidthOfLastItem: 0)
        horizontalScrollView.marginSettings_375 = MarginSettings(leftMargin: 10, miniMarginBetweenItems:0, miniAppearWidthOfLastItem: 0)
        horizontalScrollView.marginSettings_414 = MarginSettings(leftMargin: 10, miniMarginBetweenItems: 0, miniAppearWidthOfLastItem: 0)
        horizontalScrollView.marginSettings_480 = MarginSettings(leftMargin: 10, miniMarginBetweenItems: 0, miniAppearWidthOfLastItem: 0)
        horizontalScrollView.marginSettings_568 = MarginSettings(leftMargin: 10, miniMarginBetweenItems: 0, miniAppearWidthOfLastItem: 0)
        horizontalScrollView.marginSettings_667 = MarginSettings(leftMargin: 10, miniMarginBetweenItems: 0, miniAppearWidthOfLastItem: 0)
        horizontalScrollView.marginSettings_736 = MarginSettings(leftMargin: 10, miniMarginBetweenItems: 0, miniAppearWidthOfLastItem: 0)
        horizontalScrollView.marginSettings_768 = MarginSettings(leftMargin: 10, miniMarginBetweenItems: 0, miniAppearWidthOfLastItem: 0)
        horizontalScrollView.marginSettings_1024 = MarginSettings(leftMargin: 10, miniMarginBetweenItems: 0, miniAppearWidthOfLastItem: 0)
        horizontalScrollView.marginSettings_1366 = MarginSettings(leftMargin: 10, miniMarginBetweenItems: 0, miniAppearWidthOfLastItem: 0)
    }
    
    func populateTypesView() {
        for i in 0...17 {
            typeIconArray.append(UIImageView(image: UIImage(named: typePicsArray[i].replacingOccurrences(of: ".png", with: "_dim.png"))))
            //setting up icon
            let currentIcon = typeIconArray[i]
            currentIcon.clipsToBounds = true
            currentIcon.contentMode = UIViewContentMode.scaleAspectFit
            currentIcon.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
            currentIcon.tag = i
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:))) //when image clicked, calls selector
            currentIcon.isUserInteractionEnabled = true
            currentIcon.addGestureRecognizer(tapGestureRecognizer)
            //setting up label
            let typeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            typeLabel.text = typeNamesArray[i]
            typeLabel.textColor = UIColor.black
            typeLabel.font = UIFont(name: "PokemonGB", size: 8.0)
            typeLabel.sizeToFit()
            typeLabel.frame.origin.x = horizontalScrollView.uniformItemSize.width / 2 - typeLabel.frame.width / 2
            typeLabel.frame.origin.y = currentIcon.frame.maxY
            //setting up view that contains text and image
            let view = UIView()
            view.addSubview(currentIcon)
            view.addSubview(typeLabel)
            horizontalScrollView.addItem(view)
        }
    }
    
    // type image is clicked
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        let tag = tappedImage.tag
        let typeToAdd = typeNamesArray[tag].capitalized
        if noSelectedTypes == true { //if user has finally selected a type, the list is cleared
            noSelectedTypes = false
            typesToSearch.removeAll()
        }
        if typesToSearch.contains(typeToAdd) {
            typeIconArray[tag].image = UIImage(named: typePicsArray[tag].replacingOccurrences(of: ".png", with: "_dim.png"))
            typesToSearch.remove(at: typesToSearch.index(of: typeToAdd)!)
        } else {
            typeIconArray[tag].image = UIImage(named: typePicsArray[tag])
            typesToSearch.append(typeToAdd)
        }
        if typesToSearch.count == 0 { //this means the user doesn't have a type selected anymore, so have all types selected
            noSelectedTypes = true
            typesToSearch = typeNamesArray.map{$0.capitalized}
        }
    }
    
    func initAttributesLabelUI() {
        attributesLabel = UILabel(frame: CGRect(x: 15, y: horizontalScrollView.frame.maxY + 5, width: view.frame.width, height: 50))
        attributesLabel.text = "ATTRIBUTES"
        attributesLabel.font = UIFont(name: "PokemonGB", size: 16.0)
        attributesLabel.setTextSpacing(spacing: 7.0)
        view.addSubview(attributesLabel)
    }
    
    func initAttackPointsButtonUI() {
        attackPointsButton = RectButton(frame: CGRect(x:0, y:attributesLabel.frame.maxY + 10, width: view.frame.width, height: 50))
        attackPointsButton.setTitle("Attack Points", for: .normal)
        attackPointsButton.titleLabel?.font = UIFont(name: "PokemonGB", size:12.0)
        attackPointsButton.titleLabel?.setTextSpacing(spacing: 0.7)
        attackPointsButton.backgroundColor = UIColor.init(red: 200/255, green: 100/255, blue: 100/255, alpha: 1.0)
        // adjusting label positions
        let button_width = -(attackPointsButton.frame.width) / 2
        let label_width = (attackPointsButton.titleLabel?.intrinsicContentSize.width)! / 2 //width of the text
        attackPointsButton.titleEdgeInsets = UIEdgeInsets(top: 0,left: button_width + label_width + 25, bottom: 0,right: (attackPointsButton.frame.width) / 2 - label_width)
        view.addSubview(attackPointsButton)
        setUpAttackLabel()
        //Add action listener
        attackPointsButton.addTarget(self, action: #selector(attackClicked), for: .touchUpInside)
    }
    
    func setUpAttackLabel() {
        attackPointsLabel = UILabel(frame: CGRect(x: 0, y: attackPointsButton.frame.minY + (attackPointsButton.frame.height / 2) - 10, width: view.frame.width, height: 20))
        attackPointsLabel.text = "0-200"
        attackPointsLabel.font = UIFont(name: "PokemonGB", size: 16.0)
        attackPointsLabel.setTextSpacing(spacing: 0.7)
        attackPointsLabel.textColor = UIColor.white
        attackPointsLabel.frame = CGRect(x: view.frame.width - (attackPointsLabel.intrinsicContentSize.width) - 15, y: attackPointsButton.frame.minY + (attackPointsButton.frame.height / 2) - 10, width: attackPointsLabel.intrinsicContentSize.width, height: 20) //re-adjusting frame after setting text
        view.addSubview(attackPointsLabel)
    }
    
    func initDefensePointsButtonUI() {
        defensePointsButton = RectButton(frame: CGRect(x:0, y:attackPointsButton.frame.maxY, width: view.frame.width, height: 50))
        defensePointsButton.setTitle("Defense Points", for: .normal)
        defensePointsButton.titleLabel?.font = UIFont(name: "PokemonGB", size:12.0)
        defensePointsButton.titleLabel?.setTextSpacing(spacing: 0.7)
        defensePointsButton.backgroundColor = UIColor.init(red: 140/255, green: 140/255, blue: 230/255, alpha: 1.0)
        // adjusting label positions
        let button_width = -(defensePointsButton.frame.width) / 2
        let label_width = (defensePointsButton.titleLabel?.intrinsicContentSize.width)! / 2
        defensePointsButton.titleEdgeInsets = UIEdgeInsets(top: 0,left: button_width + label_width + 25, bottom: 0,right: (defensePointsButton.frame.width) / 2 - label_width)
        view.addSubview(defensePointsButton)
        setUpDefenseLabel()
        //Add action listener
        defensePointsButton.addTarget(self, action: #selector(defenseClicked), for: .touchUpInside)
    }
    
    func setUpDefenseLabel() {
        defensePointsLabel = UILabel(frame: CGRect(x: 0, y: defensePointsButton.frame.minY + (defensePointsButton.frame.height / 2) - 10, width: view.frame.width, height: 20))
        defensePointsLabel.text = "0-200"
        defensePointsLabel.font = UIFont(name: "PokemonGB", size: 16.0)
        defensePointsLabel.setTextSpacing(spacing: 0.7)
        defensePointsLabel.textColor = UIColor.white
        defensePointsLabel.frame = CGRect(x: view.frame.width - (defensePointsLabel.intrinsicContentSize.width) - 15, y: defensePointsButton.frame.minY + (defensePointsButton.frame.height / 2) - 10, width: defensePointsLabel.intrinsicContentSize.width, height: 20)
        view.addSubview(defensePointsLabel)
    }
    
    func initHealthPointsButtonUI() {
        healthPointsButton = RectButton(frame: CGRect(x:0, y:defensePointsButton.frame.maxY, width: view.frame.width, height: 50))
        healthPointsButton.setTitle("Health Points", for: .normal)
        healthPointsButton.titleLabel?.font = UIFont(name: "PokemonGB", size:12.0)
        healthPointsButton.titleLabel?.setTextSpacing(spacing: 0.7)
        healthPointsButton.backgroundColor = UIColor.init(red: 140/255, green: 230/255, blue: 140/255, alpha: 1.0)
        // adjusting label positions
        let button_width = -(healthPointsButton.frame.width) / 2
        let label_width = (healthPointsButton.titleLabel?.intrinsicContentSize.width)! / 2
        healthPointsButton.titleEdgeInsets = UIEdgeInsets(top: 0,left: button_width + label_width + 25, bottom: 0,right: (healthPointsButton.frame.width) / 2 - label_width)
        view.addSubview(healthPointsButton)
        setUpHealthLabel()
        //Add action listener
        healthPointsButton.addTarget(self, action: #selector(healthClicked), for: .touchUpInside)
    }
    
    func setUpHealthLabel() {
        healthPointsLabel = UILabel(frame: CGRect(x: 0, y: healthPointsButton.frame.minY + (healthPointsButton.frame.height / 2) - 10, width: view.frame.width, height: 20))
        healthPointsLabel.text = "0-200"
        healthPointsLabel.font = UIFont(name: "PokemonGB", size: 16.0)
        healthPointsLabel.setTextSpacing(spacing: 0.7)
        healthPointsLabel.textColor = UIColor.white
        healthPointsLabel.frame = CGRect(x: view.frame.width - (healthPointsLabel.intrinsicContentSize.width) - 15, y: healthPointsButton.frame.minY + (healthPointsButton.frame.height / 2) - 10, width: healthPointsLabel.intrinsicContentSize.width, height: 20)
        view.addSubview(healthPointsLabel)
    }
    
    func initPikachu() {
        let difference = (searchButton.frame.minY - healthPointsButton.frame.maxY) / 2
        let imageView = UIImageView(frame: CGRect(x: view.frame.width / 2 - 35, y: healthPointsButton.frame.maxY + difference - 70, width: 130, height: 130))
        imageView.animationImages = pikachu
        imageView.animationDuration = 0.8
        imageView.startAnimating()
        view.addSubview(imageView)
    }
    
    func initSearchButtonUI() {
        searchButton = RectButton(frame: CGRect(x: 0, y: view.frame.maxY - 50, width: view.frame.width / 2, height: 50))
        searchButton.setTitle("SEARCH", for: .normal)
        searchButton.titleLabel?.font = UIFont(name: "PokemonGB", size: 16.0)
        searchButton.titleLabel?.setTextSpacing(spacing: 0.7)
        searchButton.backgroundColor = UIColor.init(red:180/255, green:80/255, blue: 80/255, alpha: 1.0)
        searchButton.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
        view.addSubview(searchButton)
    }
    
    func initRandomButtonUI() {
        randomButton = RectButton(frame: CGRect(x: view.frame.width / 2, y: view.frame.maxY - 50, width: view.frame.width / 2, height: 50))
        randomButton.setTitle("RANDOM", for: .normal)
        randomButton.titleLabel?.font = UIFont(name: "PokemonGB", size: 16.0)
        randomButton.titleLabel?.setTextSpacing(spacing: 0.7)
        randomButton.backgroundColor = UIColor.init(red:190/255, green:110/255, blue: 110/255, alpha: 1.0)
        randomButton.addTarget(self, action: #selector(randomButtonClicked), for: .touchUpInside)
        view.addSubview(randomButton)
    }
    
    func searchButtonClicked() {
        searchBarText = searchBar.text
        generateList()
    }
    
    func randomButtonClicked() {
        generateRandom()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toList" {
            let listVC = segue.destination as! PokemonListViewController
            pokemonsToPass = pokemonsToPass.sorted{$0.name < $1.name} //sort alphabetically
            listVC.pokemons = self.pokemonsToPass
        }
        if segue.identifier == "toDirectProfile" {
            //            let profileVC = segue.destination.childViewControllers[0] as! ProfileViewController
            ProfileViewController.currentPokemon = pokemonDirectPass
        }
    }
    
    func produceIntegerRangeError() {
        let alert = UIAlertController(title: "Error", message: "Please enter a valid integer between 0 and 200", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //Event Listeners
    func attackClicked(sender:RectButton!) {
        alertController = UIAlertController(title: "Minimum ATK", message: "", preferredStyle: .alert)
        alertController!.addTextField(
            configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Enter minimum attack"
        })
        let action = UIAlertAction(title: "Submit",
                                   style: UIAlertActionStyle.default,
                                   handler: {[weak self]
                                    (paramAction:UIAlertAction!) in
                                    if let textFields = self?.alertController?.textFields{
                                        let theTextFields = textFields as [UITextField]
                                        let enteredText = theTextFields[0].text
                                        if let number = Int(enteredText!) {
                                            let num = Int(enteredText!)!
                                            if num >= 0 && num <= 200 {
                                                self?.minATK = Int(enteredText!)!
                                                self?.attackPointsLabel.text = enteredText! + "-200"
                                                self?.resizeAttackLabel()
                                            } else {
                                                self?.produceIntegerRangeError()
                                            }
                                        } else {
                                            self?.produceIntegerRangeError()
                                        }
                                    }
        })
        alertController?.addAction(action)
        self.present(alertController!, animated: true, completion: nil)
    }
    
    func defenseClicked(sender:RectButton!) {
        alertController = UIAlertController(title: "Minimum DEF", message: "", preferredStyle: .alert)
        alertController!.addTextField(
            configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Enter minimum defense"
        })
        let action = UIAlertAction(title: "Submit",
                                   style: UIAlertActionStyle.default,
                                   handler: {[weak self]
                                    (paramAction:UIAlertAction!) in
                                    if let textFields = self?.alertController?.textFields{
                                        let theTextFields = textFields as [UITextField]
                                        let enteredText = theTextFields[0].text
                                        if let number = Int(enteredText!) {
                                            let num = Int(enteredText!)!
                                            if num >= 0 && num <= 200 {
                                                self?.minDEF = Int(enteredText!)!
                                                self?.defensePointsLabel.text = enteredText! + "-200"
                                                self?.resizeDefenseLabel()
                                            } else {
                                                self?.produceIntegerRangeError()
                                            }
                                        } else {
                                            self?.produceIntegerRangeError()
                                        }
                                    }
        })
        alertController?.addAction(action)
        self.present(alertController!, animated: true, completion: nil)
    }
    
    func healthClicked(sender:RectButton!) {
        alertController = UIAlertController(title: "Minimum HP", message: "", preferredStyle: .alert)
        alertController!.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Enter minimum health"
        })
        let action = UIAlertAction(title: "Submit",
                                   style: UIAlertActionStyle.default,
                                   handler: {[weak self]
                                    (paramAction:UIAlertAction!) in
                                    if let textFields = self?.alertController?.textFields{
                                        let theTextFields = textFields as [UITextField]
                                        let enteredText = theTextFields[0].text
                                        if let number = Int(enteredText!) {
                                            let num = Int(enteredText!)!
                                            if num >= 0 && num <= 200 {
                                                self?.minHP = Int(enteredText!)!
                                                self?.healthPointsLabel.text = enteredText! + "-200"
                                                self?.resizeHealthLabel()
                                            } else {
                                                self?.produceIntegerRangeError()
                                            }
                                        } else {
                                            self?.produceIntegerRangeError()
                                        }
                                    }
        })
        alertController?.addAction(action)
        self.present(alertController!, animated: true, completion: nil)
    }
    
    //re-adjusting label position after changing values
    func resizeAttackLabel() {
        attackPointsLabel.frame = CGRect(x: view.frame.width - (attackPointsLabel.intrinsicContentSize.width) - 15, y: attackPointsButton.frame.minY + (attackPointsButton.frame.height / 2) - 10, width: attackPointsLabel.intrinsicContentSize.width, height: 20)
    }
    
    func resizeDefenseLabel() {
        defensePointsLabel.frame = CGRect(x: view.frame.width - (defensePointsLabel.intrinsicContentSize.width) - 15, y: defensePointsButton.frame.minY + (defensePointsButton.frame.height / 2) - 10, width: defensePointsLabel.intrinsicContentSize.width, height: 20)
    }
    
    func resizeHealthLabel() {
        healthPointsLabel.frame = CGRect(x: view.frame.width - (healthPointsLabel.intrinsicContentSize.width) - 15, y: healthPointsButton.frame.minY + (healthPointsButton.frame.height / 2) - 10, width: healthPointsLabel.intrinsicContentSize.width, height: 20)
    }
    
    // GENERATE LIST OF POKEMON THAT MATCH CRITERIA OR 20 RANDOM
    func generateList() {
        pokemonsToPass.removeAll()
        if searchBarText != "" {
            generateWithSearchText()
        } else {
            generateWithoutSearchText()
        }
    }
    //DONT FORGET INDIVUDUAL
    // if user entered something into search bar, this function is called
    func generateWithSearchText(){
        let selectedTypesSet: Set<String> = Set(typesToSearch)
        for pokemon in pokemons {
            if pokemon.name.lowercased() == searchBarText.lowercased() || Int(searchBarText) == pokemon.number {
                pokemonDirectPass = pokemon
                performSegue(withIdentifier: "toDirectProfile", sender: self)
                return
            } else if pokemon.name.lowercased().contains(searchBarText.lowercased()) {
                let pokemonTypeSet: Set<String> = Set(pokemon.types)
                if selectedTypesSet.intersection(pokemonTypeSet).count > 0 && pokemon.attack >= minATK && pokemon.defense > minDEF && pokemon.health > minHP { //if pokemon's types fall under search types and stat conditions met
                    pokemonsToPass.append(pokemon)
                }
            }
        }
        performSegue(withIdentifier: "toList", sender: nil)
    }
    
    func generateWithoutSearchText(){
        let selectedTypesSet: Set<String> = Set(typesToSearch)
        for pokemon in pokemons {
            let pokemonTypeSet: Set<String> = Set(pokemon.types)
            if selectedTypesSet.intersection(pokemonTypeSet).count > 0 && pokemon.attack >= minATK && pokemon.defense > minDEF && pokemon.health > minHP {
                pokemonsToPass.append(pokemon)
            }
        }
        performSegue(withIdentifier: "toList", sender: nil)
        
    }
    
    func generateRandom() {
        pokemonsToPass.removeAll()
        for _ in 0..<20 {
            let randomIndex = pickRandomIndex(index: Int(arc4random_uniform(UInt32(pokemons.count))))
            randomIndexesPicked.append(randomIndex)
            pokemonsToPass.append(pokemons[randomIndex])
        }
        randomIndexesPicked.removeAll()
        performSegue(withIdentifier: "toList", sender: nil)
    }
    
    func pickRandomIndex( index: Int) -> Int {
        var i = index
        while randomIndexesPicked.contains(i) {
            i = Int(arc4random_uniform(UInt32(pokemons.count)))
        }
        return i
    }
    
}

extension UILabel{
    func setTextSpacing(spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: text!)
        if textAlignment == .center || textAlignment == .right {
            attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSRange(location: 0, length: attributedString.length-1))
        } else {
            attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSRange(location: 0, length: attributedString.length))
        }
        attributedText = attributedString
    }
}



