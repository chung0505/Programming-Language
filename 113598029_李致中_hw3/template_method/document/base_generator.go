package document

type BaseGenerator struct {
	DocumentGenerator
}

func (b *BaseGenerator) Generate() string {
	data := b.PrepareData()
	formattedData := b.FormatContent(data)
	return b.Save(formattedData)
}
