//
//  AnswerTableViewcell.swift
//  TestExam
//
//  Created by Ngo Bao Ngoc on 28/03/2021.
//

import UIKit

class AnswerTableViewcell: UITableViewCell {

    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var answerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindCell(with answer: AnswerModel, question: QuestionModel) {
        answerLabel.text = answer.value
        if answer.isSelect {
            selectButton.setImage(UIImage(named: "selected"), for: .normal)
        } else {
            selectButton.setImage(UIImage(named: "unSelected"), for: .normal)
        }
        
        if question.isResult {
            if answer.id == question.correct {
                answerLabel.textColor = .green
            } else {
                answerLabel.textColor = .red
            }
        } else {
            answerLabel.textColor = .black
        }
    }
    
}
