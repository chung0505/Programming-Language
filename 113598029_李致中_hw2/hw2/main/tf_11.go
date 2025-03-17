package main

import (
	"fmt"
	"os"
	"reflect"
	"regexp"
	"sort"
	"strings"
)

type DataStorageManager struct {
	data string
}

func NewDataStorageManager(pathToFile string) *DataStorageManager {
	content, err := os.ReadFile(pathToFile)
	if err != nil {
		panic(err)
	}

	data := string(content)

	reg := regexp.MustCompile(`[\W_]+`)
	data = reg.ReplaceAllString(data, " ")
	data = strings.ToLower(data)

	return &DataStorageManager{data: data}
}

func (dataStorageManger *DataStorageManager) Words() []string {
	return strings.Fields(dataStorageManger.data)
}

func (dataStorageManger *DataStorageManager) Info() string {
	return "DataStorageManager: My major data structure is a " + reflect.TypeOf(dataStorageManger.data).String()
}

type StopWordManager struct {
	stopWords map[string]bool
}

func NewStopWordManager() *StopWordManager {
	content, err := os.ReadFile("../stop_words.txt")
	if err != nil {
		panic(err)
	}

	words := strings.Split(string(content), ",")
	stopWords := make(map[string]bool)

	for _, word := range words {
		stopWords[word] = true
	}

	for ch := 'a'; ch <= 'z'; ch++ {
		stopWords[string(ch)] = true
	}

	return &StopWordManager{stopWords: stopWords}
}

func (stopWordManager *StopWordManager) IsStopWord(word string) bool {
	return stopWordManager.stopWords[word]
}

func (stopWordManager *StopWordManager) Info() string {
	return "StopWordManager: My major data structure is a " + reflect.TypeOf(stopWordManager.stopWords).String()
}

type WordFrequencyManager struct {
	wordFreqs map[string]int
}

func NewWordFrequencyManager() *WordFrequencyManager {
	return &WordFrequencyManager{wordFreqs: make(map[string]int)}
}

func (wordFrequencyManager *WordFrequencyManager) IncrementCount(word string) {
	wordFrequencyManager.wordFreqs[word]++
}

func (wordFrequencyManager *WordFrequencyManager) Sorted() []Pair {
	var result []Pair
	for word, count := range wordFrequencyManager.wordFreqs {
		result = append(result, Pair{word: word, count: count})
	}

	sort.Slice(result, func(i, j int) bool {
		return result[i].count > result[j].count
	})

	return result
}

func (wordFrequencyManager *WordFrequencyManager) Info() string {
	return "WordFrequencyManager: My major data structure is a " + reflect.TypeOf(wordFrequencyManager.wordFreqs).String()
}

type Pair struct {
	word  string
	count int
}

type WordFrequencyController struct {
	dataStorageManager   *DataStorageManager
	stopWordManager      *StopWordManager
	wordFrequencyManager *WordFrequencyManager
}

func NewWordFrequencyController(pathToFile string) *WordFrequencyController {
	return &WordFrequencyController{
		dataStorageManager:   NewDataStorageManager(pathToFile),
		stopWordManager:      NewStopWordManager(),
		wordFrequencyManager: NewWordFrequencyManager(),
	}
}

func (wordFrequencyController *WordFrequencyController) Run() {
	for _, word := range wordFrequencyController.dataStorageManager.Words() {
		if !wordFrequencyController.stopWordManager.IsStopWord(word) {
			wordFrequencyController.wordFrequencyManager.IncrementCount(word)
		}
	}

	wordFreqs := wordFrequencyController.wordFrequencyManager.Sorted()
	for i, pair := range wordFreqs {
		if i < 25 {
			fmt.Println(pair.word, " - ", pair.count)
		}
	}
}

func main() {
	if len(os.Args) != 2 {
		fmt.Println("Usage: go run program.go <path_to_file>")
		os.Exit(1)
	}

	controller := NewWordFrequencyController(os.Args[1])
	controller.Run()
}
