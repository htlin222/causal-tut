.PHONY: all render preview clean help deploy

# Default target
all: render

# Render both formats (outputs to project root)
render:
	quarto render index.qmd

# Preview with live reload
preview:
	quarto preview index.qmd

# Build for deployment (copy to _site)
deploy:
	quarto render index.qmd
	mkdir -p _site
	cp -r index.html slides.html index_files slides_files _site/ 2>/dev/null || true
	cp -r custom.scss _site/ 2>/dev/null || true

# Clean output
clean:
	rm -rf _site .quarto index.html slides.html index_files slides_files

# Help
help:
	@echo "Usage:"
	@echo "  make          - Build slides.html and index.html"
	@echo "  make preview  - Live preview with auto-reload"
	@echo "  make deploy   - Build and copy to _site/ for deployment"
	@echo "  make clean    - Remove output files"
	@echo ""
	@echo "Output files:"
	@echo "  index.html  - HTML page with TOC"
	@echo "  slides.html - Revealjs presentation"
