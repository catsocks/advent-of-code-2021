package main

import (
	"bytes"
	"fmt"
	"os"
	"regexp"
	"strconv"
)

type lineSegment struct {
	x1, y1, x2, y2 int
}

// func (l lineSegment) String() string {
// 	return fmt.Sprintf("%v,%v -> %v,%v", l.x1, l.y1, l.x2, l.y2)
// }

var re = regexp.MustCompile(`(\d+),(\d+) -> (\d+),(\d+)`)

func main() {
	input, err := os.ReadFile("day-05-hydrothermal-venture/input.txt")
	panicOnErr(err)

	lines := parseInput(input)

	grid := createEmptyGrid(lines)

	fillStraightLines(grid, lines)

	fmt.Printf("There are %v points where at least two lines straight overlap.\n", getPointsOverlap(grid))

	fillDiagonalLines(grid, lines)

	fmt.Printf("There are %v points where at least two lines overlap.\n", getPointsOverlap(grid))
}

func panicOnErr(err error) {
	if err != nil {
		panic(err)
	}
}

func parseInput(input []byte) []lineSegment {
	var lines []lineSegment

	for _, line := range bytes.Split(bytes.TrimSpace(input), []byte("\n")) {
		matches := re.FindSubmatch(line)
		if len(matches) < 5 {
			panic("bad input")
		}

		lines = append(lines, lineSegment{
			x1: atoi(matches[1]),
			y1: atoi(matches[2]),
			x2: atoi(matches[3]),
			y2: atoi(matches[4]),
		})
	}

	return lines
}

func atoi(buf []byte) int {
	i, err := strconv.Atoi(string(buf))
	panicOnErr(err)
	return i
}

func createEmptyGrid(lines []lineSegment) [][]int {
	var width, height int
	for _, line := range lines {
		width = max(width, max(line.x1, line.x2)+1)
		height = max(height, max(line.y1, line.y2)+1)
	}

	rows := make([][]int, height)
	for i := range rows {
		rows[i] = make([]int, width)
	}
	return rows
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}

func fillStraightLines(grid [][]int, lines []lineSegment) {
	for _, line := range lines {
		if line.x1 != line.x2 && line.y1 != line.y2 {
			continue // not a straight line
		}

		xMin, xMax := ascending2(line.x1, line.x2)
		yMin, yMax := ascending2(line.y1, line.y2)

		for y := yMin; y < yMax+1; y++ {
			for x := xMin; x < xMax+1; x++ {
				grid[y][x] += 1
			}
		}
	}
}

func ascending2(x, y int) (int, int) {
	if x > y {
		return y, x
	}
	return x, y
}

func getPointsOverlap(grid [][]int) int {
	var pointsOverlap int
	for _, row := range grid {
		for _, column := range row {
			if column > 1 {
				pointsOverlap += 1
			}
		}
	}
	return pointsOverlap
}

func fillDiagonalLines(grid [][]int, lines []lineSegment) {
	for _, line := range lines {
		if line.x1 == line.x2 || line.y1 == line.y2 {
			continue // straight line
		}

		xMin, xMax := ascending2(line.x1, line.x2)
		yMin, yMax := ascending2(line.y1, line.y2)

		y, x := line.y1, line.x1
		for y >= yMin && x >= xMin && y < yMax+1 && x < xMax+1 {
			grid[y][x] += 1

			if line.y1 < line.y2 {
				y++
			} else {
				y--
			}
			if line.x1 < line.x2 {
				x++
			} else {
				x--
			}
		}
	}
}

// func printGrid(grid [][]int) {
// 	for _, row := range grid {
// 		for _, column := range row {
// 			if column > 0 {
// 				fmt.Print(column)
// 			} else {
// 				fmt.Print(".")
// 			}
// 		}
// 		fmt.Println()
// 	}
// }
