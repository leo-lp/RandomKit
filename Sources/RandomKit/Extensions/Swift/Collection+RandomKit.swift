//
//  CollectionType+RandomKit.swift
//  RandomKit
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015-2017 Nikolai Vazquez
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

extension Collection where Index: RandomWithinRange {

    /// Returns a random element of `self`, or `nil` if `self` is empty.
    public func random<R: RandomGenerator>(using randomGenerator: inout R) -> Iterator.Element? {
        let range = Range(uncheckedBounds: (startIndex, endIndex))
        guard let index = Index.random(within: range, using: &randomGenerator) else {
            return nil
        }
        return self[index]
    }

}

extension Collection where Index: RandomWithinRange, IndexDistance: RandomToValue {

    /// Returns a random element of `self`, or `nil` if `self` is empty.
    public func random<R: RandomGenerator>(using randomGenerator: inout R) -> Iterator.Element? {
        let range = Range(uncheckedBounds: (startIndex, endIndex))
        guard let index = Index.random(within: range, using: &randomGenerator) else {
            return nil
        }
        return self[index]
    }

}

extension Collection where IndexDistance: RandomToValue {

    /// Returns a random element of `self`, or `nil` if `self` is empty.
    public func random<R: RandomGenerator>(using randomGenerator: inout R) -> Iterator.Element? {
        guard !self.isEmpty else {
            return nil
        }
        let elementIndex = IndexDistance.random(to: distance(from: startIndex, to: endIndex), using: &randomGenerator)
        return self[index(startIndex, offsetBy: elementIndex)]
    }

}

extension MutableCollection where Self: Shuffleable, Index: Strideable & RandomWithinRange, Index.Stride: SignedInteger {

    /// Shuffles the elements of `self` and returns the result.
    public func shuffled<R: RandomGenerator>(using randomGenerator: inout R) -> Self {
        var copy = self
        copy.shuffle(using: &randomGenerator)
        return copy
    }

    /// Shuffles the elements of `self`.
    public mutating func shuffle<R: RandomGenerator>(using randomGenerator: inout R) {
        shuffle(in: CountableRange(uncheckedBounds: (startIndex, endIndex)), using: &randomGenerator)
    }

    /// Shuffles the elements of `self` in `range` and returns the result.
    public func shuffled<R: RandomGenerator>(in range: CountableRange<Index>, using randomGenerator: inout R) -> Self {
        var copy = self
        copy.shuffle(in: range, using: &randomGenerator)
        return copy
    }

    /// Shuffles the elements of `self` in `range`.
    public mutating func shuffle<R: RandomGenerator>(in range: CountableRange<Index>, using randomGenerator: inout R) {
        for i in range {
            let j = Index.uncheckedRandom(within: range, using: &randomGenerator)
            if j != i {
                swap(&self[i], &self[j])
            }
        }
    }

}

extension MutableCollection where Self: UniqueShuffleable, Index: Strideable & RandomWithinRange, Index.Stride: SignedInteger {

    /// Shuffles the elements of `self` in a unique order and returns the result.
    public func shuffledUnique<R: RandomGenerator>(using randomGenerator: inout R) -> Self {
        var copy = self
        copy.shuffleUnique(using: &randomGenerator)
        return copy
    }

    /// Shuffles the elements of `self` in a unique order.
    public mutating func shuffleUnique<R: RandomGenerator>(using randomGenerator: inout R) {
        shuffleUnique(in: CountableRange(uncheckedBounds: (startIndex, endIndex)), using: &randomGenerator)
    }

    /// Shuffles the elements of `self` in a unique order in `range` and returns the result.
    public func shuffledUnique<R: RandomGenerator>(in range: CountableRange<Index>, using randomGenerator: inout R) -> Self {
        var copy = self
        copy.shuffleUnique(in: range, using: &randomGenerator)
        return copy
    }

    /// Shuffles the elements of `self` in a unique order in `range`.
    public mutating func shuffleUnique<R: RandomGenerator>(in range: CountableRange<Index>, using randomGenerator: inout R) {
        if range.isEmpty {
            return
        }
        for i in CountableRange(uncheckedBounds: (range.lowerBound, range.upperBound.advanced(by: -1))) {
            let randomRange = Range(uncheckedBounds: (i.advanced(by: 1), range.upperBound))
            let j = Index.uncheckedRandom(within: randomRange, using: &randomGenerator)
            swap(&self[i], &self[j])
        }
    }

}

extension UnsafeMutableBufferPointer: Shuffleable, UniqueShuffleable {
}

extension UnsafeMutableRawBufferPointer: Shuffleable, UniqueShuffleable {
}

extension Array: Shuffleable, UniqueShuffleable {

    /// Shuffles the elements of `self`.
    public mutating func shuffle<R: RandomGenerator>(using randomGenerator: inout R) {
        withUnsafeMutableBufferPointer { buffer in
            buffer.shuffle(using: &randomGenerator)
        }
    }

    /// Shuffles the elements of `self` in `range`.
    public mutating func shuffle<R: RandomGenerator>(in range: CountableRange<Int>, using randomGenerator: inout R) {
        withUnsafeMutableBufferPointer { buffer in
            buffer.shuffle(in: range, using: &randomGenerator)
        }
    }

    /// Shuffles the elements of `self` in a unique order.
    public mutating func shuffleUnique<R: RandomGenerator>(using randomGenerator: inout R) {
        withUnsafeMutableBufferPointer { buffer in
            buffer.shuffleUnique(using: &randomGenerator)
        }
    }

    /// Shuffles the elements of `self` in a unique order in `range`.
    public mutating func shuffleUnique<R: RandomGenerator>(in range: CountableRange<Int>, using randomGenerator: inout R) {
        withUnsafeMutableBufferPointer { buffer in
            buffer.shuffleUnique(in: range, using: &randomGenerator)
        }
    }

}

extension ContiguousArray: Shuffleable, UniqueShuffleable {

    /// Shuffles the elements of `self`.
    public mutating func shuffle<R: RandomGenerator>(using randomGenerator: inout R) {
        withUnsafeMutableBufferPointer { buffer in
            buffer.shuffle(using: &randomGenerator)
        }
    }

    /// Shuffles the elements of `self` in `range`.
    public mutating func shuffle<R: RandomGenerator>(in range: CountableRange<Int>, using randomGenerator: inout R) {
        withUnsafeMutableBufferPointer { buffer in
            buffer.shuffle(in: range, using: &randomGenerator)
        }
    }

    /// Shuffles the elements of `self` in a unique order.
    public mutating func shuffleUnique<R: RandomGenerator>(using randomGenerator: inout R) {
        withUnsafeMutableBufferPointer { buffer in
            buffer.shuffleUnique(using: &randomGenerator)
        }
    }

    /// Shuffles the elements of `self` in a unique order in `range`.
    public mutating func shuffleUnique<R: RandomGenerator>(in range: CountableRange<Int>, using randomGenerator: inout R) {
        withUnsafeMutableBufferPointer { buffer in
            buffer.shuffleUnique(in: range, using: &randomGenerator)
        }
    }

}

extension ArraySlice: Shuffleable, UniqueShuffleable {

    /// Shuffles the elements of `self`.
    public mutating func shuffle<R: RandomGenerator>(using randomGenerator: inout R) {
        withUnsafeMutableBufferPointer { buffer in
            buffer.shuffle(using: &randomGenerator)
        }
    }

    /// Shuffles the elements of `self` in a unique order.
    public mutating func shuffleUnique<R: RandomGenerator>(using randomGenerator: inout R) {
        withUnsafeMutableBufferPointer { buffer in
            buffer.shuffleUnique(using: &randomGenerator)
        }
    }

}
