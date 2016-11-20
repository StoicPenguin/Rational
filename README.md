# Rational
A rational number datatype in Swift

Rational is a representation of numbers in the form N/D where both N and D are Integers.

Rational supports addition, subtraction, multiplication, and division. A Rational can be initialized with explicit numerator and denominator, a single integer, or a floating point number. When initialized with a floating point number, Rational attempts to find the rational number within a given error with the smallest denominator.

## Example
```Swift
let d = Double.pi

let r1 = Double.bestRationalApproxiation(d) // By default, seeks accuracy of 1e-15
print(r1) // 80143857/25510582

let r2 = Double.bestRationalApproxiation(d, 1e-2) // Can specify specific error bounds
print(r2) // 22/7
```
