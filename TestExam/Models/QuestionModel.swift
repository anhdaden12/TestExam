//
//  QuestionModel.swift
//  TestExam
//
//  Created by Ngo Bao Ngoc on 28/03/2021.
//

import Foundation

class Exams: Codable {
    var exams: [Exam]
    
    internal init(exams: [Exam]) {
        self.exams = exams
    }
}

class Exam: Codable {
    var datas: [[QuestionModel]]
}

class QuestionModel: Codable {
    var title: String
    var isResult: Bool
    var correct: String
    var answers: [AnswerModel]
}

class AnswerModel: Codable {
    var isSelect: Bool
    var id: String
    var value: String
}


/*
 //
 //  QuestionModel.swift
 //  CHFIExample
 //
 //  Created by Apple on 2/23/21.
 //  Copyright © 2021 NgocNB. All rights reserved.
 //

 import Foundation
 //list exam -> exam -> list question -> detail question
 class Exams: Codable {
     var exams: [Exam]
     
     internal init(exams: [Exam]) {
         self.exams = exams
     }
 }

 class Exam: Codable {
     var listExam: [QuestionModel]
     internal init(listExam: [QuestionModel]) {
         self.listExam = listExam
     }
 }

 class QuestionModel: Codable {
     var title: String
     var correct: String
     var answers: [AnswerModel]
     
     internal init(title: String, correctAnswerID: String, answers: [AnswerModel]) {
         self.title = title
         self.correct = correctAnswerID
         self.answers = answers
     }
 }

 class AnswerModel: Codable {
     var id: String
     var value: String
     
     internal init(id: String, value: String) {
         self.id = id
         self.value = value
     }
 }



 */

