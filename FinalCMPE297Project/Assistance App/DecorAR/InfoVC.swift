

import UIKit

class InfoVC: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let htmlFile  = Bundle.main.path(forResource: "info", ofType: "html")!
        let html = try? String(contentsOfFile: htmlFile, encoding: String.Encoding.utf8)
        self.webView.loadHTMLString(html!, baseURL: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
