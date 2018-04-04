

import UIKit

class GalleryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewNavigationBar: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    var arrGalleryImages = [URL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.arrGalleryImages = self.fetchGalleryData().reversed()
        if (self.arrGalleryImages.count == 0) {
            self.tblView.isHidden = true
            self.lblNoData.isHidden = false
        }else{
            self.tblView.isHidden = false
            self.lblNoData.isHidden = true
        }
        self.tblView.tableFooterView = UIView()
        self.tblView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchGalleryData() -> [URL] {
        return Helper.shared.getFilesFromDirectory(dirName: Constant.directoryName)
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    //MARK:- UITableView Delegates & DataSources
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.arrGalleryImages.count == 0) {
            return 0
        }else{
            return self.arrGalleryImages.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GalleryCell = tableView.dequeueReusableCell(withIdentifier: "GalleryCell") as! GalleryCell
        cell.imgView.image = UIImage(contentsOfFile: arrGalleryImages[indexPath.row].path)
        cell.lblTitle.text = (arrGalleryImages[indexPath.row].path as NSString).lastPathComponent
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objGalleryDetailVC: GalleryDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "GalleryDetailVC") as! GalleryDetailVC
        objGalleryDetailVC.strTitle = (arrGalleryImages[indexPath.row].path as NSString).lastPathComponent
        objGalleryDetailVC.currentIndexPath = indexPath
        objGalleryDetailVC.arrGalleryDetailImages = arrGalleryImages
        self.navigationController?.pushViewController(objGalleryDetailVC, animated: true)        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let strPath = arrGalleryImages[indexPath.row].path
             Helper.shared.removeFileFromDocDir(path: strPath)
             self.arrGalleryImages = self.fetchGalleryData().reversed()
            tblView.reloadData()
        }
    }
}
