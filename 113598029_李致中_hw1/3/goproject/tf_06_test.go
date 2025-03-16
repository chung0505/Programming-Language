package main

import (
	"testing"
)

func TestReadFile(t *testing.T) {
	expected := "This is Not a hard test. This test is only a test."
	result := readFile("../test.txt")
	if result != expected {
		t.Errorf("expected %s, got %s", expected, result)
	}
}

func TestFilterCharsAndNormalize(t *testing.T) {
	input := "This is Not a hard test. This test is only a test. a"
	expected := "this is not a hard test this test is only a test a"
	result := filterCharsAndNormalize(input)
	if result != expected {
		t.Errorf("expected %s, got %s", expected, result)
	}
}

func TestScan(t *testing.T) {
	input := "this is not a hard test this test is only a test "
	expected := []string{"this", "is", "not", "a", "hard", "test", "this", "test", "is", "only", "a", "test"}
	result := scan(input)
	for i, word := range result {
		if word != expected[i] {
			t.Errorf("expected %s, got %s", expected[i], word)
		}
	}
}

func TestRemoveStopWords(t *testing.T) {
	input := []string{"this", "is", "not", "a", "hard", "test", "this", "test", "is", "only", "a", "test"}
	expected := []string{"hard", "test", "test", "test"}

	result := removeStopWords(input)
	for i, word := range result {
		if word != expected[i] {
			t.Errorf("expected %s, got %s", expected[i], word)
		}
	}
}

func TestFrequencies(t *testing.T) {
	input := []string{"hard", "test", "test", "test"}
	expected := map[string]int{"hard": 1, "test": 3}
	result := frequecies(input)
	for k, v := range expected {
		if result[k] != v {
			t.Errorf("expected %d, got %d for word %s", v, result[k], k)
		}
	}
}

func TestSort(t *testing.T) {
	input := map[string]int{"hard": 1, "test": 3}
	expected := []pair{{"test", 3}, {"hard", 1}}
	result := sort(input)
	for i, p := range result {
		if p != expected[i] {
			t.Errorf("expected %v, got %v", expected[i], p)
		}
	}
}
