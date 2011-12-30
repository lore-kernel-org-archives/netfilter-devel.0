From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/3] libiptc: remove libiptc.so
Date: Fri, 30 Dec 2011 02:46:32 +0100
Message-ID: <1325209595-23244-2-git-send-email-jengelh@medozas.de>
References: <1325209595-23244-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:58641 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754704Ab1L3Bqh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Dec 2011 20:46:37 -0500
In-Reply-To: <1325209595-23244-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When Linux distributions started to ship binutils-ld defaulting to
-Wl,--as-needed, we had to add a hack (-Wl,--no-as-needed) to the
iptables build such that libiptc.so continued to link to libip4tc.so
and libip6tc.so despite not requesting any symbols from there.

Given that distros start shipping binutils-ld defaulting to
-Wl,--no-copy-dt-needed-entries, 3rd-party programs linking
to -liptc will ignore libiptc.so's DT_NEEDED entries by default and
not search for symbols there. So libiptc.so has finally become
useless, so remove it. Dependent programs should have been using the
pkg-config infrastructure, where quering for "iptc" returned "-lip4tc
-lip6tc" for long enough.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac        |    5 -----
 libiptc/Makefile.am |    7 ++-----
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/configure.ac b/configure.ac
index 0f85b83..8eb7572 100644
--- a/configure.ac
+++ b/configure.ac
@@ -53,11 +53,6 @@ AC_ARG_WITH([pkgconfigdir], AS_HELP_STRING([--with-pkgconfigdir=PATH],
 	[Path to the pkgconfig directory [[LIBDIR/pkgconfig]]]),
 	[pkgconfigdir="$withval"], [pkgconfigdir='${libdir}/pkgconfig'])
 
-libiptc_LDFLAGS2="";
-AX_CHECK_LINKER_FLAGS([-Wl,--no-as-needed],
-	[libiptc_LDFLAGS2="-Wl,--no-as-needed"])
-AC_SUBST([libiptc_LDFLAGS2])
-
 AC_MSG_CHECKING([whether $LD knows -Wl,--no-undefined])
 saved_LDFLAGS="$LDFLAGS";
 LDFLAGS="-Wl,--no-undefined";
diff --git a/libiptc/Makefile.am b/libiptc/Makefile.am
index f789d34..3803fe7 100644
--- a/libiptc/Makefile.am
+++ b/libiptc/Makefile.am
@@ -5,11 +5,8 @@ AM_CPPFLAGS      = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_srcdir}
 
 pkgconfig_DATA      = libiptc.pc libip4tc.pc libip6tc.pc
 
-lib_LTLIBRARIES     = libip4tc.la libip6tc.la libiptc.la
-libiptc_la_SOURCES  =
-libiptc_la_LIBADD   = libip4tc.la libip6tc.la
-libiptc_la_LDFLAGS  = -version-info 0:0:0 ${libiptc_LDFLAGS2}
+lib_LTLIBRARIES     = libip4tc.la libip6tc.la
 libip4tc_la_SOURCES = libip4tc.c
 libip4tc_la_LDFLAGS = -version-info 1:0:1
 libip6tc_la_SOURCES = libip6tc.c
-libip6tc_la_LDFLAGS = -version-info 1:0:1 ${libiptc_LDFLAGS2}
+libip6tc_la_LDFLAGS = -version-info 1:0:1
-- 
1.7.3.4

