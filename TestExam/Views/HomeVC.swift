//
//  HomeVC.swift
//  CCNATestExam
//
//  Created by Ngo Bao Ngoc on 25/03/2021.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countDownLabel: CountdownLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        countDownLabel.cancel()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        countDownLabel.setCountDownTime(minutes: 0.5*60)
    }
    
    
    @IBAction func startTimer(_ sender: Any) {
        countDownLabel.start()
    }
    
    @IBAction func stopTimer(_ sender: Any) {
//        countDownLabel.cancel()
    }

    @IBAction func pause(_ sender: Any) {
//        countDownLabel.pause()
    }
    
    @IBAction func resumeTimer(_ sender: Any) {
//        countDownLabel.start()
    }

}


extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.text = "row \(indexPath.row + 1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = ExamViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        let vc = TestViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        print("You select at row \(indexPath.row + 1)")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("deselect at row \(indexPath.row + 1)")
    }
}



extension Decodable {
  static func parse(jsonFile: String) -> Self? {
    guard let url = Bundle.main.url(forResource: jsonFile, withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let output = try? JSONDecoder().decode(self, from: data)
        else {
      return nil
    }

    return output
  }
}
