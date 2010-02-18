From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: xtables-addons suggestions
Date: Thu, 18 Feb 2010 09:01:10 +0200
Message-ID: <20100218090110.74f6ce3e@outerspace>
References: <20100216215128.1c154cdb@outerspace>
	<alpine.LSU.2.01.1002162057390.20293@obet.zrqbmnf.qr>
	<alpine.LSU.2.01.1002162230430.29148@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/i+vvkWc7rYlKCGrrWxU9Nbl";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slashbox.net ([82.118.210.13]:40058 "EHLO slashbox.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab0BRHBU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Feb 2010 02:01:20 -0500
In-Reply-To: <alpine.LSU.2.01.1002162230430.29148@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Sig_/i+vvkWc7rYlKCGrrWxU9Nbl
Content-Type: multipart/mixed; boundary="MP_/e96kFcBYoQz8/R1aB6xkinl"

--MP_/e96kFcBYoQz8/R1aB6xkinl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tue, 16 Feb 2010 22:32:33 +0100 (CET)
Jan Engelhardt <jengelh@medozas.de> wrote:

>=20
> On Tuesday 2010-02-16 21:23, Jan Engelhardt wrote:
> >On Tuesday 2010-02-16 20:51, Jonas Berlin wrote:
> >>
> >>Hi, I am using xtables-addons-1.22 and needed to do some changes to get
> >>it to compile in my setup. I thus present a few suggestions below:
> >>
> >>1. When using --with-xtables, I got problems at linking time, failing
> >>to find libxtables.. By changing configure.ac like below I was able to
> >>solve the issue.
>=20
> Well after all, libxtables_LIBS is currently never used.
> (Extension modules don't link to it.)
> So I cannot imagine linking problems, but that's the point
> where you have to provide logs.

Please find compilation output attached, the essential part being:

make -f ../Makefile.iptrules all;
make[3]: Entering directory `/discs/11/backup/home/xkr47/kernel/router/linu=
x-2.6.30-2/xtables-addons/src/extensions'
  CC     libxt_CHAOS.oo
  CCLD   libxt_CHAOS.so
/usr/lib/gcc/x86_64-pc-linux-gnu/4.1.2/../../../../x86_64-pc-linux-gnu/bin/=
ld: cannot find -lxtables
collect2: ld returned 1 exit status
make[3]: *** [libxt_CHAOS.so] Error 1

Seems to be this rule from Makefile.iptrules.in that is used:

lib%.so: lib%.oo
        ${AM_V_CCLD}${CCLD} ${AM_LDFLAGS} -shared ${LDFLAGS} -o $@ $< ${lib=
xtables_LIBS} ${LDLIBS};

--=20
- xkr47

--MP_/e96kFcBYoQz8/R1aB6xkinl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=xtables-addons-compile-error.txt

$ ./configure --prefix=3D/lib/modules/2.6.30-2/iptables --with-xtables=3D/h=
ome/xkr47/kernel/router/linux-2.6.30-2/lib/modules/2.6.30-2/iptables --with=
-gnu-ld --with-kbuild=3D/home/xkr47/kernel/router/linux-2.6.30-2/linux/src =
--enable-dependency-tracking
checking for a BSD-compatible install... /usr/bin/install -c
checking whether build environment is sane... yes
checking for a thread-safe mkdir -p... /bin/mkdir -p
checking for gawk... gawk
checking whether make sets $(MAKE)... yes
checking for gcc... gcc
checking for C compiler default output file name... a.out
checking whether the C compiler works... yes
checking whether we are cross compiling... no
checking for suffix of executables...=20
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ISO C89... none needed
checking for style of include used by make... GNU
checking dependency style of gcc... gcc3
checking whether gcc and cc understand -c and -o together... yes
checking build system type... x86_64-unknown-linux-gnu
checking host system type... x86_64-unknown-linux-gnu
checking for a sed that does not truncate output... /usr/bin/sed
checking for grep that handles long lines and -e... /bin/grep
checking for egrep... /bin/grep -E
checking for fgrep... /bin/grep -F
checking for ld used by gcc... /usr/x86_64-pc-linux-gnu/bin/ld
checking if the linker (/usr/x86_64-pc-linux-gnu/bin/ld) is GNU ld... yes
checking for BSD- or MS-compatible name lister (nm)... /usr/bin/nm -B
checking the name lister (/usr/bin/nm -B) interface... BSD nm
checking whether ln -s works... yes
checking the maximum length of command line arguments... 1572864
checking whether the shell understands some XSI constructs... yes
checking whether the shell understands "+=3D"... yes
checking for /usr/x86_64-pc-linux-gnu/bin/ld option to reload object files.=
.. -r
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
checking whether the gcc linker (/usr/x86_64-pc-linux-gnu/bin/ld -m elf_x86=
_64) supports shared libraries... yes
checking whether -lc should be explicitly linked in... no
checking dynamic linker characteristics... GNU/Linux ld.so
checking how to hardcode library paths into programs... immediate
checking whether stripping libraries is possible... yes
checking if libtool supports shared libraries... yes
checking whether to build shared libraries... yes
checking whether to build static libraries... no
checking xtables.h presence... /home/xkr47/kernel/router/linux-2.6.30-2/lib=
/modules/2.6.30-2/iptables/include/xtables.h
no
checking linux/netfilter/x_tables.h usability... yes
checking linux/netfilter/x_tables.h presence... yes
checking for linux/netfilter/x_tables.h... yes
Found kernel version 2.6.30.0 in /home/xkr47/kernel/router/linux-2.6.30-2/l=
inux/src
configure: creating ./config.status
config.status: creating Makefile
config.status: creating Makefile.iptrules
config.status: creating Makefile.mans
config.status: creating extensions/Makefile
config.status: creating extensions/ACCOUNT/Makefile
config.status: creating extensions/ipset/Makefile
config.status: creating extensions/pknock/Makefile
config.status: creating config.h
config.status: executing depfiles commands
config.status: executing libtool commands
$ make
make  all-recursive
make[1]: Entering directory `/discs/11/backup/home/xkr47/kernel/router/linu=
x-2.6.30-2/xtables-addons/src'
Making all in extensions
make[2]: Entering directory `/discs/11/backup/home/xkr47/kernel/router/linu=
x-2.6.30-2/xtables-addons/src/extensions'
if [ -n "/home/xkr47/kernel/router/linux-2.6.30-2/linux/src" ]; then make -=
C /home/xkr47/kernel/router/linux-2.6.30-2/linux/src M=3D/home/xkr47/kernel=
/router/linux-2.6.30-2/xtables-addons/src/extensions modules; fi;
make[3]: Entering directory `/discs/11/backup/home/xkr47/kernel/router/linu=
x-2.6.30-2/linux/src'
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/compat_xtables.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_CHAOS.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_DELUDE.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_DHCPMAC.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_IPMARK.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_LOGMARK.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_RAWNAT.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/iptable_rawpost.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ip6table_rawpost.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_SYSRQ.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_STEAL.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_TARPIT.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_TEE.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_condition.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_fuzzy.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_geoip.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_iface.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_ipp2p.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_ipv4options.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_length2.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_lscan.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_psd.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_quota2.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ACCOUNT/xt_ACCOUNT.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ipt_set.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ipt_SET.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ip_set.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ip_set_ipmap.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ip_set_portmap.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ip_set_macipmap.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ip_set_iphash.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ip_set_nethash.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ip_set_ipporthash.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ip_set_iptree.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ip_set_iptreemap.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ip_set_setlist.o
  CC [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/pknock/xt_pknock.o
  Building modules, stage 2.
  MODPOST 37 modules
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ACCOUNT/xt_ACCOUNT.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ACCOUNT/xt_ACCOUNT.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/compat_xtables.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/compat_xtables.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ip6table_rawpost.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ip6table_rawpost.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ip_set.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ip_set.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ip_set_iphash.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ip_set_iphash.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ip_set_ipmap.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ip_set_ipmap.ko
LIBS =3D=20
LIBTOOL =3D $(SHELL) $(top_builddir)/libtool
LIPO =3D=20
LN_S =3D ln -s
LTLIBOBJS =3D=20
MAKEINFO =3D ${SHELL} /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addo=
ns/src/missing --run makeinfo
MKDIR_P =3D /bin/mkdir -p
NM =3D /usr/bin/nm -B
NMEDIT =3D=20
OBJDUMP =3D objdump
OBJEXT =3D o
OTOOL =3D=20
OTOOL64 =3D=20
PACKAGE =3D xtables-addons
PACKAGE_BUGREPORT =3D=20
PACKAGE_NAME =3D xtables-addons
PACKAGE_STRING =3D xtables-addons 1.22
PACKAGE_TARNAME =3D xtables-addons
PACKAGE_VERSION =3D 1.22
PATH_SEPARATOR =3D :
PKG_CONFIG =3D=20
RANLIB =3D ranlib
SED =3D /usr/bin/sed
SET_MAKE =3D=20
SHELL =3D /bin/sh
STRIP =3D strip
VERSION =3D 1.22
abs_builddir =3D /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/sr=
c/extensions
abs_srcdir =3D /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/=
extensions
abs_top_builddir =3D /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addon=
s/src
abs_top_srcdir =3D /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/=
src
ac_ct_CC =3D gcc
ac_ct_DUMPBIN =3D=20
am__include =3D include
am__leading_dot =3D .
am__quote =3D=20
am__tar =3D ${AMTAR} chof - "$$tardir"
am__untar =3D ${AMTAR} xf -
bindir =3D ${exec_prefix}/bin
build =3D x86_64-unknown-linux-gnu
build_alias =3D=20
build_cpu =3D x86_64
build_os =3D linux-gnu
build_vendor =3D unknown
builddir =3D .
datadir =3D ${datarootdir}
datarootdir =3D ${prefix}/share
docdir =3D ${datarootdir}/doc/${PACKAGE_TARNAME}
dvidir =3D ${docdir}
exec_prefix =3D ${prefix}
host =3D x86_64-unknown-linux-gnu
host_alias =3D=20
host_cpu =3D x86_64
host_os =3D linux-gnu
host_vendor =3D unknown
htmldir =3D ${docdir}
includedir =3D ${prefix}/include
infodir =3D ${datarootdir}/info
install_sh =3D ${SHELL} /home/xkr47/kernel/router/linux-2.6.30-2/xtables-ad=
dons/src/install-sh
kbuilddir =3D /home/xkr47/kernel/router/linux-2.6.30-2/linux/src
kinclude_CFLAGS =3D  -I /home/xkr47/kernel/router/linux-2.6.30-2/linux/src/=
include
ksourcedir =3D=20
libdir =3D ${exec_prefix}/lib
libexecdir =3D ${exec_prefix}/libexec
libxtables_CFLAGS =3D -I /home/xkr47/kernel/router/linux-2.6.30-2/lib/modul=
es/2.6.30-2/iptables/include
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ip_set_ipporthash.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ip_set_ipporthash.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ip_set_iptree.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ip_set_iptree.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ip_set_iptreemap.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ip_set_iptreemap.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ip_set_macipmap.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ip_set_macipmap.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ip_set_nethash.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ip_set_nethash.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ip_set_portmap.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ip_set_portmap.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ip_set_setlist.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ip_set_setlist.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ipt_SET.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ipt_SET.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ipt_set.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/ipset/ipt_set.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/iptable_rawpost.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/iptable_rawpost.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/pknock/xt_pknock.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/pknock/xt_pknock.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_CHAOS.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_CHAOS.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_DELUDE.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_DELUDE.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_DHCPMAC.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_DHCPMAC.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_IPMARK.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_IPMARK.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_LOGMARK.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_LOGMARK.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_RAWNAT.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_RAWNAT.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_STEAL.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_STEAL.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_SYSRQ.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_SYSRQ.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_TARPIT.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_TARPIT.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_TEE.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_TEE.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_condition.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_condition.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_fuzzy.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_fuzzy.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_geoip.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_geoip.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_iface.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_iface.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_ipp2p.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_ipp2p.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_ipv4options.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_ipv4options.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_length2.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_length2.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_lscan.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_lscan.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_psd.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_psd.ko
  CC      /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_quota2.mod.o
  LD [M]  /home/xkr47/kernel/router/linux-2.6.30-2/xtables-addons/src/exten=
sions/xt_quota2.ko
make[3]: Leaving directory `/discs/11/backup/home/xkr47/kernel/router/linux=
-2.6.30-2/linux/src'
make -f ../Makefile.iptrules all;
make[3]: Entering directory `/discs/11/backup/home/xkr47/kernel/router/linu=
x-2.6.30-2/xtables-addons/src/extensions'
  CC     libxt_CHAOS.oo
  CCLD   libxt_CHAOS.so
/usr/lib/gcc/x86_64-pc-linux-gnu/4.1.2/../../../../x86_64-pc-linux-gnu/bin/=
ld: cannot find -lxtables
collect2: ld returned 1 exit status
make[3]: *** [libxt_CHAOS.so] Error 1
make[3]: Leaving directory `/discs/11/backup/home/xkr47/kernel/router/linux=
-2.6.30-2/xtables-addons/src/extensions'
make[2]: *** [user-all-local] Error 2
make[2]: Leaving directory `/discs/11/backup/home/xkr47/kernel/router/linux=
-2.6.30-2/xtables-addons/src/extensions'
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory `/discs/11/backup/home/xkr47/kernel/router/linux=
-2.6.30-2/xtables-addons/src'
make: *** [all] Error 2

--MP_/e96kFcBYoQz8/R1aB6xkinl--

--Sig_/i+vvkWc7rYlKCGrrWxU9Nbl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAkt85boACgkQxyF48ZTvn+6icwCfWEA7WBL0QnMaR4dsDCxKbvwq
XHUAoKyhGcuPHoE+RbETCmSXdomuX6WA
=0/T1
-----END PGP SIGNATURE-----

--Sig_/i+vvkWc7rYlKCGrrWxU9Nbl--
