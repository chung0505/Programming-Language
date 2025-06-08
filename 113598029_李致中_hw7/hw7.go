package main

import (
	"image"
	"image/color"
	"image/png"
	"math/cmplx"
	"os"
	"sync"
)

const (
	xmin, ymin, xmax, ymax = -2, -2, +2, +2
	width, height          = 1024, 1024
)

type result struct {
	y   int
	row []color.Color
}

func main() {
	img := image.NewRGBA(image.Rect(0, 0, width, height))

	rows := make(chan result, height)
	var wg sync.WaitGroup

	for py := 0; py < height; py++ {
		wg.Add(1)
		go func(py int) {
			defer wg.Done()
			y := float64(py)/height*(ymax-ymin) + ymin
			row := make([]color.Color, width)
			for px := 0; px < width; px++ {
				x := float64(px)/width*(xmax-xmin) + xmin
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

	png.Encode(os.Stdout, img)
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