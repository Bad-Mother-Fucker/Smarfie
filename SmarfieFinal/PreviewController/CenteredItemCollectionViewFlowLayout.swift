//
//  CenteredItemCollectionViewFlowLayout.swift
//  myCustomCamera
//
//  Created by UMBERTO GRIMALDI on 07/02/2018.
//  Copyright © 2018 UMBERTO GRIMALDI. All rights reserved.
//

import UIKit

// MARK: TRASH

class CenteredItemCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        if let cv = self.collectionView {
            let cvBounds = cv.bounds
            let halfWidth = cvBounds.size.width * 0.5
            let proposedContentOffsetCenterX = proposedContentOffset.x + halfWidth
            if let attributesForVisibleCells = self.layoutAttributesForElements(in: cvBounds) as [UICollectionViewLayoutAttributes]! {
                var candidateAttributes: UICollectionViewLayoutAttributes?
                for attributes in attributesForVisibleCells {
                    // == Skip comparison with non-cell items (headers and footers) == //
                    if attributes.representedElementCategory != UICollectionElementCategory.cell {
                        continue
                    }
                    if let candAttrs = candidateAttributes {
                        let a = attributes.center.x - proposedContentOffsetCenterX
                        let b = candAttrs.center.x - proposedContentOffsetCenterX
                        if fabsf(Float(a)) < fabsf(Float(b)) {
                            candidateAttributes = attributes
                        }
                    } else { // == First time in the loop == //
                        candidateAttributes = attributes
                        continue
                    }
                }
                return CGPoint(x : candidateAttributes!.center.x - halfWidth, y : proposedContentOffset.y)
            }
        }
        // Fallback
        return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
    }
}
