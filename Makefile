PREFIX ?= /usr/local
BINDIR ?= $(DESTDIR)$(PREFIX)/bin
MANDIR ?= $(DESTDIR)$(PREFIX)/share/man/man1
DOCDIR ?= $(DESTDIR)$(PREFIX)/share/doc/imgp

.PHONY: all install uninstall

all:

install:
	install -m755 -d $(BINDIR)
	install -m755 -d $(MANDIR)
	install -m755 -d $(DOCDIR)
	gzip -c imgp.1 > imgp.1.gz
	install -m755 imgp $(BINDIR)
	install -m644 imgp.1.gz $(MANDIR)
	install -m644 README.md $(DOCDIR)
	rm -f imgp.1.gz

uninstall:
	rm -f $(BINDIR)/imgp
	rm -f $(MANDIR)/imgp.1.gz
	rm -rf $(DOCDIR)

test:
	./imgp --help
