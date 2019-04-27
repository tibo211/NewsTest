import UIKit

class MenuBarView: UIView {
    
    let menuItemID = "menuItem"
    var updateTableView:((_ category:String)->())? = nil
    
    var selectedIndex:Int = -1
    
    lazy var categoryCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
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
        categoryCollectionView.register(MenuBarItem.self, forCellWithReuseIdentifier: menuItemID)
        
        //add the menuCollectionView to the menu bar
        addSubview(categoryCollectionView)
        
        //set the menuCollectionView size to match with the menu bar
        NSLayoutConstraint.activate([
            categoryCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            categoryCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            categoryCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
    }
    
    
    
}

extension MenuBarView:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DatabaseManager.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: menuItemID, for: indexPath) as! MenuBarItem
       
        if selectedIndex == -1 {
            cell.selectMenuItem()
            selectedIndex = 0
            updateNewsFeed(index: 0)
        } else {
            cell.deselectMenuItem()
        }
        
        cell.set(text: DatabaseManager.sections[indexPath.item])
        return cell
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
