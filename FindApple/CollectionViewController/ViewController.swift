import UIKit

class ViewController: UIViewController {
    // MARK: Property
    var myimgSet: [UIImage] = []
    var isSelected: [Bool] = []
    
    private let model = Model(myImg: UIImage.backGround)
    
    // collectionView setting
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Delegate Set
        model.delegate = self
        model.divImg(tileSize: 150)
        
        
        self.initIsSelected()
        
        self.view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    func initIsSelected() {
        for _ in 0...self.myimgSet.count {
            self.isSelected.append(false)
        }
    }
    
}

// MARK: UICollectionViewDataSourceDelegate
extension ViewController: UICollectionViewDataSource {
    // CollectionView length
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.myimgSet.count
    }

    // CollectionView Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath)

        guard let cell = cell as? Cell else { return cell }
        
        // touch event 등록 (touch 시 img가 로드되고, 아니면 회색)
        cell.updateImage(self.myimgSet[indexPath.item], isVisible: self.isSelected[indexPath.item])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout Implementation
extension ViewController: UICollectionViewDelegateFlowLayout {
    // CollectionView frame setting
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (view.frame.width - 2.0) / 3.0
        return CGSize(width: size, height: size)
    }
    
    // CollectionView isSelected setting
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        self.isSelected[indexPath.item] = true
        // cell이 사과과 포함되어 있다면? => 승리 조건 구현
        collectionView.reloadData()
        return true
    }
}

// MARK: ModelDelegate Implementaion
extension ViewController: ModelDelegate {
    // MARK: ModelDelegate & CollectionViewDelegate
    func modelDidFinishDividingImages(imgSet: [UIImage]?) {
        self.myimgSet = imgSet!
        self.collectionView.reloadData()
    }
}
