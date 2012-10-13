# Makefile for the autorevision project

VERS=$(shell sed -n 's/version="\(.\+\)"/\1/p' autorevision)

.SUFFIXES: .md .html

.md.html:
	markdown $< >$@

MANDIR=/usr/share/man/man1
BINDIR=/usr/bin

DOCS    = README.md COPYING.md CONTRIBUTING.md autorevision.asc NEWS
SOURCES = autorevision Makefile $(DOCS) control

all: autorevision-$(VERS).tar.gz

install: autorevision.1
	cp autorevision 
	gzip <autorevision.1 >$(MANDIR)/autorevision.1.gz
	rm autorevision.1

uninstall:
	rm -f $(BINDIR)/autorevision $(MANDIR)/autorevision.1.gz

autorevision.1: autorevision.asc
	a2x -f manpage autorevision.asc

autorevision.html: autorevision.asc
	a2x -f html autorevision.asc

autorevision-$(VERS).tar.gz: $(SOURCES) autorevision.1 
	tar --transform='s:^:autorevision-$(VERS)/:' --show-transformed-names -cvzf autorevision-$(VERS).tar.gz $(SOURCES)

dist: autorevision-$(VERS).tar.gz

clean:
	rm -f autorevision.html autorevision.1 *.tar.gz 
	rm -f *~  SHIPPER.* index.html

release: autorevision-$(VERS).tar.gz autorevision.html README.html COPYING.html CONTRIBUTING.html
	shipper -u -m -t; make clean

