//
//  Colour+Extensions.swift
//  Clientele
//
//  Created by David Muzi on 2020-07-08.
//

import SwiftUI

extension UIColor {
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

// https://gist.githubusercontent.com/ajkendall/191932d44dc3def1e96522bc429a03ed/raw/033834a3167c52c232e85dbac9532648f578875e/HandlingColorsSwiftUI-Step2.swift
extension Color {
    func uiColor() -> UIColor {
        let hex = self.description
        let space = CharacterSet(charactersIn: " ")
        let trim = hex.trimmingCharacters(in: space)
        let value = hex.first != "#" ? "#\(trim)" : trim
        let values = Array(value)

        func radixValue(_ index: Int) -> CGFloat? {
            var result: CGFloat?
            if values.count > index + 1 {
                var input = "\(values[index])\(values[index + 1])"
                if values[index] == "0" {
                    input = "\(values[index + 1])"
                }
                if let val = Int(input, radix: 16) {
                    result = CGFloat(val)
                }
            }
            return result
        }
        
        var rgb = (red: CGFloat(0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(0))
        if let outputR = radixValue(1) { rgb.red = outputR / 255 }
        if let outputG = radixValue(3) { rgb.green = outputG / 255 }
        if let outputB = radixValue(5) { rgb.blue = outputB / 255 }
        if let outputA = radixValue(7) { rgb.alpha = outputA / 255 }
        return UIColor(red: rgb.red, green: rgb.green, blue: rgb.blue, alpha: rgb.alpha)
    }
}
