# sudoku.sh

## Description

A sudoku puzzle solver, using backtracking, written in bash (not very fast :smirk:)

```
~/work/sudoku ⭠master  time ./sudoku.sh grids/grid_geekforce.txt
   INPUT GRID
3 0 6 5 0 8 4 0 0
5 2 0 0 0 0 0 0 0
0 8 7 0 0 0 0 3 1
0 0 3 0 1 0 0 8 0
9 0 0 8 6 3 0 0 5
0 5 0 0 9 0 6 0 0
1 3 0 0 0 0 2 5 0
0 0 0 0 0 0 0 7 4
0 0 5 2 0 6 3 0 0
   SOLVED GRID
3 1 6 5 7 8 4 9 2
5 2 9 1 3 4 7 6 8
4 8 7 6 2 9 5 3 1
2 6 3 4 1 5 9 8 7
9 7 4 8 6 3 1 2 5
8 5 1 7 9 2 6 4 3
1 3 8 9 4 7 2 5 6
6 9 2 3 5 1 8 7 4
7 4 5 2 8 6 3 1 9

real    0m39.007s
user    0m20.029s
sys     0m19.158s

~/work/sudoku ⭠master  time ./sudoku.sh grids/grid_teckbote_1.txt
   INPUT GRID
0 5 0 0 0 0 4 0 6
8 0 0 7 0 0 2 9 0
0 0 0 0 4 3 0 5 0
0 0 9 0 1 0 0 0 2
0 3 0 0 7 0 0 6 0
5 0 0 0 2 0 7 0 0
0 6 0 5 9 0 0 0 0
0 1 5 0 0 4 0 0 9
2 0 4 0 0 0 0 3 0
   SOLVED GRID
9 5 3 2 8 1 4 7 6
8 4 1 7 5 6 2 9 3
6 2 7 9 4 3 8 5 1
4 7 9 6 1 5 3 8 2
1 3 2 4 7 8 9 6 5
5 8 6 3 2 9 7 1 4
3 6 8 5 9 2 1 4 7
7 1 5 8 3 4 6 2 9
2 9 4 1 6 7 5 3 8

real    5m39.102s
user    2m52.563s
sys     2m46.709s
```
