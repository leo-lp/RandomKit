//
//  RandomGenerator.swift
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

/// A type that generates random values.
public protocol RandomGenerator {

    /// Generates a random 64-bit integer.
    mutating func random64() -> UInt64

    /// Generates a random 32-bit integer.
    mutating func random32() -> UInt32

    /// Randomizes the contents `buffer` up to `size`.
    mutating func randomize(buffer: UnsafeMutableRawPointer, size: Int)

}

extension RandomGenerator {

    /// Generates a random 64-bit integer.
    public mutating func random64() -> UInt64 {
        var result: UInt64 = 0
        randomize(buffer: &result, size: MemoryLayout<UInt64>.size)
        return result
    }

    /// Generates a random 32-bit integer.
    public mutating func random32() -> UInt32 {
        var result: UInt32 = 0
        randomize(buffer: &result, size: MemoryLayout<UInt32>.size)
        return result
    }

    /// Randomizes the contents of `value`.
    public mutating func randomize<T>(value: inout T) {
        randomize(buffer: &value, size: MemoryLayout<T>.size)
    }

    /// Randomizes the contents of `buffer`.
    public mutating func randomize(buffer: UnsafeMutableRawBufferPointer) {
        randomize(buffer: buffer.baseAddress.unsafelyUnwrapped, size: buffer.count)
    }

    /// Randomize the contents of `buffer` with max `width` bits.
    public mutating func randomize(buffer: UnsafeMutableRawPointer, maxWidth width: Int) {
        let byteCount = (width + 7) / 8
        randomize(buffer: buffer, size: byteCount)
        let count = width % 8
        if count != 0 {
            let rebounded = buffer.assumingMemoryBound(to: UInt8.self)
            rebounded[byteCount - 1] &= .max >> UInt8(8 - count)
        }
    }

    /// Randomize the contents of `buffer` with exactly `width` bits.
    public mutating func randomize(buffer: UnsafeMutableRawPointer, exactWidth width: Int) {
        randomize(buffer: buffer, maxWidth: width)
        let byteCount = (width + 7) / 8
        let rebounded = buffer.assumingMemoryBound(to: UInt8.self)
        rebounded[byteCount - 1] |= 1 << UInt8((width - 1) % 8)
    }

}
