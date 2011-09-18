From: Richard Weinberger <richard@nod.at>
Subject: Can't build iptables (git as of today)
Date: Sun, 18 Sep 2011 14:20:45 +0200
Message-ID: <4E75E21D.6050000@nod.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEDF5526BFA869E4D5CFD7988"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:35714 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573Ab1IRMUy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 Sep 2011 08:20:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEDF5526BFA869E4D5CFD7988
Content-Type: multipart/mixed;
 boundary="------------050405020403060504050005"

This is a multi-part message in MIME format.
--------------050405020403060504050005
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi!

I'm trying to build the most recent iptables version but the build fails
with:

make[2]: *** No rule to make target `../extensions/libext.a', needed by
`xtables-multi'.  Stop.

It this a known problem?
Full build log is attached.

Thanks,
//richard

--------------050405020403060504050005
Content-Type: text/x-log;
 name="build.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="build.log"

rw@raccoon:~/src/iptables (master)> ./autogen.sh=20
libtoolize: putting auxiliary files in `.'.
libtoolize: copying file `./ltmain.sh'
libtoolize: putting macros in AC_CONFIG_MACRO_DIR, `m4'.
libtoolize: copying file `m4/libtool.m4'
libtoolize: copying file `m4/ltoptions.m4'
libtoolize: copying file `m4/ltsugar.m4'
libtoolize: copying file `m4/ltversion.m4'
libtoolize: copying file `m4/lt~obsolete.m4'
configure.ac:13: installing `./compile'
configure.ac:15: installing `./config.guess'
configure.ac:15: installing `./config.sub'
configure.ac:10: installing `./install-sh'
configure.ac:11: installing `./missing'
iptables/Makefile.am: installing `./depcomp'
rw@raccoon:~/src/iptables (master)> ./configure --prefix=3D/opt/iptables-=
dev/
checking for a BSD-compatible install... /usr/bin/install -c
checking whether build environment is sane... yes
checking for a thread-safe mkdir -p... /bin/mkdir -p
checking for gawk... gawk
checking whether make sets $(MAKE)... yes
checking for gcc... gcc
checking whether the C compiler works... yes
checking for C compiler default output file name... a.out
checking for suffix of executables...=20
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ISO C89... none needed
checking for style of include used by make... GNU
checking dependency style of gcc... gcc3
checking whether gcc and cc understand -c and -o together... yes
checking build system type... x86_64-suse-linux-gnu
checking host system type... x86_64-suse-linux-gnu
checking for a sed that does not truncate output... /usr/bin/sed
checking for grep that handles long lines and -e... /usr/bin/grep
checking for egrep... /usr/bin/grep -E
checking for fgrep... /usr/bin/grep -F
checking for ld used by gcc... /usr/x86_64-suse-linux/bin/ld
checking if the linker (/usr/x86_64-suse-linux/bin/ld) is GNU ld... yes
checking for BSD- or MS-compatible name lister (nm)... /usr/bin/nm -B
checking the name lister (/usr/bin/nm -B) interface... BSD nm
checking whether ln -s works... yes
checking the maximum length of command line arguments... 1572864
checking whether the shell understands some XSI constructs... yes
checking whether the shell understands "+=3D"... yes
checking for /usr/x86_64-suse-linux/bin/ld option to reload object files.=
=2E. -r
checking for objdump... objdump
checking how to recognize dependent libraries... pass_all
checking for ar... ar
checking for strip... strip
checking for ranlib... ranlib
checking command to parse /usr/bin/nm -B output from gcc object... ok
checking how to run the C preprocessor... gcc -E
checking for ANSI C header files... yes
checking for sys/types.h... yes
checking for sys/stat.h... yes
checking for stdlib.h... yes
checking for string.h... yes
checking for memory.h... yes
checking for strings.h... yes
checking for inttypes.h... yes
checking for stdint.h... yes
checking for unistd.h... yes
checking for dlfcn.h... yes
checking for objdir... .libs
checking if gcc supports -fno-rtti -fno-exceptions... no
checking for gcc option to produce PIC... -fPIC -DPIC
checking if gcc PIC flag -fPIC -DPIC works... yes
checking if gcc static flag -static works... yes
checking if gcc supports -c -o file.o... yes
checking if gcc supports -c -o file.o... (cached) yes
checking whether the gcc linker (/usr/x86_64-suse-linux/bin/ld -m elf_x86=
_64) supports shared libraries... yes
checking whether -lc should be explicitly linked in... no
checking dynamic linker characteristics... GNU/Linux ld.so
checking how to hardcode library paths into programs... immediate
checking whether stripping libraries is possible... yes
checking if libtool supports shared libraries... yes
checking whether to build shared libraries... yes
checking whether to build static libraries... no
checking whether the linker accepts -Wl,--no-as-needed... yes
checking linux/dccp.h usability... yes
checking linux/dccp.h presence... yes
checking for linux/dccp.h... yes
checking linux/ip_vs.h usability... yes
checking linux/ip_vs.h presence... yes
checking for linux/ip_vs.h... yes
checking linux/magic.h usability... yes
checking linux/magic.h presence... yes
checking for linux/magic.h... yes
checking linux/proc_fs.h usability... no
checking linux/proc_fs.h presence... no
checking for linux/proc_fs.h... no
checking size of struct ip6_hdr... 40
checking for pkg-config... /usr/bin/pkg-config
checking pkg-config is at least version 0.9.0... yes
checking for libnfnetlink... no
configure: creating ./config.status
config.status: creating Makefile
config.status: creating extensions/GNUmakefile
config.status: creating include/Makefile
config.status: creating iptables/Makefile
config.status: creating iptables/xtables.pc
config.status: creating libipq/Makefile
config.status: creating libipq/libipq.pc
config.status: creating libiptc/Makefile
config.status: creating libiptc/libiptc.pc
config.status: creating utils/Makefile
config.status: creating include/xtables.h
config.status: creating include/iptables/internal.h
config.status: creating config.h
config.status: executing depfiles commands
config.status: executing libtool commands
rw@raccoon:~/src/iptables (master)> make
make  all-recursive
make[1]: Entering directory `/home/rw/src/iptables'
Making all in libiptc
make[2]: Entering directory `/home/rw/src/iptables/libiptc'
/bin/sh ../libtool --tag=3DCC   --mode=3Dcompile gcc -DHAVE_CONFIG_H -I. =
-I..  -D_LARGEFILE_SOURCE=3D1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=3D64 -D_=
REENTRANT  -DXTABLES_LIBDIR=3D\"/opt/iptables-dev/lib/xtables\" -DXTABLES=
_INTERNAL -I../include -I../include   -Wall -Waggregate-return -Wmissing-=
declarations    -Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-=
prototypes  -Winline -pipe -g -O2 -MT libip4tc.lo -MD -MP -MF .deps/libip=
4tc.Tpo -c -o libip4tc.lo libip4tc.c
libtool: compile:  gcc -DHAVE_CONFIG_H -I. -I.. -D_LARGEFILE_SOURCE=3D1 -=
D_LARGE_FILES -D_FILE_OFFSET_BITS=3D64 -D_REENTRANT -DXTABLES_LIBDIR=3D\"=
/opt/iptables-dev/lib/xtables\" -DXTABLES_INTERNAL -I../include -I../incl=
ude -Wall -Waggregate-return -Wmissing-declarations -Wmissing-prototypes =
-Wredundant-decls -Wshadow -Wstrict-prototypes -Winline -pipe -g -O2 -MT =
libip4tc.lo -MD -MP -MF .deps/libip4tc.Tpo -c libip4tc.c  -fPIC -DPIC -o =
=2Elibs/libip4tc.o
mv -f .deps/libip4tc.Tpo .deps/libip4tc.Plo
/bin/sh ../libtool --tag=3DCC   --mode=3Dlink gcc -Wall -Waggregate-retur=
n -Wmissing-declarations   -Wmissing-prototypes -Wredundant-decls -Wshado=
w -Wstrict-prototypes  -Winline -pipe -g -O2 -version-info 1:0:1  -o libi=
p4tc.la -rpath /opt/iptables-dev/lib libip4tc.lo =20
libtool: link: gcc -shared  .libs/libip4tc.o      -Wl,-soname -Wl,libip4t=
c.so.0 -o .libs/libip4tc.so.0.1.0
libtool: link: (cd ".libs" && rm -f "libip4tc.so.0" && ln -s "libip4tc.so=
=2E0.1.0" "libip4tc.so.0")
libtool: link: (cd ".libs" && rm -f "libip4tc.so" && ln -s "libip4tc.so.0=
=2E1.0" "libip4tc.so")
libtool: link: ( cd ".libs" && rm -f "libip4tc.la" && ln -s "../libip4tc.=
la" "libip4tc.la" )
/bin/sh ../libtool --tag=3DCC   --mode=3Dcompile gcc -DHAVE_CONFIG_H -I. =
-I..  -D_LARGEFILE_SOURCE=3D1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=3D64 -D_=
REENTRANT  -DXTABLES_LIBDIR=3D\"/opt/iptables-dev/lib/xtables\" -DXTABLES=
_INTERNAL -I../include -I../include   -Wall -Waggregate-return -Wmissing-=
declarations    -Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-=
prototypes  -Winline -pipe -g -O2 -MT libip6tc.lo -MD -MP -MF .deps/libip=
6tc.Tpo -c -o libip6tc.lo libip6tc.c
libtool: compile:  gcc -DHAVE_CONFIG_H -I. -I.. -D_LARGEFILE_SOURCE=3D1 -=
D_LARGE_FILES -D_FILE_OFFSET_BITS=3D64 -D_REENTRANT -DXTABLES_LIBDIR=3D\"=
/opt/iptables-dev/lib/xtables\" -DXTABLES_INTERNAL -I../include -I../incl=
ude -Wall -Waggregate-return -Wmissing-declarations -Wmissing-prototypes =
-Wredundant-decls -Wshadow -Wstrict-prototypes -Winline -pipe -g -O2 -MT =
libip6tc.lo -MD -MP -MF .deps/libip6tc.Tpo -c libip6tc.c  -fPIC -DPIC -o =
=2Elibs/libip6tc.o
mv -f .deps/libip6tc.Tpo .deps/libip6tc.Plo
/bin/sh ../libtool --tag=3DCC   --mode=3Dlink gcc -Wall -Waggregate-retur=
n -Wmissing-declarations   -Wmissing-prototypes -Wredundant-decls -Wshado=
w -Wstrict-prototypes  -Winline -pipe -g -O2 -version-info 1:0:1 -Wl,--no=
-as-needed  -o libip6tc.la -rpath /opt/iptables-dev/lib libip6tc.lo =20
libtool: link: gcc -shared  .libs/libip6tc.o    -Wl,--no-as-needed   -Wl,=
-soname -Wl,libip6tc.so.0 -o .libs/libip6tc.so.0.1.0
libtool: link: (cd ".libs" && rm -f "libip6tc.so.0" && ln -s "libip6tc.so=
=2E0.1.0" "libip6tc.so.0")
libtool: link: (cd ".libs" && rm -f "libip6tc.so" && ln -s "libip6tc.so.0=
=2E1.0" "libip6tc.so")
libtool: link: ( cd ".libs" && rm -f "libip6tc.la" && ln -s "../libip6tc.=
la" "libip6tc.la" )
/bin/sh ../libtool --tag=3DCC   --mode=3Dlink gcc -Wall -Waggregate-retur=
n -Wmissing-declarations   -Wmissing-prototypes -Wredundant-decls -Wshado=
w -Wstrict-prototypes  -Winline -pipe -g -O2 -version-info 0:0:0 -Wl,--no=
-as-needed  -o libiptc.la -rpath /opt/iptables-dev/lib  libip4tc.la libip=
6tc.la=20
libtool: link: gcc -shared   -Wl,-rpath -Wl,/home/rw/src/iptables/libiptc=
/.libs -Wl,-rpath -Wl,/opt/iptables-dev/lib ./.libs/libip4tc.so ./.libs/l=
ibip6tc.so  -Wl,--no-as-needed   -Wl,-soname -Wl,libiptc.so.0 -o .libs/li=
biptc.so.0.0.0
libtool: link: (cd ".libs" && rm -f "libiptc.so.0" && ln -s "libiptc.so.0=
=2E0.0" "libiptc.so.0")
libtool: link: (cd ".libs" && rm -f "libiptc.so" && ln -s "libiptc.so.0.0=
=2E0" "libiptc.so")
libtool: link: ( cd ".libs" && rm -f "libiptc.la" && ln -s "../libiptc.la=
" "libiptc.la" )
make[2]: Leaving directory `/home/rw/src/iptables/libiptc'
Making all in iptables
make[2]: Entering directory `/home/rw/src/iptables/iptables'
/bin/sh ../libtool  --tag=3DCC   --mode=3Dcompile gcc -DHAVE_CONFIG_H -I.=
 -I..  -D_LARGEFILE_SOURCE=3D1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=3D64 -D=
_REENTRANT         -DXTABLES_LIBDIR=3D\"/opt/iptables-dev/lib/xtables\" -=
DXTABLES_INTERNAL -I../include -I../include   -Wall -Waggregate-return -W=
missing-declarations    -Wmissing-prototypes -Wredundant-decls -Wshadow -=
Wstrict-prototypes  -Winline -pipe -g -O2 -MT libxtables_la-xtables.lo -M=
D -MP -MF .deps/libxtables_la-xtables.Tpo -c -o libxtables_la-xtables.lo =
`test -f 'xtables.c' || echo './'`xtables.c
libtool: compile:  gcc -DHAVE_CONFIG_H -I. -I.. -D_LARGEFILE_SOURCE=3D1 -=
D_LARGE_FILES -D_FILE_OFFSET_BITS=3D64 -D_REENTRANT -DXTABLES_LIBDIR=3D\"=
/opt/iptables-dev/lib/xtables\" -DXTABLES_INTERNAL -I../include -I../incl=
ude -Wall -Waggregate-return -Wmissing-declarations -Wmissing-prototypes =
-Wredundant-decls -Wshadow -Wstrict-prototypes -Winline -pipe -g -O2 -MT =
libxtables_la-xtables.lo -MD -MP -MF .deps/libxtables_la-xtables.Tpo -c x=
tables.c  -fPIC -DPIC -o .libs/libxtables_la-xtables.o
mv -f .deps/libxtables_la-xtables.Tpo .deps/libxtables_la-xtables.Plo
/bin/sh ../libtool  --tag=3DCC   --mode=3Dcompile gcc -DHAVE_CONFIG_H -I.=
 -I..  -D_LARGEFILE_SOURCE=3D1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=3D64 -D=
_REENTRANT         -DXTABLES_LIBDIR=3D\"/opt/iptables-dev/lib/xtables\" -=
DXTABLES_INTERNAL -I../include -I../include   -Wall -Waggregate-return -W=
missing-declarations    -Wmissing-prototypes -Wredundant-decls -Wshadow -=
Wstrict-prototypes  -Winline -pipe -g -O2 -MT libxtables_la-xtoptions.lo =
-MD -MP -MF .deps/libxtables_la-xtoptions.Tpo -c -o libxtables_la-xtoptio=
ns.lo `test -f 'xtoptions.c' || echo './'`xtoptions.c
libtool: compile:  gcc -DHAVE_CONFIG_H -I. -I.. -D_LARGEFILE_SOURCE=3D1 -=
D_LARGE_FILES -D_FILE_OFFSET_BITS=3D64 -D_REENTRANT -DXTABLES_LIBDIR=3D\"=
/opt/iptables-dev/lib/xtables\" -DXTABLES_INTERNAL -I../include -I../incl=
ude -Wall -Waggregate-return -Wmissing-declarations -Wmissing-prototypes =
-Wredundant-decls -Wshadow -Wstrict-prototypes -Winline -pipe -g -O2 -MT =
libxtables_la-xtoptions.lo -MD -MP -MF .deps/libxtables_la-xtoptions.Tpo =
-c xtoptions.c  -fPIC -DPIC -o .libs/libxtables_la-xtoptions.o
mv -f .deps/libxtables_la-xtoptions.Tpo .deps/libxtables_la-xtoptions.Plo=

/bin/sh ../libtool --tag=3DCC   --mode=3Dlink gcc -Wall -Waggregate-retur=
n -Wmissing-declarations   -Wmissing-prototypes -Wredundant-decls -Wshado=
w -Wstrict-prototypes  -Winline -pipe -g -O2 -version-info 7:0:0  -o libx=
tables.la -rpath /opt/iptables-dev/lib libxtables_la-xtables.lo libxtable=
s_la-xtoptions.lo  -ldl=20
libtool: link: gcc -shared  .libs/libxtables_la-xtables.o .libs/libxtable=
s_la-xtoptions.o   -ldl    -Wl,-soname -Wl,libxtables.so.7 -o .libs/libxt=
ables.so.7.0.0
libtool: link: (cd ".libs" && rm -f "libxtables.so.7" && ln -s "libxtable=
s.so.7.0.0" "libxtables.so.7")
libtool: link: (cd ".libs" && rm -f "libxtables.so" && ln -s "libxtables.=
so.7.0.0" "libxtables.so")
libtool: link: ( cd ".libs" && rm -f "libxtables.la" && ln -s "../libxtab=
les.la" "libxtables.la" )
gcc -DHAVE_CONFIG_H -I. -I..  -D_LARGEFILE_SOURCE=3D1 -D_LARGE_FILES -D_F=
ILE_OFFSET_BITS=3D64 -D_REENTRANT  -DXTABLES_LIBDIR=3D\"/opt/iptables-dev=
/lib/xtables\" -DXTABLES_INTERNAL -I../include -I../include   -Wall -Wagg=
regate-return -Wmissing-declarations         -Wmissing-prototypes -Wredun=
dant-decls -Wshadow -Wstrict-prototypes     -Winline -pipe  -DENABLE_IPV4=
 -DENABLE_IPV6 -g -O2 -MT xtables_multi-xtables-multi.o -MD -MP -MF .deps=
/xtables_multi-xtables-multi.Tpo -c -o xtables_multi-xtables-multi.o `tes=
t -f 'xtables-multi.c' || echo './'`xtables-multi.c
mv -f .deps/xtables_multi-xtables-multi.Tpo .deps/xtables_multi-xtables-m=
ulti.Po
gcc -DHAVE_CONFIG_H -I. -I..  -D_LARGEFILE_SOURCE=3D1 -D_LARGE_FILES -D_F=
ILE_OFFSET_BITS=3D64 -D_REENTRANT  -DXTABLES_LIBDIR=3D\"/opt/iptables-dev=
/lib/xtables\" -DXTABLES_INTERNAL -I../include -I../include   -Wall -Wagg=
regate-return -Wmissing-declarations         -Wmissing-prototypes -Wredun=
dant-decls -Wshadow -Wstrict-prototypes     -Winline -pipe  -DENABLE_IPV4=
 -DENABLE_IPV6 -g -O2 -MT xtables_multi-iptables-xml.o -MD -MP -MF .deps/=
xtables_multi-iptables-xml.Tpo -c -o xtables_multi-iptables-xml.o `test -=
f 'iptables-xml.c' || echo './'`iptables-xml.c
mv -f .deps/xtables_multi-iptables-xml.Tpo .deps/xtables_multi-iptables-x=
ml.Po
gcc -DHAVE_CONFIG_H -I. -I..  -D_LARGEFILE_SOURCE=3D1 -D_LARGE_FILES -D_F=
ILE_OFFSET_BITS=3D64 -D_REENTRANT  -DXTABLES_LIBDIR=3D\"/opt/iptables-dev=
/lib/xtables\" -DXTABLES_INTERNAL -I../include -I../include   -Wall -Wagg=
regate-return -Wmissing-declarations         -Wmissing-prototypes -Wredun=
dant-decls -Wshadow -Wstrict-prototypes     -Winline -pipe  -DENABLE_IPV4=
 -DENABLE_IPV6 -g -O2 -MT xtables_multi-iptables-save.o -MD -MP -MF .deps=
/xtables_multi-iptables-save.Tpo -c -o xtables_multi-iptables-save.o `tes=
t -f 'iptables-save.c' || echo './'`iptables-save.c
mv -f .deps/xtables_multi-iptables-save.Tpo .deps/xtables_multi-iptables-=
save.Po
gcc -DHAVE_CONFIG_H -I. -I..  -D_LARGEFILE_SOURCE=3D1 -D_LARGE_FILES -D_F=
ILE_OFFSET_BITS=3D64 -D_REENTRANT  -DXTABLES_LIBDIR=3D\"/opt/iptables-dev=
/lib/xtables\" -DXTABLES_INTERNAL -I../include -I../include   -Wall -Wagg=
regate-return -Wmissing-declarations         -Wmissing-prototypes -Wredun=
dant-decls -Wshadow -Wstrict-prototypes     -Winline -pipe  -DENABLE_IPV4=
 -DENABLE_IPV6 -g -O2 -MT xtables_multi-iptables-restore.o -MD -MP -MF .d=
eps/xtables_multi-iptables-restore.Tpo -c -o xtables_multi-iptables-resto=
re.o `test -f 'iptables-restore.c' || echo './'`iptables-restore.c
mv -f .deps/xtables_multi-iptables-restore.Tpo .deps/xtables_multi-iptabl=
es-restore.Po
gcc -DHAVE_CONFIG_H -I. -I..  -D_LARGEFILE_SOURCE=3D1 -D_LARGE_FILES -D_F=
ILE_OFFSET_BITS=3D64 -D_REENTRANT  -DXTABLES_LIBDIR=3D\"/opt/iptables-dev=
/lib/xtables\" -DXTABLES_INTERNAL -I../include -I../include   -Wall -Wagg=
regate-return -Wmissing-declarations         -Wmissing-prototypes -Wredun=
dant-decls -Wshadow -Wstrict-prototypes     -Winline -pipe  -DENABLE_IPV4=
 -DENABLE_IPV6 -g -O2 -MT xtables_multi-iptables-standalone.o -MD -MP -MF=
 .deps/xtables_multi-iptables-standalone.Tpo -c -o xtables_multi-iptables=
-standalone.o `test -f 'iptables-standalone.c' || echo './'`iptables-stan=
dalone.c
mv -f .deps/xtables_multi-iptables-standalone.Tpo .deps/xtables_multi-ipt=
ables-standalone.Po
gcc -DHAVE_CONFIG_H -I. -I..  -D_LARGEFILE_SOURCE=3D1 -D_LARGE_FILES -D_F=
ILE_OFFSET_BITS=3D64 -D_REENTRANT  -DXTABLES_LIBDIR=3D\"/opt/iptables-dev=
/lib/xtables\" -DXTABLES_INTERNAL -I../include -I../include   -Wall -Wagg=
regate-return -Wmissing-declarations         -Wmissing-prototypes -Wredun=
dant-decls -Wshadow -Wstrict-prototypes     -Winline -pipe  -DENABLE_IPV4=
 -DENABLE_IPV6 -g -O2 -MT xtables_multi-iptables.o -MD -MP -MF .deps/xtab=
les_multi-iptables.Tpo -c -o xtables_multi-iptables.o `test -f 'iptables.=
c' || echo './'`iptables.c
mv -f .deps/xtables_multi-iptables.Tpo .deps/xtables_multi-iptables.Po
gcc -DHAVE_CONFIG_H -I. -I..  -D_LARGEFILE_SOURCE=3D1 -D_LARGE_FILES -D_F=
ILE_OFFSET_BITS=3D64 -D_REENTRANT  -DXTABLES_LIBDIR=3D\"/opt/iptables-dev=
/lib/xtables\" -DXTABLES_INTERNAL -I../include -I../include   -Wall -Wagg=
regate-return -Wmissing-declarations         -Wmissing-prototypes -Wredun=
dant-decls -Wshadow -Wstrict-prototypes     -Winline -pipe  -DENABLE_IPV4=
 -DENABLE_IPV6 -g -O2 -MT xtables_multi-ip6tables-save.o -MD -MP -MF .dep=
s/xtables_multi-ip6tables-save.Tpo -c -o xtables_multi-ip6tables-save.o `=
test -f 'ip6tables-save.c' || echo './'`ip6tables-save.c
mv -f .deps/xtables_multi-ip6tables-save.Tpo .deps/xtables_multi-ip6table=
s-save.Po
gcc -DHAVE_CONFIG_H -I. -I..  -D_LARGEFILE_SOURCE=3D1 -D_LARGE_FILES -D_F=
ILE_OFFSET_BITS=3D64 -D_REENTRANT  -DXTABLES_LIBDIR=3D\"/opt/iptables-dev=
/lib/xtables\" -DXTABLES_INTERNAL -I../include -I../include   -Wall -Wagg=
regate-return -Wmissing-declarations         -Wmissing-prototypes -Wredun=
dant-decls -Wshadow -Wstrict-prototypes     -Winline -pipe  -DENABLE_IPV4=
 -DENABLE_IPV6 -g -O2 -MT xtables_multi-ip6tables-restore.o -MD -MP -MF .=
deps/xtables_multi-ip6tables-restore.Tpo -c -o xtables_multi-ip6tables-re=
store.o `test -f 'ip6tables-restore.c' || echo './'`ip6tables-restore.c
mv -f .deps/xtables_multi-ip6tables-restore.Tpo .deps/xtables_multi-ip6ta=
bles-restore.Po
gcc -DHAVE_CONFIG_H -I. -I..  -D_LARGEFILE_SOURCE=3D1 -D_LARGE_FILES -D_F=
ILE_OFFSET_BITS=3D64 -D_REENTRANT  -DXTABLES_LIBDIR=3D\"/opt/iptables-dev=
/lib/xtables\" -DXTABLES_INTERNAL -I../include -I../include   -Wall -Wagg=
regate-return -Wmissing-declarations         -Wmissing-prototypes -Wredun=
dant-decls -Wshadow -Wstrict-prototypes     -Winline -pipe  -DENABLE_IPV4=
 -DENABLE_IPV6 -g -O2 -MT xtables_multi-ip6tables-standalone.o -MD -MP -M=
F .deps/xtables_multi-ip6tables-standalone.Tpo -c -o xtables_multi-ip6tab=
les-standalone.o `test -f 'ip6tables-standalone.c' || echo './'`ip6tables=
-standalone.c
mv -f .deps/xtables_multi-ip6tables-standalone.Tpo .deps/xtables_multi-ip=
6tables-standalone.Po
gcc -DHAVE_CONFIG_H -I. -I..  -D_LARGEFILE_SOURCE=3D1 -D_LARGE_FILES -D_F=
ILE_OFFSET_BITS=3D64 -D_REENTRANT  -DXTABLES_LIBDIR=3D\"/opt/iptables-dev=
/lib/xtables\" -DXTABLES_INTERNAL -I../include -I../include   -Wall -Wagg=
regate-return -Wmissing-declarations         -Wmissing-prototypes -Wredun=
dant-decls -Wshadow -Wstrict-prototypes     -Winline -pipe  -DENABLE_IPV4=
 -DENABLE_IPV6 -g -O2 -MT xtables_multi-ip6tables.o -MD -MP -MF .deps/xta=
bles_multi-ip6tables.Tpo -c -o xtables_multi-ip6tables.o `test -f 'ip6tab=
les.c' || echo './'`ip6tables.c
mv -f .deps/xtables_multi-ip6tables.Tpo .deps/xtables_multi-ip6tables.Po
gcc -DHAVE_CONFIG_H -I. -I..  -D_LARGEFILE_SOURCE=3D1 -D_LARGE_FILES -D_F=
ILE_OFFSET_BITS=3D64 -D_REENTRANT  -DXTABLES_LIBDIR=3D\"/opt/iptables-dev=
/lib/xtables\" -DXTABLES_INTERNAL -I../include -I../include   -Wall -Wagg=
regate-return -Wmissing-declarations         -Wmissing-prototypes -Wredun=
dant-decls -Wshadow -Wstrict-prototypes     -Winline -pipe  -DENABLE_IPV4=
 -DENABLE_IPV6 -g -O2 -MT xtables_multi-xshared.o -MD -MP -MF .deps/xtabl=
es_multi-xshared.Tpo -c -o xtables_multi-xshared.o `test -f 'xshared.c' |=
| echo './'`xshared.c
mv -f .deps/xtables_multi-xshared.Tpo .deps/xtables_multi-xshared.Po
make[2]: *** No rule to make target `../extensions/libext.a', needed by `=
xtables-multi'.  Stop.
make[2]: Leaving directory `/home/rw/src/iptables/iptables'
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory `/home/rw/src/iptables'
make: *** [all] Error 2


--------------050405020403060504050005--

--------------enigEDF5526BFA869E4D5CFD7988
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iQEcBAEBAgAGBQJOdeIiAAoJEN9758yqZn9exZAH/1dAtQu7V5Pc4VYzvw8qa85Q
DNV/I9OTJ8JFJRiznWSlp9bgp186JOk05GDWNRWUsZFB0yvWIwkSp8CKKsbUbZTT
Ye5NswFuicvxsFcmQxvXKo+s+xhpx5XzH27hkD7gZbviAEXZsGjrY09giPvW4QbM
MAMRzYWNw3DlY8dOkww+yJL3ISseROwoOiGb83mB/WEqYYuHGQl6WoK91OqikyOv
z3vMaz0veGyxYorbpZZlEJjuDNLwD0KXSVGR8vPP8JYN78bll4kASAoBGk4GPj2K
MtgJvpaal4x4Wn4i8GA0WB4F6QxQ4WxPyxda8xQkv0/h+BHHlA5vpfkmw44+rvo=
=9SKi
-----END PGP SIGNATURE-----

--------------enigEDF5526BFA869E4D5CFD7988--
