//
//  HeadTitle.swift
//  BetterRest
//
//  Created by Mahmoud Fouad on 6/9/21.
//

import SwiftUI

struct HeadTitle: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.headline)
    }
}

struct HeadTitle_Previews: PreviewProvider {
    static var previews: some View {
        HeadTitle(text: "hello")
    }
}
