

import UIKit

class GalleryDetailVC: UIViewController, UICollectionViewDelegate ,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{

    //MARK: - Properties
    //MARK: -

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var viewNavigationBar: UIView!
    @IBOutlet var colViewGallery: UICollectionView!
    
    var strTitle = String()
    var currentIndexPath = IndexPath()
    var arrGalleryDetailImages = [URL]()
    var imgShare = UIImage()
   
    //MARK: - View Life Cycle
    //MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblTitle.text = self.strTitle
        colViewGallery.scrollToItem(at: currentIndexPath, at: .centeredHorizontally, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - UICollectionViewDataSource
    //MARK: -
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrGalleryDetailImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryDetailCell", for: indexPath) as! GalleryDetailCell
        cell.imgView.image = UIImage(contentsOfFile: arrGalleryDetailImages[indexPath.row].path)!
        imgShare = cell.imgView.image!
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 5, 0, 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing
        let itemWidth = (collectionView.bounds.size.width - marginsAndInsets).rounded(.down)
        let itemHeight = (collectionView.bounds.size.height - marginsAndInsets).rounded(.down)
        return CGSize(width: itemWidth , height: itemHeight)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell: UICollectionViewCell in colViewGallery.visibleCells {
            let indexPath: IndexPath? = colViewGallery.indexPath(for: cell)
            self.lblTitle.text = (self.arrGalleryDetailImages[(indexPath?.row)!].path as NSString).lastPathComponent
            self.imgShare = UIImage(contentsOfFile: self.arrGalleryDetailImages[(indexPath?.row)!].path)!
        }
    }
    
    //MARK: - UIButton Clicks
    //MARK: -

    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnShareClick(_ sender: Any) {
        Helper.shared.shareImage(Image: imgShare, viewController: self, View: btnShare)
    }
}
