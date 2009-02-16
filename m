From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: Re: Netfilter API and libiptc
Date: Mon, 16 Feb 2009 14:47:02 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0902161425020.27721@ask.diku.dk>
References: <20090205141722.GB21417@qubit> <4990636B.9080900@trash.net>
 <20090209183941.GA1050@zenon.in.qult.net> <Pine.LNX.4.64.0902111408210.4822@ask.diku.dk>
 <4992E2B3.3030009@trash.net> <alpine.LSU.2.00.0902111656400.22845@fbirervta.pbzchgretzou.qr>
 <4993AFF9.9010002@trash.net> <alpine.LSU.2.00.0902120640480.32504@fbirervta.pbzchgretzou.qr>
 <4993BA81.8030404@trash.net> <Pine.LNX.4.64.0902161402280.27418@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Jan Engelhardt <jengelh@medozas.de>, Ignacy Gawedzki <i@lri.fr>,
	Netfilter Developers <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:49509 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754795AbZBPNrJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2009 08:47:09 -0500
In-Reply-To: <Pine.LNX.4.64.0902161402280.27418@ask.diku.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 16 Feb 2009, Jesper Dangaard Brouer wrote:

> Hi Patrick,
>
> Would you please consider the libiptc shared library patch for inclusion?
> I don't find the patch intrusive.  I have tested it and it works.
>
> See patch below...

Ups, that patch would not apply cleanly to the latest git (commit 
5dd19de34380).  Trivial diff conflict on Makefile.am (due to ae19604f 
"build: remove unneeded -ldl from iptables_xml_LDADD")

There is a clean version:

>From 4a1c3f3e56a2039b87636d3d2d8517933c47b517 Mon Sep 17 00:00:00 2001
From: Jan Engelhardt <jengelh@medozas.de>
Date: Wed, 11 Feb 2009 16:40:29 +0100
Subject: [PATCH 1/1] libiptc: make library available as a shared library

Tested-by: Jesper Dangaard Brouer <hawk@comx.dk>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
  .gitignore          |    1 +
  Makefile.am         |   18 ++++++++++--------
  configure.ac        |    2 +-
  include/Makefile.am |    4 ++++
  libiptc.pc.in       |   11 +++++++++++
  5 files changed, 27 insertions(+), 9 deletions(-)
  create mode 100644 libiptc.pc.in

diff --git a/.gitignore b/.gitignore
index 97c3004..e5d3099 100644
--- a/.gitignore
+++ b/.gitignore
@@ -35,6 +35,7 @@ Makefile.in
  /ltmain.sh
  /missing
  /stamp-h1
+/libiptc.pc
  /xtables.pc

  /ip6tables
diff --git a/Makefile.am b/Makefile.am
index a79ff67..41dc280 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -11,11 +11,14 @@ endif
  if ENABLE_LIBIPQ
  SUBDIRS         += libipq
  endif
+lib_LTLIBRARIES =

  # libiptc
-libiptc_libiptc_a_SOURCES = libiptc/libip4tc.c libiptc/libip6tc.c
+lib_LTLIBRARIES           += libiptc/libiptc.la
+libiptc_libiptc_la_SOURCES = libiptc/libip4tc.c libiptc/libip6tc.c
+libiptc_libiptc_la_LDFLAGS = -version-info 0:0:0

-lib_LTLIBRARIES       = libxtables.la
+lib_LTLIBRARIES      += libxtables.la
  libxtables_la_SOURCES = xtables.c
  libxtables_la_LDFLAGS = -version-info ${libxtables_vcurrent}:0:${libxtables_vage}
  libxtables_la_LIBADD  = -ldl
@@ -23,7 +26,7 @@ libxtables_la_LIBADD  = -ldl
  # iptables, dynamic
  iptables_SOURCES          = iptables-standalone.c iptables.c
  iptables_LDFLAGS          = -rdynamic
-iptables_LDADD            = -lm libiptc/libiptc.a extensions/libext4.a libxtables.la
+iptables_LDADD            = -lm libiptc/libiptc.la extensions/libext4.a libxtables.la

  iptables_xml_LDADD        = libxtables.la
  iptables_multi_SOURCES    = iptables-multi.c iptables-save.c \
@@ -44,14 +47,14 @@ iptables_save_LDADD       = ${iptables_LDADD}
  # iptables-multi, semi-static
  iptables_static_SOURCES   = ${iptables_multi_SOURCES} xtables.c
  iptables_static_CFLAGS    = ${iptables_multi_CFLAGS} -DNO_SHARED_LIBS=1
-iptables_static_LDADD     = -lm libiptc/libiptc.a extensions/libext4.a
+iptables_static_LDADD     = -lm libiptc/libiptc.la extensions/libext4.a

  iptables_xml_SOURCES      = iptables-xml.c

  # ip6tables, dynamic
  ip6tables_SOURCES         = ip6tables-standalone.c ip6tables.c
  ip6tables_LDFLAGS         = -rdynamic
-ip6tables_LDADD           = -lm libiptc/libiptc.a extensions/libext6.a libxtables.la
+ip6tables_LDADD           = -lm libiptc/libiptc.la extensions/libext6.a libxtables.la

  ip6tables_multi_SOURCES   = ip6tables-multi.c ip6tables-save.c \
                              ip6tables-restore.c ip6tables-standalone.c \
@@ -71,9 +74,8 @@ ip6tables_save_LDADD      = ${ip6tables_LDADD}
  # iptables-multi, semi-static
  ip6tables_static_SOURCES    = ${ip6tables_multi_SOURCES} xtables.c
  ip6tables_static_CFLAGS     = ${ip6tables_multi_CFLAGS} -DNO_SHARED_LIBS=1
-ip6tables_static_LDADD      = -lm libiptc/libiptc.a extensions/libext6.a
+ip6tables_static_LDADD      = -lm libiptc/libiptc.la extensions/libext6.a

-noinst_LIBRARIES = libiptc/libiptc.a
  bin_PROGRAMS     = iptables-xml
  sbin_PROGRAMS    =
  noinst_PROGRAMS  =
@@ -96,7 +98,7 @@ iptables.8: ${srcdir}/iptables.8.in extensions/matches4.man extensions/targets4.
  ip6tables.8: ${srcdir}/ip6tables.8.in extensions/matches6.man extensions/targets6.man
  	${AM_VERBOSE_GEN} sed -e 's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' -e '/@MATCH@/ r extensions/matches6.man' -e '/@TARGET@/ r extensions/targets6.man' $< >$@;

-pkgconfig_DATA = xtables.pc
+pkgconfig_DATA = libiptc.pc xtables.pc

  .PHONY: tarball
  tarball:
diff --git a/configure.ac b/configure.ac
index 3277666..55569bd 100644
--- a/configure.ac
+++ b/configure.ac
@@ -80,5 +80,5 @@ AC_SUBST([libxtables_vmajor])

  AC_CONFIG_FILES([Makefile extensions/GNUmakefile include/Makefile
  	libipq/Makefile
-	include/xtables.h include/iptables/internal.h xtables.pc])
+	include/xtables.h include/iptables/internal.h libiptc.pc xtables.pc])
  AC_OUTPUT
diff --git a/include/Makefile.am b/include/Makefile.am
index 6206bd2..0a1abea 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -6,3 +6,7 @@ nobase_include_HEADERS = xtables.h
  if ENABLE_LIBIPQ
  include_HEADERS += libipq/libipq.h
  endif
+
+nobase_include_HEADERS += \
+	libiptc/ipt_kernel_headers.h libiptc/libiptc.h \
+	libiptc/libip6tc.h libiptc/libxtc.h
diff --git a/libiptc.pc.in b/libiptc.pc.in
new file mode 100644
index 0000000..63a459a
--- /dev/null
+++ b/libiptc.pc.in
@@ -0,0 +1,11 @@
+
+prefix=@prefix@
+exec_prefix=@exec_prefix@
+libdir=@libdir@
+includedir=@includedir@
+
+Name:		libiptc
+Description:	iptables ruleset ADT and kernel interface
+Version:	@PACKAGE_VERSION@
+Libs:		-L${libdir} -liptc
+Cflags:		-I${includedir}
-- 
1.5.6.5

