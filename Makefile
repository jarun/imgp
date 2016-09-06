PREFIX ?= /usr/local
BINDIR ?= $(DESTDIR)$(PREFIX)/bin
MANDIR ?= $(DESTDIR)$(PREFIX)/share/man/man1
DOCDIR ?= $(DESTDIR)$(PREFIX)/share/doc/imgd

.PHONY: all install uninstall

all:

install:
	install -m755 -d $(BINDIR)
	install -m755 -d $(MANDIR)
	install -m755 -d $(DOCDIR)
	gzip -c imgd.1 > imgd.1.gz
	install -m755 imgd $(BINDIR)
	install -m644 imgd.1.gz $(MANDIR)
	install -m644 README.md $(DOCDIR)
	rm -f imgd.1.gz

uninstall:
	rm -f $(BINDIR)/imgd
	rm -f $(MANDIR)/imgd.1.gz
	rm -rf $(DOCDIR)

publish:
	python setup.py sdist bdist_wheel upload
