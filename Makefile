export TARGET_NAME := x86_64-unknown-linux-gnu

all: assert_generator pjsua_ada_user_agent

deps: pjlibs

assert_generator:
	gcc src/assert_sizes_generator.c -o assert_sizes_generator

# The simple C user agent
simple_pjsua:
	gcc simple_pjsua.c -o simple_pjsua -lpjsua-$(TARGET_NAME)\
        -lpjsip-ua-$(TARGET_NAME)\
        -lpjsip-simple-$(TARGET_NAME)\
        -lpjsip-$(TARGET_NAME)\
        -lpjmedia-codec-$(TARGET_NAME)\
        -lpjmedia-videodev-$(TARGET_NAME)\
        -lpjmedia-$(TARGET_NAME)\
        -lpjmedia-audiodev-$(TARGET_NAME)\
        -lpjnath-$(TARGET_NAME)\
        -lilbccodec-$(TARGET_NAME)\
        -lportaudio-$(TARGET_NAME)\
        -lresample-$(TARGET_NAME)\
        -lsrtp-$(TARGET_NAME)\
        -lspeex-$(TARGET_NAME)\
        -lpjlib-util-$(TARGET_NAME)\
        $(APP_THIRD_PARTY_LIBS)\
        $(APP_THIRD_PARTY_EXT)\
        -lpj-$(TARGET_NAME)\
        -lm -lnsl -lrt -lpthread  -lasound  -lavcodec -lswscale -lavutil   -lv4l2
	

clean:
	-rm build/*ali build/*.o

distclean: clean
	-gnatclean ada_pjsua_test
	-rm ada_pjsua_test
	-rm assert_sizes_generator
	-rm src/assert_sizes.ads
	-rm pjproject-2.0.tar.bz2

pjsua_ada_user_agent:
	./assert_sizes_generator Assert_Sizes > src/assert_sizes.ads
	gnatmake -P ada_pjsua_test

pjproject-2.0: pjproject-2.0.tar.bz2
	tar xjf pjproject-2.0.tar.bz2

pjlibs: pjproject-2.0
	(cd pjproject-2.0; ./configure && make dep && make)	

pjproject-2.0.tar.bz2:
	wget http://www.pjsip.org/release/2.0/pjproject-2.0.tar.bz2

deps_install: pjproject-2.0
	(cd pjproject-2.0; make install);

.PHONY: simple_pjsua

