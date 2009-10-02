# fmenu - fast menu
# See LICENSE file for copyright and license details.

include config.mk

SRC = fmenu.c
OBJ = ${SRC:.c=.o}

all: options fmenu

options:
	@echo fmenu build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	@echo CC $<
	@${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

fmenu: ${OBJ}
	@echo CC -o $@
	@${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	@echo cleaning
	@rm -f fmenu ${OBJ} fmenu-${VERSION}.tar.gz

dist: clean
	@echo creating dist tarball
	@mkdir -p fmenu-${VERSION}
	@cp -R LICENSE Makefile README config.mk dmenu.1 config.h dmenu_path dmenu_run ${SRC} fmenu-${VERSION}
	@tar -cf fmenu-${VERSION}.tar fmenu-${VERSION}
	@gzip fmenu-${VERSION}.tar
	@rm -rf fmenu-${VERSION}

install: all
	@echo installing executable file to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f dmenu dmenu_path dmenu_run ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/dmenu
	@chmod 755 ${DESTDIR}${PREFIX}/bin/dmenu_path
	@chmod 755 ${DESTDIR}${PREFIX}/bin/dmenu_run
	@echo installing manual page to ${DESTDIR}${MANPREFIX}/man1
	@mkdir -p ${DESTDIR}${MANPREFIX}/man1
	@sed "s/VERSION/${VERSION}/g" < dmenu.1 > ${DESTDIR}${MANPREFIX}/man1/dmenu.1
	@chmod 644 ${DESTDIR}${MANPREFIX}/man1/dmenu.1

uninstall:
	@echo removing executable file from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/dmenu ${DESTDIR}${PREFIX}/bin/dmenu_path
	@rm -f ${DESTDIR}${PREFIX}/bin/dmenu ${DESTDIR}${PREFIX}/bin/dmenu_run
	@echo removing manual page from ${DESTDIR}${MANPREFIX}/man1
	@rm -f ${DESTDIR}${MANPREFIX}/man1/dmenu.1

.PHONY: all options clean dist install uninstall
