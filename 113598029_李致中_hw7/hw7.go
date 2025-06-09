package main

import (
	"fmt"
	"image"
	"image/color"
	"math/cmplx"
	"runtime"
	"sync"
	"time"
)

type result struct {
	y   int
	row []color.Color
}

func main() {
	const (
		xmin, ymin, xmax, ymax = -2, -2, +2, +2
		width, height          = 1024, 1024
	)

	fmt.Printf("CPU 核心數: %d\n", runtime.NumCPU())
	fmt.Printf("圖像大小: %dx%d\n\n", width, height)

	fmt.Println("測試Sequential版本...")
	start := time.Now()
	generateSequential(width, height, xmin, ymin, xmax, ymax)
	sequentialTime := time.Since(start)
	fmt.Printf("Sequential版本執行時間: %v\n\n", sequentialTime)

	goroutineCounts := []int{1, 2, 4, 8, 16, 32, runtime.NumCPU(), runtime.NumCPU() * 2}

	fmt.Println("測試Parallel版本...")
	for _, numWorkers := range goroutineCounts {
		fmt.Printf("使用 %d 個 goroutines: ", numWorkers)

		start := time.Now()
		generateParallel(width, height, xmin, ymin, xmax, ymax, numWorkers)
		parallelTime := time.Since(start)

		speedup := float64(sequentialTime) / float64(parallelTime)

		fmt.Printf("時間: %v, 加速比: %.2fx\n",
			parallelTime, speedup)
	}
}

func generateSequential(width, height int, xmin, ymin, xmax, ymax float64) {
	img := image.NewRGBA(image.Rect(0, 0, width, height))

	for py := 0; py < height; py++ {
		y := float64(py)/float64(height)*(ymax-ymin) + ymin
		for px := 0; px < width; px++ {
			x := float64(px)/float64(width)*(xmax-xmin) + xmin
			z := complex(x, y)
			img.Set(px, py, mandelbrot(z))
		}
	}
}

func generateParallel(width, height int, xmin, ymin, xmax, ymax float64, numWorkers int) {
	img := image.NewRGBA(image.Rect(0, 0, width, height))

	rows := make(chan result, height)
	var wg sync.WaitGroup

	for py := 0; py < height; py++ {
		wg.Add(1)
		go func(py int) {
			defer wg.Done()
			y := float64(py)/float64(height)*(ymax-ymin) + ymin
			row := make([]color.Color, width)
			for px := 0; px < width; px++ {
				x := float64(px)/float64(width)*(xmax-xmin) + xmin
				z := complex(x, y)
				row[px] = mandelbrot(z)
			}
			rows <- result{py, row}
		}(py)
	}

	go func() {
		wg.Wait()
		close(rows)
	}()

	for r := range rows {
		for px := 0; px < width; px++ {
			img.Set(px, r.y, r.row[px])
		}
	}
}

func mandelbrot(z complex128) color.Color {
	const iterations = 200
	const contrast = 15

	var v complex128
	for n := uint8(0); n < iterations; n++ {
		v = v*v + z
		if cmplx.Abs(v) > 2 {
			return color.Gray{255 - contrast*n}
		}
	}
	return color.Black
}
