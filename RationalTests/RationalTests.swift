//
//  RationalTests.swift
//  RationalTests
//
//  Created by Michael Hendrickson on 10/24/16.
//  Copyright © 2016 Michael Hendrickson. All rights reserved.
//

import XCTest
@testable import Rational

class RationalTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitWithNumerator() {
        let nTest = 2;
        let rTest = Rational(nTest);
        XCTAssert(rTest.numerator == nTest, "Incorrect Numerator \(rTest.numerator)");
        XCTAssert(rTest.denominator == 1, "Incorrect Denominator \(rTest.denominator)");
    }
    
    func testInitWithNumeratorAndDenominator() {
        let nTest = 4;
        let dTest = 8;
        
        let rTest = Rational(nTest, dTest);
        XCTAssert(rTest.numerator == 1, "Incorrect Numerator \(rTest.numerator)");
        XCTAssert(rTest.denominator == 2, "Incorrect Denominator \(rTest.denominator)");
    }
    
    func testInverse() {
        let r = Rational(1, 2);
        let rInv = r.inverse();
        
        XCTAssert(rInv.numerator == r.denominator && rInv.denominator == r.numerator,
                  "Incorrect Inverse: \(r) | \(rInv)");
    }
    
    func testIsFinite() {
        let rFin = Rational(2, 1);
        let rInf = Rational(2, 0);
        
        XCTAssert(rFin.isFinite, "Incorrect Finite Response \(rFin)");
        XCTAssert(!rInf.isFinite, "Incorrect Finite Response \(rInf)");
    }

    func testIsInFinite() {
        let rFin = Rational(2, 1);
        let rInf = Rational(2, 0);
        
        XCTAssert(!rFin.isInfinite, "Incorrect Finite Response \(rFin)");
        XCTAssert(rInf.isInfinite, "Incorrect Finite Response \(rInf)");
    }

    func testNan() {
        let rFin = Rational(2, 1);
        let rNaN = Rational(0, 0);
        
        XCTAssert(!rFin.isNaN, "Incorrect NaN Response \(rFin)");
        XCTAssert(rNaN.isNaN, "Incorrect NaN Response \(rNaN)");
    }
    
    func testAddition() {
        let rOne = Rational(1, 0);
        let rTwo = Rational(3, 4);
        let rThree = rOne + rTwo;
        
        XCTAssert(rThree.numerator == 1, "Incorrect Numerator \(rThree.numerator)");
        XCTAssert(rThree.denominator == 0, "Incorrect Denominator \(rThree.denominator)");
        
        let rFin = Rational(2, 3);
        let rInf = Rational(-4, 0);
        let rTot = rFin + rInf;
        
        XCTAssert(rTot.numerator == 1 && rTot.denominator == 0, "Incorrect Infinite Addition \(rTot)");
    }

    func testSubtraction() {
        let rOne = Rational(1, 2);
        let rTwo = Rational(-3, 4);
        let rThree = rOne - rTwo;
        
        XCTAssert(rThree.numerator == 5, "Incorrect Numerator \(rThree.numerator)");
        XCTAssert(rThree.denominator == 4, "Incorrect Denominator \(rThree.denominator)");
    }

    func testMultiplication() {
        let rOne = Rational(1, -2);
        let rTwo = Rational(-3, 4);
        let rThree = rOne * rTwo;
        
        XCTAssert(rThree.numerator == 3, "Incorrect Numerator \(rThree.numerator)");
        XCTAssert(rThree.denominator == 8, "Incorrect Denominator \(rThree.denominator)");
    }

    func testDivision() {
        let rOne = Rational(1, -2);
        let rTwo = Rational(-3, 4);
        let rThree = rOne / rTwo;
        
        XCTAssert(rThree.numerator == 2, "Incorrect Numerator \(rThree.numerator)");
        XCTAssert(rThree.denominator == 3, "Incorrect Denominator \(rThree.denominator)");
    }
    
    func testLessThan() {
        let rOne = Rational(4, 8);
        let rTwo = Rational(3, 4);
        let rInf = Rational(1, 0);
        let rNegInf = Rational(-1, 0);
        
        XCTAssert(rOne < rTwo, "Incorrect less-than: \(rOne) !< \(rTwo)");
        XCTAssert(rOne < rInf, "Incorrect less-than: \(rOne) !< \(rInf)");
        XCTAssert(rNegInf < rTwo, "Incorrect less-than: \(rNegInf) !< \(rTwo)")
    }

    func testGCD() {
        let a = 210;
        let b = 165;
    
        XCTAssert(Int.gcd(a, b) == 15, "Incorrect GCD");
    }
    
    func testPrintRational() {
        let rOne = Rational(3,2);
        let rTwo = Rational(-3,2);
        
        print(rOne);
        print(rTwo);
        
        let s = "rOne: \(rOne)";
        print(s);
    }
    
    func testBestRationalApproximation() {
        let d = 123417.0 / 23572.0;
        let r = Double.bestRationalApproxiation(d);

        XCTAssert(abs(d-(Double(r.numerator)/Double(r.denominator))) < 1e-15, "Incorrect rational approximation");
    }
    
    func testDoubleFromRational() {
        let r = Rational(-4, 3);
        
        let d = Double(r);
        
        XCTAssert(d == -4.0 / 3.0, "\(r) did not convert correctly: \(d)");
    }
}
