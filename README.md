squaresum
=========

calculates the square of a number as a series of differences of squares.

## Resoning

This program is not very efficient nor useful, but it is a delve into using some cool mathematics.

## Math

```
f = x -> x^2

f(x + 1) - x^2 = 2x + 1

the sum from i=1 to n of 2(i - 1) + 1 = n^2
```

Proof by induction:
```
k = 1: 2(0) + 1 = 1
k = 2: 2(0) + 1 + 2(1) + 1 = 4
k + 1 = 2 + 1 = 3: 2(0) + 1 + 2(1) + 1 + 2(2) + 1 = 9
```
