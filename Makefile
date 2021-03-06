MV ?= mv
CC ?= gcc
MKDIR ?= mkdir
INSTALL=	install
FFLAGS	= -g -O2 -fno-range-check -ffixed-line-length-none			-Wall -fbounds-check -fno-second-underscore -fPIC
LDFLAGS	= -L/usr/local/lib -L/usr/local/lib 
LIBS	+=  -lpthread  -lportaudio -lsamplerate -lfftw3f
CPPFLAGS = -I/usr/local/include -I/usr/local/include 
CFLAGS	=  -Wall -O0 -g  -Wall -O0 -g
PREFIX	= /usr/local
# WSJT specific C flags
CFLAGS	+= -DBIGSYM=1 -fPIC
DEFS = -DPACKAGE_NAME=\"wsjt\" -DPACKAGE_TARNAME=\"wsjt\" -DPACKAGE_VERSION=\"7.04\" -DPACKAGE_STRING=\"wsjt\ 7.04\" -DPACKAGE_BUGREPORT=\"\" -DFC_LIB_PATH=\"/usr/lib/gcc/i686-apple-darwin11/4.2.1/x86_64/\" -DFC=\"gfortran\" -DSTDC_HEADERS=1 -DHAVE_SYS_TYPES_H=1 -DHAVE_SYS_STAT_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1 -DHAVE_MEMORY_H=1 -DHAVE_STRINGS_H=1 -DHAVE_INTTYPES_H=1 -DHAVE_STDINT_H=1 -DHAVE_UNISTD_H=1 -DHAVE_INTTYPES_H=1 -DHAVE_STDINT_H=1 -DHAVE_SYS_RESOURCE_H=1 -DHAVE_SYS_PARAM_H=1 -DHAVE_ERRNO_H=1 -DHAVE_SYS_SYSLOG_H=1 -DHAVE_STDDEF_H=1 -DHAVE_LIBGEN_H=1 -DHAVE_SYS_WAIT_H=1 -DHAVE_STDIO_H=1 -DHAVE_TERMIOS_H=1 -DHAVE_SYS_RESOURCE_H=1 -DHAVE_SYS_STAT_H=1 -DHAVE_FCNTL_H=1 -DHAVE_SYS_IOCTL_H=1 -DTIME_WITH_SYS_TIME=1 -DSTRING_WITH_STRINGS=1 -DNDEBUG=1 -DHAS_SAMPLERATE_H=1 -DHAS_PORTAUDIO=1 -DHAS_PORTAUDIO_H=1 -DHAS_PORTAUDIO_LIB=1 -DHAS_FFTW3_H=1 -DHAS_FFTW3FLIBS=1
CFLAGS += ${DEFS}
CPPFLAGS += ${DEFS} -I.

# WSJT specific Fortran flags
#FFLAGS += -Wall -Wno-precision-loss -fbounds-check -fno-second-underscore -fPIC

Audio:	WsjtMod/Audio.so

# Default rules
%.o: %.c
	${CC} ${CFLAGS} -c $<
%.o: %.f
	${FC} ${FFLAGS} -c $<
%.o: %.F
	${FC} ${FFLAGS} -c $<
%.o: %.f90
	${FC} ${FFLAGS} -c $<
%.o: %.F90
	${FC} ${FFLAGS} -c $<

OS=Darwin
FC=gfortran
FCV=gnu95
FC_LIB_PATH	+= /usr/lib/gcc/i686-apple-darwin11/4.2.1/x86_64/

LDFLAGS	+= -L${FC_LIB_PATH}

PYTHON	?= /Library/Frameworks/Python.framework/Versions/2.7/bin/python
RM	?= /bin/rm
F2PY	= /Library/Frameworks/Python.framework/Versions/2.7/bin/f2py

OBJS1 = JT65code.o nchar.o grid2deg.o packmsg.o packtext.o \
	packcall.o packgrid.o unpackmsg.o unpacktext.o unpackcall.o \
	unpackgrid.o deg2grid.o chkmsg.o getpfx1.o \
	getpfx2.o k2grid.o grid2k.o interleave63.o graycode.o set.o \
	igray.o init_rs_int.o encode_rs_int.o decode_rs_int.o \
	wrapkarn.o cutil.o

F2PYONLY = ftn_init ftn_quit audio_init spec getfile azdist0 astro0 chkt0

SRCS2F90 = wsjt1.f90 a2d.f90 abc441.f90 astro0.f90 audio_init.f90 azdist0.f90 \
	decode1.f90 decode2.f90 decode3.f90 ftn_init.f90 \
	ftn_quit.f90 get_fname.f90 getfile.f90 horizspec.f90 hscroll.f90 \
	pix2d.f90 pix2d65.f90 rfile.f90 savedata.f90 spec.f90 match.f90 \
	wsjtgen.f90 fivehz.f90 chkt0.f90 makepings.f90 \
	packpfx.f90 unpackpfx.f90 genms.f90 decodems.f90 setupms.f90 \
	thnix.f90 tweak1.f90 smo.f90 analytic.f90 geniscat.f90 synciscat.f90 \
	iscat.f90 four2a.f90 hipass.f90 msdf.f90 syncms.f90 lenms.f90 \
	jtms.f90 foldms.f90 avecho.f90 echogen.f90 alignmsg.f90 \
	chk441.f90 gen441.f90 tm2.f90 gendiana.f90 diana.f90 ana932.f90 \
	specdiana.f90 syncdiana.f90 decdiana.f90 tweak2.f90 dtrim.f90 \
	wsjt4.f90 decode4.f90 encode4.f90 getmet4.f90 extract4.f90 \
	deep4.f90 avemsg4.f90 encode232.f90 fano232.f90 sync4.f90 \
	snr4.f90 xcor4.f90 gen4.f90 ps4.f90 interleave4.f90 rfile2.f90 \
	spread.f90

OBJS2F90 = ${SRCS2F90:.f90=.o}

SRCS2F77 = avesp2.f bzap.f spec441.f spec2d.f mtdecode.f stdecode.f \
	indexx.f s2shape.f flat2.f gen65.f entail.f \
	genmet.f chkmsg.f astro.f extract.f \
	gentone.f syncf0.f syncf1.f synct.f avemsg6m.f \
	set.f flatten.f db.f pctile.f sort.f ssort.f ps.f smooth.f ping.f \
	longx.f peakup.f sync.f detect.f avemsg65.f decode65.f demod64a.f \
	encode65.f chkhist.f flat1.f gencw.f \
	gencwid.f msgtype.f getpfx1.f \
	getpfx2.f getsnr.f graycode.f grid2k.f interleave63.f k2grid.f \
	limit.f lpf1.f morse.f nchar.f packcall.f packgrid.f \
	packmsg.f packtext.f setup65.f short65.f slope.f spec2d65.f \
	sync65.f unpackcall.f unpackgrid.f unpackmsg.f unpacktext.f \
	xcor.f xfft.f xfft2.f wsjt65.f azdist.f coord.f dcoord.f \
	deg2grid.f dot.f ftsky.f geocentric.f GeoDist.f grid2deg.f \
	moon2.f MoonDop.f sun.f toxyz.f pfxdump.f \
	ftpeak65.f fil651.f fil652.f fil653.f symsync65.f 

OBJS2F77 = ${SRCS2F77:.f=.o} deep65.o

SRCS2C	= init_rs.c encode_rs.c decode_rs.c fano.c tab.c nhash.c \
	cutil.c fthread.c tmoonsub.c gran.c
OBJS2C  = ${SRCS2C:.c=.o}

SRCS3C	= ptt_unix.c igray.c wrapkarn.c
OBJS3C  = ${SRCS3C:.c=.o}
AUDIOSRCS = jtaudio.c start_threads.c resample.c

all:	WsjtMod/Audio.so wsjt9 JT65code

JT65code: $(OBJS1)
	$(FC) -o JT65code $(OBJS1)

build:	WsjtMod/Audio.so

WsjtMod/Audio.so: $(OBJS2C) $(OBJS3C) $(OBJS2F77) $(SRCS2F90) $(AUDIOSRCS)
	${F2PY} -c --quiet --noopt --debug \
	--f77flags="${FFLAGS}" --f90flags="${FFLAGS}" \
	$(OBJS2C) $(OBJS2F77) -m Audio \
	--fcompiler=${FCV} --f77exec=${FC} --f90exec=${FC} \
	${CPPFLAGS} ${LDFLAGS} ${LIBS} \
	only: $(F2PYONLY) : $(SRCS2F90) \
	${SRCS3C} ${AUDIOSRCS}
	${MV} Audio.so WsjtMod

wsjt9:  WsjtMod/Audio.so wsjt9.spec
	python /home/joe/temp/pyinstaller-1.3/Build.py wsjt9.spec

wsjt9.spec: wsjt9.py WsjtMod/astro.py WsjtMod/g.py WsjtMod/options.py \
	WsjtMod/palettes.py WsjtMod/smeter.py WsjtMod/specjt.py
	python /home/joe/temp/pyinstaller-1.3/Makespec.py --icon wsjt.ico \
	--tk --onefile wsjt9.py
wsjt9.py: wsjt.py
	cp wsjt.py wsjt9.py

init_rs_int.o: init_rs.c
	$(CC) $(CFLAGS) -c -DBIGSYM=1 -o init_rs_int.o init_rs.c
encode_rs_int.o: encode_rs.c
	$(CC) $(CFLAGS) -c -DBIGSYM=1 -o encode_rs_int.o encode_rs.c
decode_rs_int.o: decode_rs.c
	$(CC) $(CFLAGS) -c -DBIGSYM=1 -o decode_rs_int.o decode_rs.c

cutil.o: cutil.c
	$(CC) $(CFLAGS) -c -DSTARNIX=1 cutil.c

install:	WsjtMod/Audio.so
	${RM} -rf build/
	${PYTHON} setup.py install
	${MKDIR} -p ${PREFIX}/share/wsjt
	${INSTALL} -m 0644 CALL3.TXT ${PREFIX}/share/wsjt/
	${INSTALL} -m 0644 wsjtrc ${PREFIX}/share/wsjt/
	${INSTALL} -m 0644 dmet_*.dat ${PREFIX}/share/wsjt/
	${INSTALL} wsjt ${PREFIX}/bin

deb: wsjt.py WsjtMod/Audio.so WsjtMod/g.py WsjtMod/__init__.py \
	WsjtMod/options.py WsjtMod/palettes.py WsjtMod/PmwBlt.py \
	WsjtMod/PmwColor.py WsjtMod/Pmw.py WsjtMod/smeter.py \
	WsjtMod/specjt.py WsjtMod/astro.py DEB/DEBIAN/control \
	wsjtrc

	cp wsjt.py wsjtrc CALL3.TXT dmet_10_-1_3.dat \
	dmet_20_-2_2.dat kvasd.dat KVASD_g95 TSKY.DAT \
	wsjt.ico wsjt.jpg WSJT_Quick_Reference.pdf WSJT_User_600.pdf DEB/WSJT9

	cp WsjtMod/Audio.so DEB/WSJT9/WsjtMod
	cp WsjtMod/*.py DEB/WSJT9/WsjtMod
	dpkg-deb --build DEB wsjt_ver_rev_i386.deb

.PHONY : clean
clean:
	${RM} -f *.o *.pyc *.so *~ JT65code wsjt9 WsjtMod/*.pyc WsjtMod/*.pyc \
		WsjtMod/*.so wsjt9.py wsjt9.spec t75
	${RM} -rf build/

distclean: clean
	${RM} -f config.log config.status Makefile

