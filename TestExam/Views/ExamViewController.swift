//
//  ExamViewController.swift
//  CCNATestExam
//
//  Created by Ngo Bao Ngoc on 27/03/2021.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}

var currentIndex = 0

class ExamViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var countDownLabel: CountdownLabel!
    
    
    var examData: Exam!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.countDownLabel.text = "03:00:00"
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ExamCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ExamCell")
        
        flowLayout.itemSize = CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        
        if let exam = loadJson(fileName: "Questiondata") {
            examData = exam
            collectionView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.countDownLabel.setCountDownTime(minutes: 180*60)
        self.countDownLabel.start()
        self.countDownLabel.countdownDelegate = self
    }
    
    func loadJson(fileName: String) -> Exam? {
       let decoder = JSONDecoder()
       guard
            let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let person = try? decoder.decode(Exam.self, from: data)
       else {
        print("Can not get data from: \(fileName)")
            return nil
       }

       return person
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        currentIndex = 0
    }
    
    @IBAction func previousAction(_ sender: Any) {
        currentIndex -= 1
        if currentIndex > 0 {
            let rect = self.collectionView.layoutAttributesForItem(at: IndexPath(row: currentIndex, section: 0))?.frame
            self.collectionView.scrollRectToVisible(rect!, animated: true)
        } else {
            if let rect = self.collectionView.layoutAttributesForItem(at: IndexPath(row: currentIndex, section: 0))?.frame {
                self.collectionView.scrollRectToVisible(rect, animated: true)
            }
            currentIndex = 0
        }
        print(currentIndex)
    }
    
    @IBAction func afterAction(_ sender: Any) {
        currentIndex += 1
        if currentIndex < examData.datas.first?.count ?? 0 {
            let rect = self.collectionView.layoutAttributesForItem(at: IndexPath(row: currentIndex, section: 0))?.frame
            self.collectionView.scrollRectToVisible(rect!, animated: true)
        } else {
            currentIndex = examData.datas.first?.count ?? 0
        }
        print(currentIndex)
    }
    
    @IBAction func showResult(_ sender: Any) {
        let visibleIndexPaths = collectionView.indexPathsForVisibleItems
        print("your indexPath: \(visibleIndexPaths.first?.row ?? 0)")
        examData.datas.first?[currentIndex].isResult = !(examData.datas.first?[currentIndex].isResult ?? false)
        collectionView.reloadData()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ExamViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return examData.datas.first?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExamCell", for: indexPath) as! ExamCollectionViewCell
        if let item = examData.datas.first?[indexPath.row] {
            cell.bindCell(with: item)
        }
        return cell
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        currentIndex = page
        print("page = \(page)")
    }
    
}

extension ExamViewController: CountdownLabelDelegate {
    func countdownFinished() {
        let alrert = UIAlertController(title: "Test Exam", message: "Your exam is out!", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alrert.addAction(action)
        self.present(alrert, animated: true, completion: nil)
    }
}
