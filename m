From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/9] build: remove unused $(all_includes)
Date: Fri,  5 Nov 2010 19:36:18 +0100
Message-ID: <1288982184-23584-5-git-send-email-jengelh@medozas.de>
References: <1288982184-23584-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44396 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab0KESga (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 14:36:30 -0400
In-Reply-To: <1288982184-23584-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am                   |    2 +-
 filter/Makefile.am            |    2 +-
 filter/raw2packet/Makefile.am |    2 +-
 input/flow/Makefile.am        |    2 +-
 input/packet/Makefile.am      |    2 +-
 libipulog/Makefile.am         |    2 +-
 output/Makefile.am            |    2 +-
 output/dbi/Makefile.am        |    2 +-
 output/mysql/Makefile.am      |    2 +-
 output/pcap/Makefile.am       |    2 +-
 output/pgsql/Makefile.am      |    2 +-
 output/sqlite3/Makefile.am    |    2 +-
 src/Makefile.am               |    2 +-
 13 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 20822c2..d4c180b 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -5,7 +5,7 @@ man_MANS = ulogd.8
 
 EXTRA_DIST = $(man_MANS) ulogd.logrotate ulogd.spec ulogd.conf.in doc
 
-AM_CPPFLAGS = $(all_includes) -I$(top_srcdir)/include
+AM_CPPFLAGS = -I$(top_srcdir)/include
 SUBDIRS = include libipulog src input filter output
 
 noinst_DATA = ulogd.conf
diff --git a/filter/Makefile.am b/filter/Makefile.am
index 2483119..9b51670 100644
--- a/filter/Makefile.am
+++ b/filter/Makefile.am
@@ -1,6 +1,6 @@
 SUBDIRS = raw2packet packet2flow
 
-AM_CPPFLAGS = $(all_includes) -I$(top_srcdir)/include
+AM_CPPFLAGS = -I$(top_srcdir)/include
 
 pkglib_LTLIBRARIES = ulogd_filter_IFINDEX.la ulogd_filter_PWSNIFF.la \
 		     ulogd_filter_PRINTPKT.la ulogd_filter_PRINTFLOW.la \
diff --git a/filter/raw2packet/Makefile.am b/filter/raw2packet/Makefile.am
index aa82e04..c959661 100644
--- a/filter/raw2packet/Makefile.am
+++ b/filter/raw2packet/Makefile.am
@@ -1,5 +1,5 @@
 
-AM_CPPFLAGS = $(all_includes) -I$(top_srcdir)/include
+AM_CPPFLAGS = -I$(top_srcdir)/include
 
 pkglib_LTLIBRARIES = ulogd_raw2packet_BASE.la 
 
diff --git a/input/flow/Makefile.am b/input/flow/Makefile.am
index c2b5f88..21ab32f 100644
--- a/input/flow/Makefile.am
+++ b/input/flow/Makefile.am
@@ -1,5 +1,5 @@
 
-AM_CPPFLAGS = $(all_includes) -I$(top_srcdir)/include
+AM_CPPFLAGS = -I$(top_srcdir)/include
 AM_CFLAGS = -Wall
 
 pkglib_LTLIBRARIES = ulogd_inpflow_NFCT.la # ulogd_inpflow_IPFIX.la
diff --git a/input/packet/Makefile.am b/input/packet/Makefile.am
index 4dff308..f8afc03 100644
--- a/input/packet/Makefile.am
+++ b/input/packet/Makefile.am
@@ -1,5 +1,5 @@
 
-AM_CPPFLAGS = $(all_includes) -I$(top_srcdir)/include
+AM_CPPFLAGS = -I$(top_srcdir)/include
 AM_CFLAGS = -Wall
 LIBS=
 
diff --git a/libipulog/Makefile.am b/libipulog/Makefile.am
index 290f8ee..7c46bec 100644
--- a/libipulog/Makefile.am
+++ b/libipulog/Makefile.am
@@ -1,5 +1,5 @@
 
-AM_CPPFLAGS = $(all_includes) -I$(top_srcdir)/include
+AM_CPPFLAGS = -I$(top_srcdir)/include
 
 noinst_LTLIBRARIES = libipulog.la
 
diff --git a/output/Makefile.am b/output/Makefile.am
index c60c5e6..2c35054 100644
--- a/output/Makefile.am
+++ b/output/Makefile.am
@@ -1,4 +1,4 @@
-AM_CPPFLAGS = $(all_includes) -I$(top_srcdir)/include
+AM_CPPFLAGS = -I$(top_srcdir)/include
 LIBS=""
 
 SUBDIRS= pcap mysql pgsql sqlite3 dbi
diff --git a/output/dbi/Makefile.am b/output/dbi/Makefile.am
index 28c45a6..0e68cd3 100644
--- a/output/dbi/Makefile.am
+++ b/output/dbi/Makefile.am
@@ -1,5 +1,5 @@
 
-AM_CPPFLAGS = $(all_includes) -I$(top_srcdir)/include $(DBI_INC)
+AM_CPPFLAGS = -I$(top_srcdir)/include $(DBI_INC)
 LIBS=$(DBI_LIB)
 
 if HAVE_DBI
diff --git a/output/mysql/Makefile.am b/output/mysql/Makefile.am
index 50f3f92..8da758b 100644
--- a/output/mysql/Makefile.am
+++ b/output/mysql/Makefile.am
@@ -1,4 +1,4 @@
-AM_CPPFLAGS = $(all_includes) -I$(top_srcdir)/include $(MYSQL_INC)
+AM_CPPFLAGS = -I$(top_srcdir)/include $(MYSQL_INC)
 LIBS=$(MYSQL_LIB)
 
 if HAVE_MYSQL
diff --git a/output/pcap/Makefile.am b/output/pcap/Makefile.am
index b77b2d3..ac89cfe 100644
--- a/output/pcap/Makefile.am
+++ b/output/pcap/Makefile.am
@@ -1,5 +1,5 @@
 
-AM_CPPFLAGS = $(all_includes) -I$(top_srcdir)/include $(PCAP_INC)
+AM_CPPFLAGS = -I$(top_srcdir)/include $(PCAP_INC)
 LIBS=$(PCAP_LIB)
 
 if HAVE_PCAP
diff --git a/output/pgsql/Makefile.am b/output/pgsql/Makefile.am
index e8f4acc..99947bc 100644
--- a/output/pgsql/Makefile.am
+++ b/output/pgsql/Makefile.am
@@ -1,5 +1,5 @@
 
-AM_CPPFLAGS = $(all_includes) -I$(top_srcdir)/include -I$(PQINCPATH)
+AM_CPPFLAGS = -I$(top_srcdir)/include -I$(PQINCPATH)
 LIBS=$(PQLIBS)
 
 if HAVE_PGSQL
diff --git a/output/sqlite3/Makefile.am b/output/sqlite3/Makefile.am
index df1272a..d8bedc9 100644
--- a/output/sqlite3/Makefile.am
+++ b/output/sqlite3/Makefile.am
@@ -1,4 +1,4 @@
-AM_CPPFLAGS = $(all_includes) -I$(top_srcdir)/include $(SQLITE3_INC)
+AM_CPPFLAGS = -I$(top_srcdir)/include $(SQLITE3_INC)
 LIBS=$(SQLITE3_LIB)
 
 if HAVE_SQLITE3
diff --git a/src/Makefile.am b/src/Makefile.am
index aa9a3fa..d83d13e 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -1,5 +1,5 @@
 
-AM_CPPFLAGS = $(all_includes) -I$(top_srcdir)/include \
+AM_CPPFLAGS = -I$(top_srcdir)/include \
 	      -DULOGD_CONFIGFILE="\"$(sysconfdir)/ulogd.conf\"" \
 	      -DULOGD_LOGFILE_DEFAULT="\"$(localstatedir)/log/ulogd.log\""
 
-- 
1.7.1

