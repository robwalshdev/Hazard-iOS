//
//  Votes.swift
//  Road Hazards
//
//  Created by Robert Walsh on 09/02/2021.
//

import SwiftUI

struct Votes: View {
    let upVotes: Int
    let downVotes: Int
    
    var body: some View {
        ProgressView(value: Double(upVotes + 1), total:Double(upVotes + downVotes))
            .progressViewStyle(LinearProgressViewStyle(tint: .green))
            .background(Color.red)
            .frame(maxWidth: screen.width - 120, maxHeight: 5, alignment: .center)
            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
    }
}

struct Votes_Previews: PreviewProvider {
    static var previews: some View {
        Votes(upVotes: 50, downVotes: 20)
    }
}
