//
//  Favourite.swift
//  law.handbook
//
//  Created by Hugh Liu on 26/2/2022.
//

import Foundation
import CoreData
import SwiftUI

struct FavouiteView: View {

    @FetchRequest(sortDescriptors: [],
                  predicate: nil,
                  animation: .default) var favourites: FetchedResults<Favouite>
    @Environment(\.managedObjectContext) var moc

    func group(_ result : FetchedResults<Favouite>)-> [[Favouite]] {
        return Dictionary(grouping: result) { $0.law! }
        .sorted {$0.value.first!.law! < $1.value.first!.law!}
        .map { $0.value }
    }

    private var favArr: Array<Array<Favouite>>  {
        return group(favourites)
    }

    var body: some View {
        if favArr.isEmpty {
            Text("还没有任何收藏呢～")
        } else{
            List{
                ForEach(Array(favArr.enumerated()), id: \.offset) { (index, arr) in
                    Section(header: Text(arr.first!.law!)){
                        ForEach(arr, id:\.id){ fav in
                            Text(fav.content ?? "")
                                .swipeActions {
                                    Button {
                                        withAnimation(.spring()){
                                            moc.delete(fav)
                                            try? moc.save()
                                        }
                                    } label: {
                                        Label("移除", systemImage: "heart.slash")
                                    }
                                    .tint(.red)
                                }
                        }
                    }
                }
            }
        }
    }
}