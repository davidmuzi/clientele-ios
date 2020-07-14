//
//  ContentView.swift
//  SwiftUIActivityIndicator
//
//  Created by Darren Leak on 2019/11/12.
//  Copyright © 2019 ProgrammingWithSwift. All rights reserved.
//
 
import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView()
    }

    func updateUIView(_ uiView: UIActivityIndicatorView,
                      context: Context) {
        uiView.startAnimating()
    }
}
