all: Training-Lawrencium-101-Feb2021_slides.html Training-Lawrencium-101-Feb2021.html

Training-Lawrencium-101-Feb2021.html: Training-Lawrencium-101-Feb2021.md
	pandoc -s -o Training-Lawrencium-101-Feb2021.html Training-Lawrencium-101-Feb2021.md

Training-Lawrencium-101-Feb2021_slides.html: Training-Lawrencium-101-Feb2021.md
	pandoc -s --webtex -t slidy -o Training-Lawrencium-101-Feb2021_slides.html Training-Lawrencium-101-Feb2021.md

clean:
	rm -rf Training-Lawrencium-101-Feb2021.html Training-Lawrencium-101-Feb2021_slides.html
