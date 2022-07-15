//
//  Casino.swift
//  RandomUsers
//
//  Created by Elaine Herrera on 15/7/22.
//

import Foundation

//A,1,2,3,4,5,6,7,8,9,10,J,Q,K
class Casino{
    
    var spades: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var hearts: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var clubs: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var diamonds: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    
    init(){
        guard let url = Bundle.main.url(forResource: "dataSet", withExtension: "json"), let data = try? Data(contentsOf: url) else { return }
        guard let dataSet = try? JSONDecoder().decode([Card].self, from: data) else { return }
        for item in dataSet {
            var innerValue = ""
            switch item.value{
            case .string(let string):
                innerValue = string
                break
            case .int(let int):
                innerValue = String(int)
                break
            }
            let position = getPositionInArray(value: innerValue)
            guard position > 0 && position < 14 else {
                return
            }
            switch item.suit{
            case "spades":
                spades[position] += 1
                break
            case "hearts":
                hearts[position] += 1
                break
            case "clubs":
                clubs[position] += 1
                break
            case "diamonds":
                diamonds[position] += 1
                break
            default:
                break
            }
        }
    }
    
    func getPositionInArray(value: String) -> Int {
        switch value{
        case "A":
            return 0
        case "1":
            return 1
        case "2":
            return 2
        case "3":
            return 3
        case "4":
            return 4
        case "5":
            return 5
        case "6":
            return 6
        case "7":
            return 7
        case "8":
            return 8
        case "9":
            return 9
        case "10":
            return 10
        case "J":
            return 11
        case "Q":
            return 12
        case "K":
            return 13
        default:
            return -1
        }
    }
    
    func numberOfFullDecks() -> Int {
        var minValue = Int.max
        var aux = 0
        for item in [0...14].indices {
            aux = min(diamonds[item], min(clubs[item], min(hearts[item], spades[item])))
            minValue = min(aux, minValue)
            
        }
        return minValue
    }
}

struct Card: Decodable{
    let suit: String
    let value: CardValue
}

enum CardValue: Decodable{
    case int(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
        if let int = try? decoder.singleValueContainer().decode(Int.self) {
            self = .int(int)
            return
        }
        if let str = try? decoder.singleValueContainer ().decode (String.self) {
            self = .string(str)
            return
        }
        throw ClientError.parseError
    }
}
