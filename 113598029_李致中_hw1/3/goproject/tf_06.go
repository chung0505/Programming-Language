package goproject

import (
	"fmt"
	"log"
	"os"
	"regexp"
	"strings"
)

func readFile(path string) string {
	data, err := os.ReadFile(path)
	if err != nil {
		log.Fatalf("failed reading file: %s", err)
	}
	return string(data)
}

func filterCharsAndNormalize(strData string) string {
	re := regexp.MustCompile(`[\W_]+`)
	normalized := re.ReplaceAllString(strData, " ")
	return strings.ToLower(normalized)
}

func scan(strData string) []string {
	return strings.Fields(strData)
}

func removeStopWords(words []string) []string {
	stopWordsData, err := os.ReadFile("../stop_words.txt")
	if err != nil {
		log.Fatalf("failed reading stop_words.txt: %s", err)
	}
	stopWords := strings.Split(string(stopWordsData), ",")

	var newWords []string
	for _, word := range words {
		var isStopWord bool = false
		for _, stopWord := range stopWords {
			if word == stopWord || len(word) <= 1 {
				isStopWord = true
				break
			}
		}
		if !isStopWord {
			newWords = append(newWords, word)
		}
	}
	return newWords
}

func frequecies(words []string) map[string]int {
	wordFreqs := make(map[string]int)
	for _, word := range words {
		if freq, found := wordFreqs[word]; found {
			wordFreqs[word] = freq + 1
		} else {
			wordFreqs[word] = 1
		}
	}
	return wordFreqs
}

type pair struct {
	Key   string
	Value int
}

func sort(wordFreqs map[string]int) []pair {
	var pairs []pair
	for k, v := range wordFreqs {
		pairs = append(pairs, pair{k, v})
	}

	for i := 0; i < len(pairs); i++ {
		for j := i + 1; j < len(pairs); j++ {
			if pairs[j].Value > pairs[i].Value {
				temp := pairs[i]
				pairs[i] = pairs[j]
				pairs[j] = temp
			}
		}
	}
	return pairs
}

func printAll(pairs []pair) {
	for i, pair := range pairs {
		if i < 25 {
			fmt.Println(pair.Key, " - ", pair.Value)
		}
	}
}

func main() {
	printAll(sort(frequecies(removeStopWords(scan(filterCharsAndNormalize(readFile("pride-and-prejudice.txt")))))))
}
