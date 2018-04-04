

import UIKit

class LoadVirtualObjectsVC: UIViewController , UICollectionViewDelegate ,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{

    //MARK: - Properties
    //MARK: -
    
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var colViewObjects: UICollectionView!
    
    weak var delegate: LoadVirtualObjectsVCDelegate?
    var arrVirtualObjects = [String]()
    
    //MARK: - View Life Cycles
    //MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrVirtualObjects = ["Arm Chair_A","Arm Chair_B","Arm Chair_C","Arm Chair_D", "Chair_A", "Chair_B","Table_A","Table_B","Sofa_A","Sofa_B","lamp","cup"]
        
        for objectName in arrVirtualObjects{
            if !VirtualModels.availableObjects.contains(VirtualModels(modelName: objectName, fileExtension: ".DAE", thumbImageFilename: objectName)){
                if objectName == "lamp" || objectName == "vase" || objectName == "cup"{
                    VirtualModels.availableObjects.append(VirtualModels(modelName: objectName, fileExtension: ".scn", thumbImageFilename: objectName))
                }else{
                    VirtualModels.availableObjects.append(VirtualModels(modelName: objectName, fileExtension: ".DAE", thumbImageFilename: objectName))
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
 
    }
    
    //MARK: - UIButtonClicks
    //MARK: -

    @IBAction func btnCancelClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - UICollectionViewDataSource
    //MARK: -
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrVirtualObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomAddObjectCell", for: indexPath) as! CustomAddObjectCell
        cell.imgViewObject.image =  UIImage(named:  arrVirtualObjects[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing * CGFloat(3 - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(3)).rounded(.down)
        return CGSize(width: itemWidth - 15 , height: itemWidth - 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UserDefaults.standard.set(indexPath.row, for: .selectedObjectID)
        delegate?.loadVirtualObjectsVC(self, didSelectObjectAt: indexPath.row)
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - LoadVirtualObjectsVCDelegate
 
protocol LoadVirtualObjectsVCDelegate: class {
    func loadVirtualObjectsVC(_: LoadVirtualObjectsVC, didSelectObjectAt index: Int)
}
