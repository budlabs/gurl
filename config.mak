NAME         := gurl
CREATED      := 2020-03-25
DESCRIPTION  := simple plumbing framework
VERSION      := 2020.03
AUTHOR       := budRich
CONTACT      := https://github.com/budlabs/gurl
USAGE        := [--matchers-dir|-d DIR] URL [ARG...]
ORGANISATION := budlabs
MANPAGE      := $(NAME).1
README       := README.md
LICENSE      := LICENSE

README_LAYOUT  := \
	docs/readme_banner.md  \
	docs/readme_install.md \
	docs/description.md    \
	docs/readme_footer.md  \
	docs/releasenotes/0_next.md


MANPAGE_LAYOUT := \
	docs/manpage_banner.md      \
	.cache/help_table.txt       \
	docs/description.md         \
	docs/manpage_environment.md \
	docs/manpage_footer.md      \
	LICENSE


installed_manpage    = $(DESTDIR)$(PREFIX)/share/man/man$(manpage_section)/$(MANPAGE)
installed_script    := $(DESTDIR)$(PREFIX)/bin/$(NAME)
installed_license   := $(DESTDIR)$(PREFIX)/share/licenses/$(NAME)/$(LICENSE)

install: all
	install -Dm644 $(MANPAGE_OUT) $(installed_manpage)
	install -Dm644 $(LICENSE)     $(installed_license)
	install -Dm755 $(MONOLITH)    $(installed_script)

uninstall:
	@for f in $(installed_script) $(installed_manpage) $(installed_license); do
		[[ -f $$f ]] || continue
		echo "rm $$f"
		rm "$$f"
	done
