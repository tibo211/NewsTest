import UIKit

class MenuBarView: UIView {
    
    let menuItemID = "menuItem"
    
    lazy var menuCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.allowsSelection = true
        return collectionView
    }()
    
    //initializer called from xib file or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //initializer called from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView(){
        menuCollectionView.register(MenuBarItem.self, forCellWithReuseIdentifier: menuItemID)
        
        //add the menuCollectionView to the menu bar
        addSubview(menuCollectionView)
        
        //set the menuCollectionView size to match with the menu bar
        NSLayoutConstraint.activate([
            menuCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            menuCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            menuCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            menuCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
    }
    
}

extension MenuBarView:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //TODO: return the actual number of items
        return DatabaseManager.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = menuCollectionView.dequeueReusableCell(withReuseIdentifier: menuItemID, for: indexPath) as! MenuBarItem
        cell.deselectMenuItem()
        cell.set(text: DatabaseManager.sections[indexPath.item])
        return cell
    }
}

extension MenuBarView:UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MenuBarItem
        cell.selectMenuItem()
        menuCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MenuBarItem
        cell.deselectMenuItem()
    }
    
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
        let centerPosition = menuCollectionView.contentOffset.x + bounds.width/2
        
        //deselect menu items
        menuCollectionView.visibleCells.forEach{ ($0 as! MenuBarItem).deselectMenuItem() }
        
        //find the closest item in the collection view to the center
        let closeToCenterItem = menuCollectionView.visibleCells.min { abs($0.center.x - centerPosition) < abs($1.center.x - centerPosition)}
        
        //if we found anyting get the position of the item and scroll the view to the item
        if closeToCenterItem != nil {
            guard let indexPath = menuCollectionView.indexPath(for: closeToCenterItem!) else { return }
            
            //select menu item
            (closeToCenterItem! as! MenuBarItem).selectMenuItem()
            menuCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            //TODO: select center item
        }
    }
}

extension MenuBarView:UICollectionViewDelegateFlowLayout {
    
    //set the size for a cell in the collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: bounds.width/3, height: 50)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets(top: 0,
                           left: bounds.width/2 - bounds.width/6,
                           bottom: 0,
                           right: bounds.width/2 - bounds.width/6)
    }
}
