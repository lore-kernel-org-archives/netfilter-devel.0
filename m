From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 7/9] build: propagate global CFLAGS
Date: Fri,  5 Nov 2010 19:36:21 +0100
Message-ID: <1288982184-23584-8-git-send-email-jengelh@medozas.de>
References: <1288982184-23584-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44410 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686Ab0KESge (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 14:36:34 -0400
In-Reply-To: <1288982184-23584-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We must not override CFLAGS, because that will break when the user
overrides CFLAGS again at make time (which he is entitled to). So,
name our CFLAGS regular_CFLAGS, and also include that across all
Makefiles so that they are actually uesd for all the code.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac                  |    3 ++-
 filter/Makefile.am            |    1 +
 filter/raw2packet/Makefile.am |    1 +
 input/flow/Makefile.am        |    2 +-
 input/packet/Makefile.am      |    2 +-
 libipulog/Makefile.am         |    1 +
 output/Makefile.am            |    1 +
 output/dbi/Makefile.am        |    1 +
 output/mysql/Makefile.am      |    1 +
 output/pcap/Makefile.am       |    1 +
 output/pgsql/Makefile.am      |    1 +
 output/sqlite3/Makefile.am    |    1 +
 src/Makefile.am               |    1 +
 13 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/configure.ac b/configure.ac
index 2447574..fec034e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -32,7 +32,8 @@ dnl Checks for library functions.
 AC_FUNC_VPRINTF
 AC_CHECK_FUNCS(socket strerror)
 
-CFLAGS="$CFLAGS -Wall -Wextra -Wno-unused-parameter"
+regular_CFLAGS="-Wall -Wextra -Wno-unused-parameter"
+AC_SUBST([regular_CFLAGS])
 
 dnl Check for the right nfnetlink version
 LIBNFNETLINK_REQUIRED=0.0.39
diff --git a/filter/Makefile.am b/filter/Makefile.am
index 9b51670..3c3f152 100644
--- a/filter/Makefile.am
+++ b/filter/Makefile.am
@@ -1,6 +1,7 @@
 SUBDIRS = raw2packet packet2flow
 
 AM_CPPFLAGS = -I$(top_srcdir)/include
+AM_CFLAGS = ${regular_CFLAGS}
 
 pkglib_LTLIBRARIES = ulogd_filter_IFINDEX.la ulogd_filter_PWSNIFF.la \
 		     ulogd_filter_PRINTPKT.la ulogd_filter_PRINTFLOW.la \
diff --git a/filter/raw2packet/Makefile.am b/filter/raw2packet/Makefile.am
index c959661..8b5a4ad 100644
--- a/filter/raw2packet/Makefile.am
+++ b/filter/raw2packet/Makefile.am
@@ -1,5 +1,6 @@
 
 AM_CPPFLAGS = -I$(top_srcdir)/include
+AM_CFLAGS = ${regular_CFLAGS}
 
 pkglib_LTLIBRARIES = ulogd_raw2packet_BASE.la 
 
diff --git a/input/flow/Makefile.am b/input/flow/Makefile.am
index 21ab32f..127caf6 100644
--- a/input/flow/Makefile.am
+++ b/input/flow/Makefile.am
@@ -1,6 +1,6 @@
 
 AM_CPPFLAGS = -I$(top_srcdir)/include
-AM_CFLAGS = -Wall
+AM_CFLAGS = ${regular_CFLAGS}
 
 pkglib_LTLIBRARIES = ulogd_inpflow_NFCT.la # ulogd_inpflow_IPFIX.la
 
diff --git a/input/packet/Makefile.am b/input/packet/Makefile.am
index f8afc03..7fd8979 100644
--- a/input/packet/Makefile.am
+++ b/input/packet/Makefile.am
@@ -1,6 +1,6 @@
 
 AM_CPPFLAGS = -I$(top_srcdir)/include
-AM_CFLAGS = -Wall
+AM_CFLAGS = ${regular_CFLAGS}
 LIBS=
 
 pkglib_LTLIBRARIES = ulogd_inppkt_NFLOG.la ulogd_inppkt_ULOG.la ulogd_inppkt_UNIXSOCK.la
diff --git a/libipulog/Makefile.am b/libipulog/Makefile.am
index 7c46bec..111cd48 100644
--- a/libipulog/Makefile.am
+++ b/libipulog/Makefile.am
@@ -1,5 +1,6 @@
 
 AM_CPPFLAGS = -I$(top_srcdir)/include
+AM_CFLAGS = ${regular_CFLAGS}
 
 noinst_LTLIBRARIES = libipulog.la
 
diff --git a/output/Makefile.am b/output/Makefile.am
index 2c35054..34ffb2d 100644
--- a/output/Makefile.am
+++ b/output/Makefile.am
@@ -1,4 +1,5 @@
 AM_CPPFLAGS = -I$(top_srcdir)/include
+AM_CFLAGS = ${regular_CFLAGS}
 LIBS=""
 
 SUBDIRS= pcap mysql pgsql sqlite3 dbi
diff --git a/output/dbi/Makefile.am b/output/dbi/Makefile.am
index 0e68cd3..1ee8f2a 100644
--- a/output/dbi/Makefile.am
+++ b/output/dbi/Makefile.am
@@ -1,5 +1,6 @@
 
 AM_CPPFLAGS = -I$(top_srcdir)/include $(DBI_INC)
+AM_CFLAGS = ${regular_CFLAGS}
 LIBS=$(DBI_LIB)
 
 if HAVE_DBI
diff --git a/output/mysql/Makefile.am b/output/mysql/Makefile.am
index 8da758b..a98cdeb 100644
--- a/output/mysql/Makefile.am
+++ b/output/mysql/Makefile.am
@@ -1,4 +1,5 @@
 AM_CPPFLAGS = -I$(top_srcdir)/include $(MYSQL_INC)
+AM_CFLAGS = ${regular_CFLAGS}
 LIBS=$(MYSQL_LIB)
 
 if HAVE_MYSQL
diff --git a/output/pcap/Makefile.am b/output/pcap/Makefile.am
index ac89cfe..59cb3f6 100644
--- a/output/pcap/Makefile.am
+++ b/output/pcap/Makefile.am
@@ -1,5 +1,6 @@
 
 AM_CPPFLAGS = -I$(top_srcdir)/include $(PCAP_INC)
+AM_CFLAGS = ${regular_CFLAGS}
 LIBS=$(PCAP_LIB)
 
 if HAVE_PCAP
diff --git a/output/pgsql/Makefile.am b/output/pgsql/Makefile.am
index 99947bc..32be79b 100644
--- a/output/pgsql/Makefile.am
+++ b/output/pgsql/Makefile.am
@@ -1,5 +1,6 @@
 
 AM_CPPFLAGS = -I$(top_srcdir)/include -I$(PQINCPATH)
+AM_CFLAGS = ${regular_CFLAGS}
 LIBS=$(PQLIBS)
 
 if HAVE_PGSQL
diff --git a/output/sqlite3/Makefile.am b/output/sqlite3/Makefile.am
index d8bedc9..d14398c 100644
--- a/output/sqlite3/Makefile.am
+++ b/output/sqlite3/Makefile.am
@@ -1,4 +1,5 @@
 AM_CPPFLAGS = -I$(top_srcdir)/include $(SQLITE3_INC)
+AM_CFLAGS = ${regular_CFLAGS}
 LIBS=$(SQLITE3_LIB)
 
 if HAVE_SQLITE3
diff --git a/src/Makefile.am b/src/Makefile.am
index d83d13e..9ae7884 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -2,6 +2,7 @@
 AM_CPPFLAGS = -I$(top_srcdir)/include \
 	      -DULOGD_CONFIGFILE="\"$(sysconfdir)/ulogd.conf\"" \
 	      -DULOGD_LOGFILE_DEFAULT="\"$(localstatedir)/log/ulogd.log\""
+AM_CFLAGS = ${regular_CFLAGS}
 
 sbin_PROGRAMS = ulogd
 
-- 
1.7.1

