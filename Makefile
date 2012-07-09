export TARGET_NAME := x86_64-unknown-linux-gnu

all: manual_bindings_test

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

distclean: clean
	-gnatclean ada_pjsua_test
	rm ada_pjsua_test

manual_bindings_test:
	gnatmake -P ada_pjsua_test


.PHONY: simple_pjsua
