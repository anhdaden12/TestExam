//
//  TestViewController.swift
//  CCNATestExam
//
//  Created by Ngo Bao Ngoc on 26/03/2021.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var collectionVIew: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let collectionViewLayout = ReportLayout();
        collectionVIew.collectionViewLayout = collectionViewLayout
        
        collectionViewLayout.numberOfColumns = 9
        collectionViewLayout.titleArray = ["STT", "HCM 305 Tô Hiến Thành", "HuongTTM", "4,238,135,455 " , "169,525,418 ", "% HT target" , "% tăng giảm vs DS tháng trước", "Tổng SL", "Total HS Trả góp"]
        collectionViewLayout.numberColumnFixed = 2
        
        collectionVIew.delegate = self
        collectionVIew.dataSource = self
        collectionVIew.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")

    }

}

extension TestViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath)
        switch indexPath.section {
        case 0:
            cell.backgroundColor = .red
            return cell
        case 1:
            cell.backgroundColor = .orange
            return cell
        case 2:
            cell.backgroundColor = .blue
            return cell
        case 3:
            cell.backgroundColor = .orange
            return cell
        case 4:
            cell.backgroundColor = .green
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}


class ReportLayout: UICollectionViewLayout {
    var numberOfColumns = 0;
    var titleArray: [String] = [];
    
    var itemAttributes = [[UICollectionViewLayoutAttributes]]();
    var itemsSize = [CGSize]()
    var contentSize: CGSize = .zero
    var numberColumnFixed = 0
    
    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        
        if itemAttributes.count != collectionView.numberOfSections {
            generateItemAttributes(collectionView: collectionView)
            return
        }
        
        if self.numberColumnFixed > 0 {
            self.setLayoutWithColumnFixed(collectionView: collectionView)
        }
    }
    
    func setLayoutWithColumnFixed(collectionView: UICollectionView) {
        if collectionView.numberOfSections > 0 {
            for section in 0..<collectionView.numberOfSections {
                if collectionView.numberOfItems(inSection: section) > self.numberColumnFixed { // continue orther columns after
                    for item in 0..<collectionView.numberOfItems(inSection: section) {
                        
                        if section != 0 && item > self.numberColumnFixed {
                            continue
                        }
                        let attributes = layoutAttributesForItem(at: IndexPath(item: item, section: section))
                        var frame = attributes.frame
                        
                        //set y origin for columns fixed
                        if section == 0 {
                            frame.origin.y = collectionView.contentOffset.y
                            attributes.frame = frame
                        }
                        //set x origin for columns fixed
                        if (item == 0) {
                            frame.origin.x = collectionView.contentOffset.x
                            attributes.frame = frame
                        }
                        
                        var setX = collectionView.contentOffset.x
                        if (item > 0) && (item < self.numberColumnFixed){
                            for idx in 0..<item {
                                let itemSize = (self.itemsSize[idx] as AnyObject).cgSizeValue
                                setX += itemSize?.width ?? 0
                            }
                            frame.origin.x = setX
                            attributes.frame = frame
                        }
                    }
                    
                } else { //report số cột <= self.numberColumnFixed
                    return
                }
            }
        } else {
            return
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        return itemAttributes[indexPath.section][indexPath.row]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        for section in itemAttributes {
            let filteredArray = section.filter { obj -> Bool in
                return rect.intersects(obj.frame)
            }
            
            attributes.append(contentsOf: filteredArray)
        }
        
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

}

// MARK: - Helpers
extension ReportLayout {
    
    func generateItemAttributes(collectionView: UICollectionView) {
        if itemsSize.count != numberOfColumns {
            calculateItemSizes()
        }
        
        var column = 0
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        var contentWidth: CGFloat = 0
        
        itemAttributes = []
        
        if collectionView.numberOfSections > 0 {
            for section in 0..<collectionView.numberOfSections {
                var sectionAttributes: [UICollectionViewLayoutAttributes] = []
                
                if numberOfColumns > self.numberColumnFixed {
                    for index in 0..<numberOfColumns {
                        let itemSize = itemsSize[index]
                        let indexPath = IndexPath(item: index, section: section)
                        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                        attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height).integral
                        
                        if section == 0 && index < self.numberColumnFixed {// First cell should be on top
                            attributes.zIndex = 1024
                        } else if section == 0 || index < self.numberColumnFixed {// First row/column should be above other cells
                            attributes.zIndex = 1023
                        }
                        
                        var frame = attributes.frame
                        if section == 0 {
                            frame.origin.y = collectionView.contentOffset.y
                        }
                        
                        //column co dinh
                        if index == 0 {
                            frame.origin.x = collectionView.contentOffset.x
                        } else if (index > 0) && (index < self.numberColumnFixed){
                            frame.origin.x = xOffset;
                        }
                        attributes.frame = frame
                        sectionAttributes.append(attributes)
                        
                        xOffset += itemSize.width
                        column += 1
                        
                        if column == numberOfColumns {
                            if xOffset > contentWidth {
                                contentWidth = xOffset
                            }
                            column = 0
                            xOffset = 0
                            yOffset += itemSize.height
                        }
                    }
                } else {
                    return
                }
                itemAttributes.append(sectionAttributes)
            }
        } else {
            return
        }
        
        if let attributes = itemAttributes.last?.last {
            contentSize = CGSize(width: contentWidth, height: attributes.frame.maxY)
        }
    }
    
    func calculateItemSizes() {
        itemsSize = []
        
        for index in 0..<numberOfColumns {
            itemsSize.append(sizeForItemWithColumnIndex(index))
        }
    }
    
    func sizeForItemWithColumnIndex(_ columnIndex: Int) -> CGSize {
        var text: String;
        
        text = titleArray[columnIndex];
        
        let size: CGSize = text.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)]);
        let width: CGFloat = size.width + 6;
        return CGSize(width: width, height: 25);
    }
}

