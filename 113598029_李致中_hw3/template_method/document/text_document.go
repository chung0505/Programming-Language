package document

type TextDocument struct {
}

func (h TextDocument) PrepareData() string {
	return "This is the raw text data."
}

func (h TextDocument) FormatContent(data string) string {
	return "Formatted Text: " + data
}

func (h TextDocument) Save(content string) string {
	return "Saving text document: " + content
}
