//
//  PokemonListTableViewCell.swift
//  Pokedex
//
//  Created by Boris Yue on 2/16/17.
//  Copyright © 2017 trainingprogram. All rights reserved.
//

import UIKit

class PokemonListTableViewCell: UITableViewCell {

    var name: UILabel!
    var pokeImage: UIImageView!
    var pokeNum: UILabel!
    let textFont = UIFont(name: "Pokemon GB", size: 10.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pokeImage = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        contentView.addSubview(pokeImage)
        name = UILabel(frame: CGRect(x: 25, y: 0, width: 50, height: 50))
        name.textColor = UIColor.black
        name.font = textFont
        contentView.addSubview(name)
        pokeNum = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        pokeNum.textColor = UIColor.black
        pokeNum.font = textFont
        contentView.addSubview(pokeNum)
    }

}
