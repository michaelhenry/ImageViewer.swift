import UIKit

class GalleryFlowLayout:UICollectionViewFlowLayout {
    
    var columns:Int = 3 {
        didSet {
            if columns != oldValue {
                invalidateLayout()
            }
        }
    }
    
    var horizontalCellSpacing:CGFloat = 1
    var verticalCellSpacing:CGFloat = 1
    var cache = [UICollectionViewLayoutAttributes]()
    
    
    var width:CGFloat {
        get {
            return collectionView!.bounds.width
        }
    }
    
    /// Getting the item width: itemWith = width - ((col+1)* spacing)/col
    var cellContentWidth:CGFloat {
        return (width - (horizontalCellSpacing * CGFloat(columns - 1)))/CGFloat(columns)
    }
    
    var cellContentHeight:CGFloat {
        return cellContentWidth
    }
    
    public var contentHeight:CGFloat {
        let numberOfItems = collectionView?.numberOfItems(inSection: 0) ?? 0
        let rows = numberOfItems/columns + (numberOfItems%columns==0 ? 0:1)
        return (CGFloat(rows) * verticalCellSpacing) + (CGFloat(rows) * cellContentHeight)
    }
    
    override public var collectionViewContentSize: CGSize {
        return CGSize(width: width, height: contentHeight)
    }
    
    override public func prepare() {
        
        if !cache.isEmpty {
            return
        }
        
        let numberOfItems = collectionView?.numberOfItems(inSection: 0) ?? 0
        
        for item in 0..<numberOfItems {
            
            let indexPath:IndexPath = IndexPath(item: item, section: 0)
            
            let columnIndex = indexPath.row % columns
            let rowIndex = indexPath.row / columns
            
            // create a frame for the item
            let x = CGFloat(columnIndex) * horizontalCellSpacing + (cellContentWidth * CGFloat(columnIndex))
            let y = CGFloat(rowIndex) * verticalCellSpacing + (cellContentHeight * CGFloat(rowIndex))
            
            let itemRect = CGRect(
                x: x,
                y: y,
                width: cellContentWidth,
                height: cellContentHeight)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = itemRect
            cache.append(attributes)
        }
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        return cache[indexPath.row]
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return newBounds.size != collectionView?.bounds.size
    }
    
    public override func invalidateLayout() {
        cache.removeAll()
        super.invalidateLayout()
    }
}
