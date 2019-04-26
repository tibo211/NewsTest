import UIKit

class MenuBarView: UIView {
    let edgeInset:CGFloat = 400
    
    lazy var menuCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = true
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
        menuCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "newsType")
        
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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = menuCollectionView.dequeueReusableCell(withReuseIdentifier: "newsType", for: indexPath)
        cell.backgroundColor = .white
        return cell
    }
}

extension MenuBarView:UICollectionViewDelegate {
    
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
        
        //find the closest item in the collection view to the center
        let closeToCenterItem = menuCollectionView.visibleCells.min { (cell1, cell2) -> Bool in
            return abs(cell1.center.x - centerPosition) < abs(cell2.center.x - centerPosition)
        }
        
        //if we found anyting get the position of the item and scroll the view to the item
        if closeToCenterItem != nil {
            guard let indexPath = menuCollectionView.indexPath(for: closeToCenterItem!) else { return }
            
            menuCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

extension MenuBarView:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: bounds.width/2 - 100, bottom: 0, right:  bounds.width/2 - 100)
    }
}
