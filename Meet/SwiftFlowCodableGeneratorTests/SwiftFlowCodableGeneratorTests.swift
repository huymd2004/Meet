//
//  SwiftFlowCodableGeneratorTests.swift
//  SwiftFlowCodableGeneratorTests
//
//  Created by Benjamin Encz on 12/9/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import XCTest
import SourceKittenFramework
import SwiftFlowCodableGenerator

class SwiftFlowCodableGeneratorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let testBundle = NSBundle(forClass: self.dynamicType)
        let fileURL = testBundle.URLForResource("SetUserSearchText", withExtension: "swiftsourcefile")
        let fileURLString = fileURL!.path!
        let file = File(path: fileURLString)
        let code = generateActionConvertible(file!)
        print(code)
    }
    
}
