package test

import (
	"template_method/document"
	"testing"
)

func TestHTMLDocumentPrepareData(t *testing.T) {
	expected := "<html><body>This is raw HTML data.</body></html>"
	textDoc := document.HTMLDocument{}
	result := textDoc.PrepareData()
	if result != expected {
		t.Errorf("expected %s, got %s", expected, result)
	}
}

func TestHTMLDocumentFormatData(t *testing.T) {
	expected := "<div><html><body>This is raw HTML data.</body></html></div>"
	textDoc := document.HTMLDocument{}
	result := textDoc.FormatContent("<html><body>This is raw HTML data.</body></html>")
	if result != expected {
		t.Errorf("expected %s, got %s", expected, result)
	}
}

func TestHTMLDocumentSave(t *testing.T) {
	expected := "Saving HTML document: <div><html><body>This is raw HTML data.</body></html></div>"
	textDoc := document.HTMLDocument{}
	result := textDoc.Save("<div><html><body>This is raw HTML data.</body></html></div>")
	if result != expected {
		t.Errorf("expected %s, got %s", expected, result)
	}
}
