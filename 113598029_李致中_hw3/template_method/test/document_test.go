package test

import (
	// "template_method/document"
	"template_method/document"
	"testing"
)

func TestBaseGeneratorTextDocument(t *testing.T) {
	expected := "Saving text document: Formatted Text: This is the raw text data."
	doc := document.BaseGenerator{DocumentGenerator: document.TextDocument{}}
	result := doc.Generate()
	if result != expected {
		t.Errorf("Expected %s, got %s", expected, result)
	}
}

func TestBaseGeneratorHTMLDocument(t *testing.T) {
	expected := "Saving HTML document: <div><html><body>This is raw HTML data.</body></html></div>"
	doc := document.BaseGenerator{DocumentGenerator: document.HTMLDocument{}}
	result := doc.Generate()
	if result != expected {
		t.Errorf("Expected %s, got %s", expected, result)
	}
}
