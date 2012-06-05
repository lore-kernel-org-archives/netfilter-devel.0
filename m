From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 3/3] pcap: resolve unreliable detection
Date: Tue,  5 Jun 2012 10:41:03 +0200
Message-ID: <1338885663-30131-4-git-send-email-jengelh@inai.de>
References: <1338885663-30131-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:54614 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757838Ab2FEIlI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jun 2012 04:41:08 -0400
In-Reply-To: <1338885663-30131-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

pcap is not found reliably by either --with-pcap=%_prefix or
--with-pcap-lib=%_libdir --with-pcap-inc=%_includedir.

If you have any special paths, just use
	./configure CPPFLAGS="-I/my/pcap" LDFLAGS="-L/my/pcap"

(And -lpcap is already known so no need to specify that.)

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 configure.ac            |    7 +++----
 output/pcap/Makefile.am |    4 ++--
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/configure.ac b/configure.ac
index 89fc338..8f1e15b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -19,7 +19,9 @@ AC_PROG_LIBTOOL
 dnl Checks for libraries.
 AC_SEARCH_LIBS([dlopen], [dl], [libdl_LIBS="$LIBS"; LIBS=""])
 AC_SUBST([libdl_LIBS])
-AC_CHECK_HEADER(pcap.h,HAVE_PCAP_H=true)
+AC_SEARCH_LIBS([pcap_close], [pcap], [libpcap_LIBS="-lpcap"; LIBS=""])
+AC_SUBST([libpcap_LIBS])
+AM_CONDITIONAL([HAVE_PCAP], test -n "$libpcap_LIBS"])
 
 dnl Checks for header files.
 AC_HEADER_DIRENT
@@ -58,8 +60,6 @@ AM_CONDITIONAL([HAVE_SQLITE3], [test -n "$libsqlite3_LIBS"])
 CT_CHECK_DBI()
 AM_CONDITIONAL(HAVE_DBI, test "x$DBI_LIB" != "x")
 
-CT_CHECK_PCAP()
-AM_CONDITIONAL(HAVE_PCAP, test "x$HAVE_PCAP_LIB" != "x")
 
 
 dnl AC_SUBST(DATABASE_DIR)
@@ -70,7 +70,6 @@ dnl AC_SUBST(EXTRA_MYSQL_DEF)
 dnl AC_SUBST(EXTRA_PGSQL_DEF)
 
 dnl AC_SUBST(DATABASE_DRIVERS)
-dnl AC_SUBST(HAVE_PCAP_H)
 
 dnl AM_CONDITIONAL(HAVE_MYSQL, test x$mysqldir != x)
 dnl AM_CONDITIONAL(HAVE_PGSQL, test x$pgsqldir != x)
diff --git a/output/pcap/Makefile.am b/output/pcap/Makefile.am
index 47580d2..c1723a6 100644
--- a/output/pcap/Makefile.am
+++ b/output/pcap/Makefile.am
@@ -1,5 +1,5 @@
 
-AM_CPPFLAGS = -I$(top_srcdir)/include $(PCAP_INC)
+AM_CPPFLAGS = -I$(top_srcdir)/include
 AM_CFLAGS = ${regular_CFLAGS}
 
 if HAVE_PCAP
@@ -7,7 +7,7 @@ if HAVE_PCAP
 pkglib_LTLIBRARIES = ulogd_output_PCAP.la
 
 ulogd_output_PCAP_la_SOURCES = ulogd_output_PCAP.c
-ulogd_output_PCAP_la_LIBADD  = ${PCAP_LIB}
+ulogd_output_PCAP_la_LIBADD  = ${libpcap_LIBS}
 ulogd_output_PCAP_la_LDFLAGS = -avoid-version -module
 
 endif
-- 
1.7.7

