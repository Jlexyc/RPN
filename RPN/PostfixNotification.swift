//
//  PostfixNotification.swift
//  RPN
//
//  Created by Oleksii Kozulin on 5/7/16.
//  Copyright © 2016 Oleksii Kozulin. All rights reserved.
//

import Foundation

struct Stack<Element> {
    var items = [Element]()
    mutating func push(item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    
    func lastElement() -> Element? {
        return items.last
    }
    
    func isEmpty() -> Bool {
        return items.isEmpty
    }
}


class PostfixNotation {
    var inflixString = ""
    
    init(inflix: String) {
        inflixString = inflix
    }
    
    class func ifSymbolSupported(symbol: Character) -> Bool {
        let supportedSymbols: Set<Character> = ["+", "-", "/", "*", "(", ")"]
        return supportedSymbols.contains(symbol)
    }
    
    class func ifNumberSupported(symbol: Character) -> Bool {
        let supportedNumbers: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return supportedNumbers.contains(symbol)
    }
    
    class func ifOperationSupported(symbol: Character) -> Bool {
        let supportedOperation: Set<Character> = ["+", "-", "/", "*"]
        return supportedOperation.contains(symbol)
    }
    
    class func ifOpenParanthesis(symbol: Character) -> Bool {
        return symbol == Character("(")
    }
    
    class func ifCloseParanthesis(symbol: Character) -> Bool {
        return symbol == Character(")")
    }
    
    class func priorityForOperation(operation: String) -> Int {
        let resultValue = 0
        let operatorsPriorities = ["+": 2, "-": 2, "/": 3, "*": 3]
        if let resultPriority = operatorsPriorities[operation] {
            return resultPriority
        }
        return resultValue
    }
    
    func isNumber(Number: String) -> Bool {
        let numberCheck = Int(Number)
        if  numberCheck != nil {
            return true
        }
        return false
    }
    
    func readSymbol(startIndex: String.CharacterView.Index) -> (string: String, currentIndex: String.CharacterView.Index) {
        var returnIndex = startIndex
        let lastIndex = inflixString.endIndex
        if startIndex == lastIndex {
            return ("", startIndex)
        }
        let char = inflixString[startIndex]
        if PostfixNotation.ifSymbolSupported(char) {
            returnIndex = startIndex.advancedBy(1)
        }
        else {
            return ("", startIndex)
        }
        return ("\(char)", returnIndex)
    }
    
    func readNumber(startIndex: String.CharacterView.Index) -> (string: String, currentIndex: String.CharacterView.Index) {
        let lastIndex = inflixString.endIndex
        if lastIndex == startIndex {
            return ("", startIndex)
        }
        
        var numberString = ""
        var index = startIndex
        var char: Character = inflixString[index]
        
        while PostfixNotation.ifNumberSupported(char) {
            numberString.append(char)
            index = index.advancedBy(1)
            if(index == lastIndex) {
                break
            }
            char = inflixString[index]
        }
        
        return (numberString, index)
    }
    
    func postfixNotation() -> Array<String> {
        var resultArray: Array<String> = []
        var operatorsStack = Stack<String>()
        
        var currentResult = ""
        var currentIndex = inflixString.startIndex
        
        repeat {
            var result = self.readNumber(currentIndex)
            currentResult = result.string
            currentIndex = result.currentIndex
            if !currentResult.isEmpty {
                resultArray.append(result.string)
            }
            
            result = self.readSymbol(currentIndex)
            currentResult = result.string
            currentIndex = result.currentIndex
            
            if !currentResult.isEmpty {
                let symbol = currentResult[currentResult.startIndex]
                if PostfixNotation.ifOpenParanthesis(symbol) {
                    operatorsStack.push(currentResult)
                }
                else if PostfixNotation.ifCloseParanthesis(symbol) {
                    var stackElement = operatorsStack.pop()
                    var charStackElement = stackElement[stackElement.startIndex]
                    while !PostfixNotation.ifOpenParanthesis(charStackElement) {
                        resultArray.append(stackElement)
                        if(operatorsStack.isEmpty()) {
                            print("i'm here")
                            break
                        }
                        stackElement = operatorsStack.pop()
                        charStackElement = stackElement[stackElement.startIndex]
                    }
                }
                else if PostfixNotation.ifSymbolSupported(symbol) {
                    if let lastElement = operatorsStack.lastElement() {
                        let priorityPrevOp = PostfixNotation.priorityForOperation(lastElement)
                        let priorityCurrOp = PostfixNotation.priorityForOperation(currentResult)
                        if(priorityPrevOp >= priorityCurrOp) {
                            resultArray.append(operatorsStack.pop())
                        }
                    }
                    operatorsStack.push(currentResult)
                }
            }
            
        } while currentResult != ""
        
        while !operatorsStack.isEmpty() {
            resultArray.append(operatorsStack.pop())
        }
        return resultArray
    }
    
    func obtainResult() -> Int {
        var RPNStack = Stack<String>()
        var currentElement = ""
        
        var resultArray = self.postfixNotation()
        
        repeat {
            currentElement = resultArray.removeFirst()
            if self.isNumber(currentElement) {
                RPNStack.push(currentElement)
            }
            else {
                if(RPNStack.isEmpty())
                {
                    break
                }
                let numberY = Int(RPNStack.pop())
                let numberX = Int(RPNStack.pop())
                
                var resultValue = Int(0)
                switch currentElement {
                case "+":
                    resultValue = numberX! + numberY!
                case "-":
                    resultValue = numberX! - numberY!
                case "*":
                    resultValue = numberX! * numberY!
                case "/":
                    resultValue = numberX! / numberY!
                default:
                    resultValue = numberX!
                }
                RPNStack.push("\(resultValue)")
            }
        } while !resultArray.isEmpty
        
        if let result = Int(RPNStack.pop()) {
            return result
        }
        return 0
    }
}