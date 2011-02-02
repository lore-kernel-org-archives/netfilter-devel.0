From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/3] build: avoid use of LIBS variable
Date: Wed,  2 Feb 2011 22:51:05 +0100
Message-ID: <1296683468-30413-2-git-send-email-jengelh@medozas.de>
References: <1296683468-30413-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36969 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab1BBVvL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:51:11 -0500
In-Reply-To: <1296683468-30413-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The variable contains global libraries linked into every possible
object, which is unwanted. Clean up things.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac               |    3 ++-
 input/packet/Makefile.am   |    1 -
 output/Makefile.am         |    1 -
 output/dbi/Makefile.am     |    2 +-
 output/mysql/Makefile.am   |    2 +-
 output/pcap/Makefile.am    |    2 +-
 output/pgsql/Makefile.am   |    2 +-
 output/sqlite3/Makefile.am |    2 +-
 src/Makefile.am            |    1 +
 9 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/configure.ac b/configure.ac
index 75372fc..1b799fe 100644
--- a/configure.ac
+++ b/configure.ac
@@ -14,7 +14,8 @@ AC_DISABLE_STATIC
 AC_PROG_LIBTOOL
 
 dnl Checks for libraries.
-AC_CHECK_LIB(dl, dlopen)
+AC_SEARCH_LIBS([dlopen], [dl], [libdl_LIBS="$LIBS"; LIBS=""])
+AC_SUBST([libdl_LIBS])
 AC_CHECK_HEADER(pcap.h,HAVE_PCAP_H=true)
 
 dnl Checks for header files.
diff --git a/input/packet/Makefile.am b/input/packet/Makefile.am
index 7fd8979..2e972f8 100644
--- a/input/packet/Makefile.am
+++ b/input/packet/Makefile.am
@@ -1,7 +1,6 @@
 
 AM_CPPFLAGS = -I$(top_srcdir)/include
 AM_CFLAGS = ${regular_CFLAGS}
-LIBS=
 
 pkglib_LTLIBRARIES = ulogd_inppkt_NFLOG.la ulogd_inppkt_ULOG.la ulogd_inppkt_UNIXSOCK.la
 
diff --git a/output/Makefile.am b/output/Makefile.am
index 34ffb2d..9d9ac73 100644
--- a/output/Makefile.am
+++ b/output/Makefile.am
@@ -1,6 +1,5 @@
 AM_CPPFLAGS = -I$(top_srcdir)/include
 AM_CFLAGS = ${regular_CFLAGS}
-LIBS=""
 
 SUBDIRS= pcap mysql pgsql sqlite3 dbi
 
diff --git a/output/dbi/Makefile.am b/output/dbi/Makefile.am
index 1ee8f2a..f413cab 100644
--- a/output/dbi/Makefile.am
+++ b/output/dbi/Makefile.am
@@ -1,13 +1,13 @@
 
 AM_CPPFLAGS = -I$(top_srcdir)/include $(DBI_INC)
 AM_CFLAGS = ${regular_CFLAGS}
-LIBS=$(DBI_LIB)
 
 if HAVE_DBI
 
 pkglib_LTLIBRARIES = ulogd_output_DBI.la
 
 ulogd_output_DBI_la_SOURCES = ulogd_output_DBI.c ../../util/db.c
+ulogd_output_DBI_la_LIBADD  = ${DBI_LIB}
 ulogd_output_DBI_la_LDFLAGS = -avoid-version -module
 
 endif
diff --git a/output/mysql/Makefile.am b/output/mysql/Makefile.am
index a98cdeb..c24208c 100644
--- a/output/mysql/Makefile.am
+++ b/output/mysql/Makefile.am
@@ -1,12 +1,12 @@
 AM_CPPFLAGS = -I$(top_srcdir)/include $(MYSQL_INC)
 AM_CFLAGS = ${regular_CFLAGS}
-LIBS=$(MYSQL_LIB)
 
 if HAVE_MYSQL
 
 pkglib_LTLIBRARIES = ulogd_output_MYSQL.la
 
 ulogd_output_MYSQL_la_SOURCES = ulogd_output_MYSQL.c ../../util/db.c
+ulogd_output_MYSQL_la_LIBADD  = ${MYSQL_LIB}
 ulogd_output_MYSQL_la_LDFLAGS = -avoid-version -module
 
 endif
diff --git a/output/pcap/Makefile.am b/output/pcap/Makefile.am
index 59cb3f6..47580d2 100644
--- a/output/pcap/Makefile.am
+++ b/output/pcap/Makefile.am
@@ -1,13 +1,13 @@
 
 AM_CPPFLAGS = -I$(top_srcdir)/include $(PCAP_INC)
 AM_CFLAGS = ${regular_CFLAGS}
-LIBS=$(PCAP_LIB)
 
 if HAVE_PCAP
 
 pkglib_LTLIBRARIES = ulogd_output_PCAP.la
 
 ulogd_output_PCAP_la_SOURCES = ulogd_output_PCAP.c
+ulogd_output_PCAP_la_LIBADD  = ${PCAP_LIB}
 ulogd_output_PCAP_la_LDFLAGS = -avoid-version -module
 
 endif
diff --git a/output/pgsql/Makefile.am b/output/pgsql/Makefile.am
index 32be79b..bdaf1d2 100644
--- a/output/pgsql/Makefile.am
+++ b/output/pgsql/Makefile.am
@@ -1,13 +1,13 @@
 
 AM_CPPFLAGS = -I$(top_srcdir)/include -I$(PQINCPATH)
 AM_CFLAGS = ${regular_CFLAGS}
-LIBS=$(PQLIBS)
 
 if HAVE_PGSQL
 
 pkglib_LTLIBRARIES = ulogd_output_PGSQL.la
 
 ulogd_output_PGSQL_la_SOURCES = ulogd_output_PGSQL.c ../../util/db.c
+ulogd_output_PGSQL_la_LIBADD  = ${PQLIBS}
 ulogd_output_PGSQL_la_LDFLAGS = -avoid-version -module
 
 endif
diff --git a/output/sqlite3/Makefile.am b/output/sqlite3/Makefile.am
index d14398c..3bfec2e 100644
--- a/output/sqlite3/Makefile.am
+++ b/output/sqlite3/Makefile.am
@@ -1,12 +1,12 @@
 AM_CPPFLAGS = -I$(top_srcdir)/include $(SQLITE3_INC)
 AM_CFLAGS = ${regular_CFLAGS}
-LIBS=$(SQLITE3_LIB)
 
 if HAVE_SQLITE3
 
 pkglib_LTLIBRARIES = ulogd_output_SQLITE3.la
 
 ulogd_output_SQLITE3_la_SOURCES = ulogd_output_SQLITE3.c ../../util/db.c
+ulogd_output_SQLITE3_la_LIBADD  = ${SQLITE3_LIBS}
 ulogd_output_SQLITE3_la_LDFLAGS = -avoid-version -module
 
 endif
diff --git a/src/Makefile.am b/src/Makefile.am
index 9ae7884..115ddd5 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -7,4 +7,5 @@ AM_CFLAGS = ${regular_CFLAGS}
 sbin_PROGRAMS = ulogd
 
 ulogd_SOURCES = ulogd.c select.c timer.c rbtree.c conffile.c hash.c
+ulogd_LDADD   = ${libdl_LIBS}
 ulogd_LDFLAGS = -export-dynamic
-- 
1.7.1

