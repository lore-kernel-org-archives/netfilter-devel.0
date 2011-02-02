From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/3] build: use appropriate location for program modules
Date: Wed,  2 Feb 2011 22:51:06 +0100
Message-ID: <1296683468-30413-3-git-send-email-jengelh@medozas.de>
References: <1296683468-30413-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36971 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754465Ab1BBVvM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:51:12 -0500
In-Reply-To: <1296683468-30413-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Modules - since they are dependent on the executable - generally go to
libexec/.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am                   |    2 +-
 configure.ac                  |    2 +-
 filter/Makefile.am            |    8 +++---
 filter/raw2packet/Makefile.am |    2 +-
 input/flow/Makefile.am        |    2 +-
 input/packet/Makefile.am      |    3 +-
 output/Makefile.am            |    6 ++--
 output/dbi/Makefile.am        |    2 +-
 output/mysql/Makefile.am      |    2 +-
 output/pcap/Makefile.am       |    2 +-
 output/pgsql/Makefile.am      |    2 +-
 output/sqlite3/Makefile.am    |    2 +-
 ulogd.conf.in                 |   42 ++++++++++++++++++++--------------------
 13 files changed, 39 insertions(+), 38 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index d4c180b..35e0338 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -11,7 +11,7 @@ SUBDIRS = include libipulog src input filter output
 noinst_DATA = ulogd.conf
 
 edit = sed \
-	-e 's,@libdir\@,$(libdir),g'
+	-e 's,@pkglibexecdir\@,${pkglibexecdir},g'
 
 ulogd.conf: Makefile $(srcdir)/ulogd.conf.in
 	$(edit) $(srcdir)/ulogd.conf.in >ulogd.conf
diff --git a/configure.ac b/configure.ac
index 1b799fe..8a92824 100644
--- a/configure.ac
+++ b/configure.ac
@@ -2,7 +2,7 @@ dnl Process this file with autoconf to produce a configure script.
 AC_PREREQ([2.50])
 AC_INIT([ulogd], [2.0.0beta4])
 
-AM_INIT_AUTOMAKE([-Wall foreign dist-bzip2 1.6])
+AM_INIT_AUTOMAKE([-Wall foreign dist-bzip2 1.10b])
 AC_CONFIG_HEADER([config.h])
 AC_CONFIG_MACRO_DIR([m4])
 
diff --git a/filter/Makefile.am b/filter/Makefile.am
index 3c3f152..83a0e52 100644
--- a/filter/Makefile.am
+++ b/filter/Makefile.am
@@ -3,10 +3,10 @@ SUBDIRS = raw2packet packet2flow
 AM_CPPFLAGS = -I$(top_srcdir)/include
 AM_CFLAGS = ${regular_CFLAGS}
 
-pkglib_LTLIBRARIES = ulogd_filter_IFINDEX.la ulogd_filter_PWSNIFF.la \
-		     ulogd_filter_PRINTPKT.la ulogd_filter_PRINTFLOW.la \
-		     ulogd_filter_IP2STR.la ulogd_filter_IP2BIN.la \
-		     ulogd_filter_HWHDR.la ulogd_filter_MARK.la
+pkglibexec_LTLIBRARIES = ulogd_filter_IFINDEX.la ulogd_filter_PWSNIFF.la \
+			 ulogd_filter_PRINTPKT.la ulogd_filter_PRINTFLOW.la \
+			 ulogd_filter_IP2STR.la ulogd_filter_IP2BIN.la \
+			 ulogd_filter_HWHDR.la ulogd_filter_MARK.la
 
 ulogd_filter_IFINDEX_la_SOURCES = ulogd_filter_IFINDEX.c
 ulogd_filter_IFINDEX_la_LDFLAGS = -avoid-version -module -lnfnetlink
diff --git a/filter/raw2packet/Makefile.am b/filter/raw2packet/Makefile.am
index 8b5a4ad..a39f3ae 100644
--- a/filter/raw2packet/Makefile.am
+++ b/filter/raw2packet/Makefile.am
@@ -2,7 +2,7 @@
 AM_CPPFLAGS = -I$(top_srcdir)/include
 AM_CFLAGS = ${regular_CFLAGS}
 
-pkglib_LTLIBRARIES = ulogd_raw2packet_BASE.la 
+pkglibexec_LTLIBRARIES = ulogd_raw2packet_BASE.la 
 
 ulogd_raw2packet_BASE_la_SOURCES = ulogd_raw2packet_BASE.c
 ulogd_raw2packet_BASE_la_LDFLAGS = -avoid-version -module
diff --git a/input/flow/Makefile.am b/input/flow/Makefile.am
index 127caf6..eaa1644 100644
--- a/input/flow/Makefile.am
+++ b/input/flow/Makefile.am
@@ -2,7 +2,7 @@
 AM_CPPFLAGS = -I$(top_srcdir)/include
 AM_CFLAGS = ${regular_CFLAGS}
 
-pkglib_LTLIBRARIES = ulogd_inpflow_NFCT.la # ulogd_inpflow_IPFIX.la
+pkglibexec_LTLIBRARIES = ulogd_inpflow_NFCT.la # ulogd_inpflow_IPFIX.la
 
 ulogd_inpflow_NFCT_la_SOURCES = ulogd_inpflow_NFCT.c
 ulogd_inpflow_NFCT_la_LDFLAGS = -avoid-version -module $(LIBNETFILTER_CONNTRACK_LIBS)
diff --git a/input/packet/Makefile.am b/input/packet/Makefile.am
index 2e972f8..d4ca449 100644
--- a/input/packet/Makefile.am
+++ b/input/packet/Makefile.am
@@ -2,7 +2,8 @@
 AM_CPPFLAGS = -I$(top_srcdir)/include
 AM_CFLAGS = ${regular_CFLAGS}
 
-pkglib_LTLIBRARIES = ulogd_inppkt_NFLOG.la ulogd_inppkt_ULOG.la ulogd_inppkt_UNIXSOCK.la
+pkglibexec_LTLIBRARIES = ulogd_inppkt_NFLOG.la ulogd_inppkt_ULOG.la \
+			 ulogd_inppkt_UNIXSOCK.la
 
 ulogd_inppkt_NFLOG_la_SOURCES = ulogd_inppkt_NFLOG.c
 ulogd_inppkt_NFLOG_la_LDFLAGS = -avoid-version -module $(LIBNETFILTER_LOG_LIBS)
diff --git a/output/Makefile.am b/output/Makefile.am
index 9d9ac73..3811dad 100644
--- a/output/Makefile.am
+++ b/output/Makefile.am
@@ -3,9 +3,9 @@ AM_CFLAGS = ${regular_CFLAGS}
 
 SUBDIRS= pcap mysql pgsql sqlite3 dbi
 
-pkglib_LTLIBRARIES = ulogd_output_LOGEMU.la ulogd_output_SYSLOG.la \
-		     ulogd_output_OPRINT.la \
-		     ulogd_output_NACCT.la ulogd_output_XML.la
+pkglibexec_LTLIBRARIES = ulogd_output_LOGEMU.la ulogd_output_SYSLOG.la \
+			 ulogd_output_OPRINT.la \
+			 ulogd_output_NACCT.la ulogd_output_XML.la
 
 ulogd_output_LOGEMU_la_SOURCES = ulogd_output_LOGEMU.c
 ulogd_output_LOGEMU_la_LDFLAGS = -avoid-version -module
diff --git a/output/dbi/Makefile.am b/output/dbi/Makefile.am
index f413cab..ca05e00 100644
--- a/output/dbi/Makefile.am
+++ b/output/dbi/Makefile.am
@@ -4,7 +4,7 @@ AM_CFLAGS = ${regular_CFLAGS}
 
 if HAVE_DBI
 
-pkglib_LTLIBRARIES = ulogd_output_DBI.la
+pkglibexec_LTLIBRARIES = ulogd_output_DBI.la
 
 ulogd_output_DBI_la_SOURCES = ulogd_output_DBI.c ../../util/db.c
 ulogd_output_DBI_la_LIBADD  = ${DBI_LIB}
diff --git a/output/mysql/Makefile.am b/output/mysql/Makefile.am
index c24208c..5c3afbb 100644
--- a/output/mysql/Makefile.am
+++ b/output/mysql/Makefile.am
@@ -3,7 +3,7 @@ AM_CFLAGS = ${regular_CFLAGS}
 
 if HAVE_MYSQL
 
-pkglib_LTLIBRARIES = ulogd_output_MYSQL.la
+pkglibexec_LTLIBRARIES = ulogd_output_MYSQL.la
 
 ulogd_output_MYSQL_la_SOURCES = ulogd_output_MYSQL.c ../../util/db.c
 ulogd_output_MYSQL_la_LIBADD  = ${MYSQL_LIB}
diff --git a/output/pcap/Makefile.am b/output/pcap/Makefile.am
index 47580d2..54c6da3 100644
--- a/output/pcap/Makefile.am
+++ b/output/pcap/Makefile.am
@@ -4,7 +4,7 @@ AM_CFLAGS = ${regular_CFLAGS}
 
 if HAVE_PCAP
 
-pkglib_LTLIBRARIES = ulogd_output_PCAP.la
+pkglibexec_LTLIBRARIES = ulogd_output_PCAP.la
 
 ulogd_output_PCAP_la_SOURCES = ulogd_output_PCAP.c
 ulogd_output_PCAP_la_LIBADD  = ${PCAP_LIB}
diff --git a/output/pgsql/Makefile.am b/output/pgsql/Makefile.am
index bdaf1d2..32b3ea2 100644
--- a/output/pgsql/Makefile.am
+++ b/output/pgsql/Makefile.am
@@ -4,7 +4,7 @@ AM_CFLAGS = ${regular_CFLAGS}
 
 if HAVE_PGSQL
 
-pkglib_LTLIBRARIES = ulogd_output_PGSQL.la
+pkglibexec_LTLIBRARIES = ulogd_output_PGSQL.la
 
 ulogd_output_PGSQL_la_SOURCES = ulogd_output_PGSQL.c ../../util/db.c
 ulogd_output_PGSQL_la_LIBADD  = ${PQLIBS}
diff --git a/output/sqlite3/Makefile.am b/output/sqlite3/Makefile.am
index 3bfec2e..507dbfc 100644
--- a/output/sqlite3/Makefile.am
+++ b/output/sqlite3/Makefile.am
@@ -3,7 +3,7 @@ AM_CFLAGS = ${regular_CFLAGS}
 
 if HAVE_SQLITE3
 
-pkglib_LTLIBRARIES = ulogd_output_SQLITE3.la
+pkglibexec_LTLIBRARIES = ulogd_output_SQLITE3.la
 
 ulogd_output_SQLITE3_la_SOURCES = ulogd_output_SQLITE3.c ../../util/db.c
 ulogd_output_SQLITE3_la_LIBADD  = ${SQLITE3_LIBS}
diff --git a/ulogd.conf.in b/ulogd.conf.in
index 634e37f..268818f 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -25,27 +25,27 @@ loglevel=1
 # 2. options for each plugin in seperate section below
 
 
-plugin="@libdir@/ulogd/ulogd_inppkt_NFLOG.so"
-#plugin="@libdir@/ulogd/ulogd_inppkt_ULOG.so"
-#plugin="@libdir@/ulogd/ulogd_inppkt_UNIXSOCK.so"
-plugin="@libdir@/ulogd/ulogd_inpflow_NFCT.so"
-plugin="@libdir@/ulogd/ulogd_filter_IFINDEX.so"
-plugin="@libdir@/ulogd/ulogd_filter_IP2STR.so"
-plugin="@libdir@/ulogd/ulogd_filter_IP2BIN.so"
-plugin="@libdir@/ulogd/ulogd_filter_PRINTPKT.so"
-plugin="@libdir@/ulogd/ulogd_filter_HWHDR.so"
-plugin="@libdir@/ulogd/ulogd_filter_PRINTFLOW.so"
-#plugin="@libdir@/ulogd/ulogd_filter_MARK.so"
-plugin="@libdir@/ulogd/ulogd_output_LOGEMU.so"
-plugin="@libdir@/ulogd/ulogd_output_SYSLOG.so"
-plugin="@libdir@/ulogd/ulogd_output_XML.so"
-#plugin="@libdir@/ulogd/ulogd_output_OPRINT.so"
-#plugin="@libdir@/ulogd/ulogd_output_NACCT.so"
-#plugin="@libdir@/ulogd/ulogd_output_PCAP.so"
-#plugin="@libdir@/ulogd/ulogd_output_PGSQL.so"
-#plugin="@libdir@/ulogd/ulogd_output_MYSQL.so"
-#plugin="@libdir@/ulogd/ulogd_output_DBI.so"
-plugin="@libdir@/ulogd/ulogd_raw2packet_BASE.so"
+plugin="@pkglibexecdir@/ulogd_inppkt_NFLOG.so"
+#plugin="@pkglibexecdir@/ulogd_inppkt_ULOG.so"
+#plugin="@pkglibexecdir@/ulogd_inppkt_UNIXSOCK.so"
+plugin="@pkglibexecdir@/ulogd_inpflow_NFCT.so"
+plugin="@pkglibexecdir@/ulogd_filter_IFINDEX.so"
+plugin="@pkglibexecdir@/ulogd_filter_IP2STR.so"
+plugin="@pkglibexecdir@/ulogd_filter_IP2BIN.so"
+plugin="@pkglibexecdir@/ulogd_filter_PRINTPKT.so"
+plugin="@pkglibexecdir@/ulogd_filter_HWHDR.so"
+plugin="@pkglibexecdir@/ulogd_filter_PRINTFLOW.so"
+#plugin="@pkglibexecdir@/ulogd_filter_MARK.so"
+plugin="@pkglibexecdir@/ulogd_output_LOGEMU.so"
+plugin="@pkglibexecdir@/ulogd_output_SYSLOG.so"
+plugin="@pkglibexecdir@/ulogd_output_XML.so"
+#plugin="@pkglibexecdir@/ulogd_output_OPRINT.so"
+#plugin="@pkglibexecdir@/ulogd_output_NACCT.so"
+#plugin="@pkglibexecdir@/ulogd_output_PCAP.so"
+#plugin="@pkglibexecdir@/ulogd_output_PGSQL.so"
+#plugin="@pkglibexecdir@/ulogd_output_MYSQL.so"
+#plugin="@pkglibexecdir@/ulogd_output_DBI.so"
+plugin="@pkglibexecdir@/ulogd_raw2packet_BASE.so"
 
 # this is a stack for logging packet send by system via LOGEMU
 #stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
-- 
1.7.1

