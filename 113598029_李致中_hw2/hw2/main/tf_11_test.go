package main

import (
	"bytes"
	"os"
	"strings"
	"testing"
)

func TestWords(t *testing.T) {
	input := NewDataStorageManager("../test.txt")
	expected := []string{"this", "is", "not", "a", "hard", "test", "this", "test", "is", "only", "a", "test"}
	result := input.Words()
	for i, word := range result {
		if word != expected[i] {
			t.Errorf("expected %s, got %s", expected[i], word)
		}
	}
}

func TestIsStopWord(t *testing.T) {
	input := NewStopWordManager().IsStopWord("across")
	alphabetInput := NewStopWordManager().IsStopWord("g")
	expected := true
	if input != expected {
		t.Errorf("expected %t, got %t", expected, input)
	}

	if input != expected {
		t.Errorf("expected %t, got %t", expected, alphabetInput)
	}
}

func TestIncrementCount(t *testing.T) {
	input := NewWordFrequencyManager()
	input.IncrementCount("test")
	input.IncrementCount("test")
	input.IncrementCount("test")
	expected := 3
	result := input.wordFreqs["test"]
	if result != expected {
		t.Errorf("expected %d, got %d", expected, result)
	}
}

func TestSorted(t *testing.T) {
	input := NewWordFrequencyManager()
	input.IncrementCount("test")
	input.IncrementCount("test")
	input.IncrementCount("test")
	input.IncrementCount("hard")
	input.IncrementCount("hard")
	input.IncrementCount("easy")
	expected := []Pair{{"test", 3}, {"hard", 2}, {"easy", 1}}
	result := input.Sorted()
	for i, pair := range result {
		if result[i].word != expected[i].word || result[i].count != expected[i].count {
			t.Errorf("expected %s %d, got %s %d", expected[0].word, expected[0].count, pair.word, pair.count)
		}
	}
}

func TestRun(t *testing.T) {
	input := NewWordFrequencyController("../test.txt")

	oldStdout := os.Stdout
	r, w, _ := os.Pipe()
	os.Stdout = w

	input.Run()

	w.Close()
	os.Stdout = oldStdout

	var buf bytes.Buffer
	buf.ReadFrom(r)
	capturedOutput := buf.String()

	expectedOutput := "test  -  3\nhard  -  1"
	if !strings.Contains(capturedOutput, expectedOutput) {
		t.Errorf("expected %s, got %s", expectedOutput, capturedOutput)
	}
}
