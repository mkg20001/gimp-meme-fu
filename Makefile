install:
	install -o root -g root -m 755 -D meme.scm $(wildcard /usr/share/gimp/*/scripts)
