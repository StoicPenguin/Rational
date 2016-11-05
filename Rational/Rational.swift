//
//  Rational.swift
//  Rational
//
//  Created by Michael Hendrickson on 10/24/16.
//  Copyright © 2016 Michael Hendrickson. All rights reserved.
//

import Foundation

/// Represents a rational number, maintained in reduced form.
struct Rational {
    /// The numerator
    var numerator: Int;
    
    /// The denominator
    var denominator: Int;

    /// Initialize the Rational as a whole number
    /// - Parameters:
    ///     - numerator: The whole value to set to the Rational
    /// - Note: The denominator is initialized to 1
    init(_ numerator: Int) {
        self.init(numerator, 1);
    }
    
    /// Initialize the Rational as a whole number
    /// - Parameters:
    ///     - numerator: The "top" number of the Rational
    ///     - denominator: The "bottom" number of the Rational
    /// - Note: The number will be normalized to divide out the common divisor of the numerator and denominator.
    ///         In addition, for negative numbers, the numerator will be negative. The denominator will always be 
    ///         non-negative. A denominiator of 0 signifies an infinite value.
    init(_ numerator: Int, _ denominator: Int) {
        self.numerator = numerator;
        self.denominator = denominator;
        normalize();
    }
    
    /// The multiplicative inverse of the the number.
    /// - Note: Essentially, this will swap the numerator and denominator, leaving the numerator negative.
    func inverse() -> Rational {
        return Rational(denominator, numerator);
    }
    
    /// Normalize the Rational by dividing out the common divisor of the numerator and denominator and, for negative
    /// numbers, making the numerator negative and the denominator positive.
    private mutating func normalize() {
         if denominator < 0 {
            numerator = -numerator;
            denominator = -denominator;
        }
        
        (numerator, denominator) = reducedTuple((numerator, denominator));
    }
    
    /// Removes the common divisor from a tuple.
    /// - Parameters:
    ///     - t: A tuple of integers
    /// - Returns: The tuple with the common divisor divided out
    private func reducedTuple(_ t: (Int, Int)) -> (Int, Int) {
        if t == (0, 0) {
            return (0, 0);
        }
        
        let gcd = Int.gcd(abs(t.0), abs(t.1));
        return (t.0 / gcd, t.1 / gcd);
    }
    
    /// Is the Rational finite?
    /// Returns: False if the denominator is 0, True otherwise
    var isFinite : Bool {
        return denominator != 0;
    }
    
    /// Is the Rational infinite?
    /// Returns: True if the denominator is 0, False otherwise
    var isInfinite : Bool {
        return numerator != 0 && denominator == 0;
    }
    
    /// Is the Rational not a number?
    /// Returns: True if the numerator and denominator are 0, False otherwise
    var isNaN : Bool {
        return numerator == 0 && denominator == 0;
    }
}

// MARK: IntegerArithmetic
extension Rational : IntegerArithmetic {
    static func + (lhs: Rational, rhs: Rational) -> Rational {
        if lhs.isInfinite || rhs.isInfinite {
            return Rational(lhs.numerator + rhs.numerator, 0);
        }
        
        let lcm = Int.lcm(lhs.denominator, rhs.denominator);
        return Rational((lhs.numerator * (lcm / lhs.denominator)) + (rhs.numerator * (lcm / rhs.denominator)), lcm);
    }
    
    static func addWithOverflow(_ lhs: Rational, _ rhs: Rational) -> (Rational, overflow: Bool) {
        if lhs.isInfinite || rhs.isInfinite {
            return (Rational(lhs.numerator + rhs.numerator, 0), false);
        }
        
        let n1 = Int.multiplyWithOverflow(lhs.numerator, rhs.denominator);
        let n2 = Int.multiplyWithOverflow(rhs.numerator, lhs.denominator);
        let nTemp = Int.addWithOverflow(n1.0, n2.0);
        
        let dTemp = Int.multiplyWithOverflow(lhs.denominator, rhs.denominator);
        
        return (Rational(nTemp.0, dTemp.0), n1.1 || n2.1 || nTemp.1 || dTemp.1);
    }
    
    static func - (lhs: Rational, rhs: Rational) -> Rational {
        if lhs.isInfinite || rhs.isInfinite {
            return Rational(lhs.numerator - rhs.numerator, 0);
        }
        
        let lcm = Int.lcm(lhs.denominator, rhs.denominator);
        return Rational((lhs.numerator * (lcm / lhs.denominator)) - (rhs.numerator * (lcm / rhs.denominator)), lcm);
    }
    
    static func subtractWithOverflow(_ lhs: Rational, _ rhs: Rational) -> (Rational, overflow: Bool) {
        if lhs.isInfinite || rhs.isInfinite {
            return (Rational(lhs.numerator - rhs.numerator, 0), false);
        }

        let n1 = Int.multiplyWithOverflow(lhs.numerator, rhs.denominator);
        let n2 = Int.multiplyWithOverflow(rhs.numerator, lhs.denominator);
        let nTemp = Int.subtractWithOverflow(n1.0, n2.0);
        
        let dTemp = Int.multiplyWithOverflow(lhs.denominator, rhs.denominator);
        
        return (Rational(nTemp.0, dTemp.0), n1.1 || n2.1 || nTemp.1 || dTemp.1);
    }

    static func * (lhs: Rational, rhs: Rational) -> Rational {
        if lhs.isInfinite || rhs.isInfinite {
            return Rational(lhs.numerator * rhs.numerator, 0);
        }
        
        let gcd1 = Int.gcd(lhs.numerator, rhs.denominator);
        let gcd2 = Int.gcd(lhs.denominator, rhs.numerator);
        
        return Rational((lhs.numerator / gcd1) * (rhs.numerator / gcd2),
                        (lhs.denominator / gcd2) * (rhs.denominator / gcd1));
    }
    
    static func multiplyWithOverflow(_ lhs: Rational, _ rhs: Rational) -> (Rational, overflow: Bool) {
        if lhs.isInfinite || rhs.isInfinite {
            return (Rational(lhs.numerator * rhs.numerator, 0), false);
        }

        let gcd1 = Int.gcd(lhs.numerator, rhs.denominator);
        let gcd2 = Int.gcd(lhs.denominator, rhs.numerator);
        
        let nTemp = Int.multiplyWithOverflow(lhs.numerator / gcd1, rhs.numerator / gcd2);
        let dTemp = Int.multiplyWithOverflow(lhs.denominator / gcd2, rhs.denominator / gcd1);
        
        return (Rational(nTemp.0, dTemp.0), nTemp.1 || dTemp.1);
    }
    
    static func / (lhs: Rational, rhs: Rational) -> Rational {
        return lhs * rhs.inverse();
    }

    static func divideWithOverflow(_ lhs: Rational, _ rhs: Rational) -> (Rational, overflow: Bool) {
        return multiplyWithOverflow(lhs, rhs.inverse());
    }

    static func % (lhs: Rational, rhs: Rational) -> Rational {
        if lhs.isInfinite || rhs.isInfinite {
            return Rational(lhs.numerator % rhs.numerator, 0);
        }

        let lcm = Int.lcm(lhs.denominator, rhs.denominator);
        return Rational((lhs.numerator * (lcm / lhs.denominator)) % (rhs.numerator * (lcm / rhs.denominator)), lcm);
    }
    
    static func remainderWithOverflow(_ lhs: Rational, _ rhs: Rational) -> (Rational, overflow: Bool) {
        if lhs.isInfinite || rhs.isInfinite {
            return (Rational(lhs.numerator % rhs.numerator, 0), false);
        }

        let n1 = Int.multiplyWithOverflow(lhs.numerator, rhs.denominator);
        let n2 = Int.multiplyWithOverflow(rhs.numerator, lhs.denominator);
        let nTemp = Int.remainderWithOverflow(n1.0, n2.0);
        
        let dTemp = Int.multiplyWithOverflow(lhs.denominator, rhs.denominator);
        
        return (Rational(nTemp.0, dTemp.0), n1.1 || n2.1 || nTemp.1 || dTemp.1);
    }
    
    func toIntMax() -> IntMax {
        return IntMax(numerator / denominator);
    }
}

// MARK: Comparable
extension Rational : Comparable {
    static func < (lhs: Rational, rhs: Rational) -> Bool {
        return lhs.numerator * rhs.denominator < rhs.numerator * lhs.denominator;
    }

    static func == (lhs: Rational, rhs: Rational) -> Bool {
        return lhs.numerator * rhs.denominator == rhs.numerator * lhs.denominator;
    }
}

// MARK: Hashable
extension Rational : Hashable {
    var hashValue : Int {
        return numerator ^ denominator;
    }
}

// MARK: ExpressibleByIntegerLiteral
extension Rational : ExpressibleByIntegerLiteral {
    init(integerLiteral value: IntegerLiteralType) {
        self.init(value, 1);
    }
}

// MARK: ExpressibleByFloatLiteral
extension Rational : ExpressibleByFloatLiteral {
    init(floatLiteral value: FloatLiteralType) {
        let r = Double.bestRationalApproxiation(Double(value));
        
        numerator = r.numerator;
        denominator = r.denominator;
    }
}

// MARK: CustomStringConvertible
extension Rational : CustomStringConvertible {
    var description : String {
        return "\(numerator)/\(denominator)";
    }
}

extension Integer {
    /// Find the Greatest Common Denominator of two Integers
    /// - Parameters:
    ///     - a: First Integer
    ///     - b: Second Integer
    /// - Returns: The GCD of the given Integers
    static func gcd(_ a: Self, _ b: Self) -> Self {
        return b == 0 ? a : Self.gcd(b, a % b);
    }
    
    /// Find the Least Common Multiple of the two Integers
    /// - Parameters:
    ///     - a: First Integer
    ///     - b: Second Integer
    /// - Returns: The LCM of the given Integers
    static func lcm(_ a: Self, _ b: Self) -> Self {
        if a == 0 || b == 0 {
            return 0;
        }
        
        return (a / gcd(a, b)) * b;
    }
}

extension Double {
    /// Initialize a Double from a Rational
    /// - Note: If the deonominator is zero, the Double will be initialized to +/- infinity
    init(_ number: Rational) {
        if number.isFinite {
            self = Double(number.numerator) / Double(number.denominator);
        } else if number.isInfinite {
            self = number.numerator > 0 ? Double.infinity : -Double.infinity;
        } else {
            self = Double.nan;
        }
    }

    /// Return the closest Rational within a given error with the smallest possible denominator
    /// - Parameters:
    ///     - number: The number to be approximated
    ///     - eps: The error target. Default value is 1.0e-15.
    /// - Returns: The Rational with smallest denominsator and within **eps** of number
    /// - Note: Because the numerator and denominator of Rational are Int, it is not always possible to meet the **eps**
    ///         target. If **eps** cannot be met, the closest Rational with numerator and denominator fittable within an
    ///         Int is returned.
    static func bestRationalApproxiation(_ number: Double, _ eps: Double = 1.0e-15) -> Rational {
        guard number.isFinite else {
            return Rational(1, 0);
        }
        
        var nTemp = abs(number);
        
        var p1 = 0.0, p2 = 1.0;
        var q1 = 1.0, q2 = 0.0;
        
        repeat {
            let a = floor(nTemp);
            
            let pTemp = a * p2 + p1;
            let qTemp = a * q2 + q1;
            
            if (pTemp > Double(Int.max) || pTemp < Double(Int.min) || qTemp > Double(Int.max) || qTemp < Double(Int.min)) {
                break;
            }
            
            p1 = p2; p2 = pTemp;
            q1 = q2; q2 = qTemp;

            nTemp = 1.0 / (nTemp - a)

            if nTemp.isNaN || nTemp.isInfinite {
                break;
            }
        } while abs((p2 / q2) - number) > eps
        
        return Rational(Int(number < 0 ? -p2 : p2), Int(q2));
    }
}
