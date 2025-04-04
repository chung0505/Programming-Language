package test

import (
	"template_method/document"
	"testing"
)

func TestTextDocumentPrepareData(t *testing.T) {
	expected := "This is the raw text data."
	textDoc := document.TextDocument{}
	result := textDoc.PrepareData()
	if result != expected {
		t.Errorf("expected %s, got %s", expected, result)
	}
}

func TestTextDocumentFormatData(t *testing.T) {
	expected := "Formatted Text: This is the raw text data."
	textDoc := document.TextDocument{}
	result := textDoc.FormatContent("This is the raw text data.")
	if result != expected {
		t.Errorf("expected %s, got %s", expected, result)
	}
}

func TestTextDocumentSave(t *testing.T) {
	expected := "Saving text document: Formatted Text: This is the raw text data."
	textDoc := document.TextDocument{}
	result := textDoc.Save("Formatted Text: This is the raw text data.")
	if result != expected {
		t.Errorf("expected %s, got %s", expected, result)
	}
}
