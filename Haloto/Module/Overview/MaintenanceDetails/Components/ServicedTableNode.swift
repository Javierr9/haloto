//
//  ServicedTableNode.swift
//  Haloto
//
//  Created by Dheo Gildas Varian on 10/11/21.
//

import AsyncDisplayKit

class ServicedTableNode: ASDisplayNode {
    
    let model = sampleComponentList
    
    let titleTable: ASTextNode2 = {
        let node = ASTextNode2()
        node.attributedText = .font("Serviced", size: 18, fontWeight: .bold, isTitle: true)
        return node
    }()
    
    let servicedTableNode: ASTableNode = {
        let node = ASTableNode()
        return node
    }()
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        servicedTableNode.dataSource = self
        servicedTableNode.delegate = self
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec(direction: .vertical, spacing: 8, justifyContent: .start, alignItems: .stretch, children: [titleTable, servicedTableNode])
        
        return ASWrapperLayoutSpec(layoutElement: stack)
    }
}

extension ServicedTableNode: ASTableDelegate, ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        model.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let data = model[indexPath.row]
        return SelectedComponentCell(model: data)
    }
}
