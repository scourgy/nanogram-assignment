//
//  LossyArray.swift
//  nanogram
//
//  Created by Galin Yonchev on 9.11.26.
//

import Foundation

struct LossyArray<Element: Decodable>: Decodable {
    
    let elements: [Element]
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var elements: [Element] = []
        
        while !container.isAtEnd {
            // Decoding through the wrapper never throws, so the container moves past a bad element
            // instead of getting stuck on it forever.
            let wrapper = try container.decode(FailableElement<Element>.self)
            if let element = wrapper.element {
                elements.append(element)
            }
        }
        
        self.elements = elements
    }
    
}

private struct FailableElement<Element: Decodable>: Decodable {
    
    let element: Element?
    
    init(from decoder: Decoder) {
        do {
            element = try Element(from: decoder)
        } catch {
            element = nil
            print("[WARNING] Dropped a malformed \(Element.self): \(error)")
        }
    }
    
}
