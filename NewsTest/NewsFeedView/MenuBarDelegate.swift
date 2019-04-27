//
//  MenuBarDelegate.swift
//  NewsTest
//
//  Created by Felföldy Tibor on 2019. 04. 26..
//  Copyright © 2019. Felföldy Tibor. All rights reserved.
//

import UIKit

//this extension handles the UI interactions with the collection view
extension MenuBarView:UICollectionViewDelegate {
    
    //return true to enable item selection with tap gesture
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //if the user taps an item it should be selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectItem(indexPath)
    }
    
    //if the user selects an other item the last selected item should be deselected
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MenuBarItem
        cell.deselectMenuItem()
    }
    
    //scroll the middle item to center when the user stop draging
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollItemToCenter()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollItemToCenter()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollItemToCenter()
    }
    
    
    func scrollItemToCenter(){
        //calculate the center position of the scroll view
        let centerPosition = categoryCollectionView.contentOffset.x + bounds.width/2
        
        //find the closest item in the collection view to the center
        let closeToCenterItem = categoryCollectionView.visibleCells.min {
            abs($0.center.x - centerPosition) < abs($1.center.x - centerPosition)
        }
        
        //if it found anyting get the position of the item and scroll the view to the item
        if closeToCenterItem != nil {
            guard let indexPath = categoryCollectionView.indexPath(for: closeToCenterItem!) else { return }
            
            //select menu item
            selectItem(indexPath)
        }
    }
    
    func updateNewsFeed(index:Int){
        guard let updateTable = updateTableView else {
            print("not initialized")
            return
        }
        let selectedCategory = DatabaseManager.sections[index]
        
        updateTable(selectedCategory)
    }
    
    func selectItem(_ indexPath:IndexPath) {
        //deselect menu items
        categoryCollectionView.visibleCells.forEach{ ($0 as! MenuBarItem).deselectMenuItem() }
        
        let cell = categoryCollectionView.cellForItem(at: indexPath) as! MenuBarItem
        cell.selectMenuItem()
        selectedIndex = indexPath.item
        
        categoryCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        
        updateNewsFeed(index: indexPath.item)
    }
}
