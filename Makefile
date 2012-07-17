export TARGET_NAME := x86_64-unknown-linux-gnu
export PJSUA_DIR := $(PWD)/pjsua-lib

PJBASE=$(PWD)/pjproject-2.0
include $(PJBASE)/build.mak

CC      = $(APP_CC)
LDFLAGS = $(APP_LDFLAGS)
LDLIBS  = $(APP_LDLIBS)
CFLAGS  = $(APP_CFLAGS)
CPPFLAGS= ${CFLAGS}

all: assert_generator gnatmake_part ada_pjsua_test

deps: pjlibs

assert_generator:
	gcc src/assert_sizes_generator.c -o assert_sizes_generator

# The simple C user agent
simple_pjsua:  simple_pjsua.c
	$(CC) -o $@ $< $(CPPFLAGS) $(LDFLAGS) $(LDLIBS)

ada_pjsua_test:
	(gnatbind build/ada_pjsua_test.ali && gnatlink build/ada_pjsua_test.ali -o $@ $<  $(CPPFLAGS) $(LDFLAGS) $(LDLIBS))

clean:
	-rm build/*ali build/*.o build/b~*.ad?

distclean: clean
	-gnatclean ada_pjsua_test
	-rm ada_pjsua_test
	-rm assert_sizes_generator
	-rm src/assert_sizes.ads
	-rm pjproject-2.0.tar.bz2

gnatmake_part:
	./assert_sizes_generator Assert_Sizes > src/assert_sizes.ads
	gnatmake -P ada_pjsua_test

pjproject-2.0: pjproject-2.0.tar.bz2
	tar xjf pjproject-2.0.tar.bz2

pjlibs: pjproject-2.0
	(cd pjproject-2.0; ./configure --prefix=$(PJSUA_DIR) && make dep && make && make install)	

pjproject-2.0.tar.bz2:
	wget http://www.pjsip.org/release/2.0/pjproject-2.0.tar.bz2

deps_install: pjproject-2.0
	(cd pjproject-2.0; make install);

.PHONY: simple_pjsua

