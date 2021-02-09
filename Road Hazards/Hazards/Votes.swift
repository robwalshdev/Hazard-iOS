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
        HStack(alignment: .center, spacing: 0) {
            if upVotes >= downVotes {
                Circle()
                    .fill(Color("RedVote"))
                    .frame(width: 20, height: 20)
                    .shadow(radius: 5)
                    .offset(x:50,y:10)
                Circle()
                    .fill(Color("GreenVote"))
                    .frame(width: 40, height: 40)
                    .shadow(radius: 5)
            } else {
                Circle()
                    .fill(Color("GreenVote"))
                    .frame(width: 20, height: 20)
                    .shadow(radius: 5)
                    .offset(x:50,y:10)
                Circle()
                    .fill(Color("RedVote"))
                    .frame(width: 40, height: 40)
                    .shadow(radius: 5)
            }
            
            
        }
        
    }
}

struct Votes_Previews: PreviewProvider {
    static var previews: some View {
        Votes(upVotes: 10, downVotes: 20)
    }
}
