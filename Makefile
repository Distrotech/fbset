#
# Linux Frame Buffer Device Configuration
#

CC =		gcc -Wall -O2 -I.
BISON =		bison -d
FLEX =		flex
INSTALL =	ginstall
RM =		rm -f

all:		fbset


fbset:		fbset.o modes.tab.o lex.yy.o

fbset.o:	fbset.c fbset.h fb.h
modes.tab.o:	modes.tab.c fbset.h fb.h
lex.yy.o:	lex.yy.c fbset.h modes.tab.h

lex.yy.c:	modes.l
		$(FLEX) modes.l

modes.tab.c:	modes.y
		$(BISON) modes.y
modes.tab.h:	modes.tab.c

install:	fbset
		$(INSTALL) -D fbset $(DESTDIR)/usr/sbin/fbset
		$(INSTALL) -D fbset.8 $(DESTDIR)/usr/share/man/man8/fbset.8
		$(INSTALL) -D fb.modes.5 $(DESTDIR)/usr/share/man/man5/fb.modes.5
		for modefile in fb.modes.ATI  fb.modes.Falcon  fb.modes.NTSC  fb.modes.PAL;do\
		  $(INSTALL) -D etc/$$modefile $(DESTDIR)/etc/fb.modes.d/$$modefile;\
		done

clean:
		$(RM) *.o fbset lex.yy.c modes.tab.c modes.tab.h
