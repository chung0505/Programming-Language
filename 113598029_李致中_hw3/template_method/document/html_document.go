package document

type HTMLDocument struct {
}

func (h HTMLDocument) PrepareData() string {
	return "<html><body>This is raw HTML data.</body></html>"
}

func (h HTMLDocument) FormatContent(data string) string {
	return "<div>" + data + "</div>"
}

func (h HTMLDocument) Save(content string) string {
	return "Saving HTML document: " + content
}
