//
//  ExamCollectionViewCell.swift
//  CCNATestExam
//
//  Created by Ngo Bao Ngoc on 27/03/2021.
//

import UIKit

class ExamCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var questionDesTextView: UITextView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    
    var question: QuestionModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AnswerTableViewcell", bundle: nil), forCellReuseIdentifier: "AnswerTableViewcell")
    }
    
    
    
    func bindCell(with ques: QuestionModel) {
        questionDesTextView.text = ques.title
        textViewHeight.constant = questionDesTextView.calculateViewHeightWithCurrentWidth()
        question = ques
        reloadTableView()
    }
    
    
    func reloadTableView() {
        tableView.reloadData()
        tableViewHeight.constant = CGFloat(question.answers.count * 100)
        
        UIView.animate(withDuration: 0, animations: {
//        self.tableView.layoutIfNeeded()
        }) { (complete) in
            var heightOfTableView: CGFloat = 0.0
            // Get visible cells and sum up their heights
            let cells = self.tableView.visibleCells
            for cell in cells {
                heightOfTableView += cell.frame.height
            }
            // Edit heightOfTableViewConstraint's constant to update height of table view
            self.tableViewHeight.constant = heightOfTableView
        }
    }

}


extension ExamCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question.answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerTableViewcell", for: indexPath) as! AnswerTableViewcell
        let item = question.answers[indexPath.row]
        cell.bindCell(with: item, question: question)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = question.answers[indexPath.row]
        question.answers.forEach { (answer) in
            answer.isSelect = item.id == answer.id ? true : false
        }
        reloadTableView()
    }
}

extension UITableView {
    /**
     * Returns all cells in a table
     * ## Examples:
     * tableView.cells // array of cells in a tableview
     */
    public var cells: [UITableViewCell] {
      (0..<self.numberOfSections).indices.map { (sectionIndex: Int) -> [UITableViewCell] in
          (0..<self.numberOfRows(inSection: sectionIndex)).indices.compactMap { (rowIndex: Int) -> UITableViewCell? in
              self.cellForRow(at: IndexPath(row: rowIndex, section: sectionIndex))
          }
      }.flatMap { $0 }
    }
}

extension UITextView {
    // Note: This will trigger a text rendering!
    func calculateViewHeightWithCurrentWidth() -> CGFloat {
        let textWidth = self.frame.width -
            self.textContainerInset.left -
            self.textContainerInset.right -
            self.textContainer.lineFragmentPadding * 2.0 -
            self.contentInset.left -
            self.contentInset.right
        
        let maxSize = CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude)
        var calculatedSize = self.attributedText.boundingRect(with: maxSize,
                                                              options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                                      context: nil).size
        calculatedSize.height += self.textContainerInset.top
        calculatedSize.height += self.textContainerInset.bottom
        
        return ceil(calculatedSize.height)
    }
}
