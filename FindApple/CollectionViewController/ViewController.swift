import UIKit

// Custom Cell Class
class Cell: UICollectionViewCell {
    static let identifier = "Cell"
    
    var imgview: UIImageView = {
//        let imgview = UIImageView(frame: CGRect(x: 0, y: 0, width: 150.0, height: 150.0))
        let imgview = UIImageView()
        imgview.backgroundColor = .darkGray
        return imgview
    }()
    
    // 사과를 위한 더 작은 UIIMageView 를 만듦
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialize code
    }
    
    func updateImage(_ img: UIImage?, isVisible: Bool?) { // isHidden 이나 별도의 enum을 선언해서쓰자
        self.contentView.addSubview(self.imgview)
        if let status = isVisible,
           status {
            self.imgview.image = img
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgview.image = nil
        imgview.backgroundColor = .darkGray
    }
}

class ViewController: UIViewController {
    // MARK: Property
    var myimgSet: [UIImage] = []
    var isSelected: [Bool] = []
    
    //MARK: Img Model & CollectionView Model
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
        
        self.view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.initIsSelected()
        self.makeApple()
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    enum MakeAppleError: LocalizedError {
        case insufficientImage
        
        var errorDescription: String? {
            switch self {
            case .insufficientImage: return "이미지 수가 부족합니다."
            }
        }
    }
    
    // TODO: 모델로 옮겨보기
    // MARK: Custom Function
    func makeApple() {
        var newImage = UIImage()
        let apple: UIImage = .apple
        
        guard self.myimgSet.count > 0 else { return }
        
        // 1. random으로 imgSet 중 하나를 고르기 & 그 Index도 얻기
        guard let randomImage: UIImage = self.myimgSet.randomElement(),
              let randomIndex: Int = (self.myimgSet.firstIndex { $0 === randomImage }) else { return }
        
        // 2. 그 요소에 사과 모양 이미지를 랜덤으로 배치
        newImage = putImageToAnotherImage(backGround: randomImage, toPutImage: apple, position: CGPoint(x: randomImage.size.width / 2.0 , y: randomImage.size.height / 2.0))
        // 3. myImgSet에 반영
        self.myimgSet[randomIndex] = newImage
    }
    
    func initIsSelected() {
        for _ in 0...self.myimgSet.count {
            self.isSelected.append(false)
        }
    }
    
    // TODO: Model 로 옮겨보기
    // 실제로 Apple을 1장에 랜덤 배치하는 함수
    func putImageToAnotherImage(backGround: UIImage, toPutImage: UIImage, position: CGPoint) -> UIImage {
        //CG 지원 이미지 만들기 위한 Graphic Renderer 생성
        let renderer = UIGraphicsImageRenderer(size: backGround.size)
        // renderer에 image 생성해 반환(UIImage)
        return renderer.image { ctx in
            backGround.draw(in: CGRect(origin: CGPoint.zero, size: backGround.size))
            toPutImage.draw(in: CGRect(origin: position, size: toPutImage.size))
        }
    }
}

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
        self.isSelected[indexPath.item].toggle()
        collectionView.reloadData()
        return true
    }
}

// MARK: ModelDelegate Implementaion
extension ViewController: ModelDelegate {
    // MARK: ModelDelegate & CollectionViewDelegate
    func modelDidFinishDividingImages(imgSet: [UIImage]?) {
        self.myimgSet = imgSet!
    }
}
