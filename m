From: Jan Engelhardt <jengelh@medozas.de>
Subject: [3/5] build: use -avoid-version for modules
Date: Tue, 20 Jan 2009 12:17:03 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901201216540.13700@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0901201214520.13700@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: eric@inl.fr
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39853 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438AbZATLRE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Jan 2009 06:17:04 -0500
In-Reply-To: <alpine.LSU.2.00.0901201214520.13700@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

parent a04c67dfc98bffef3b00b8ed04e54ca92eedfa1c
commit 433135f373edde9cc9c129b28257844eb1b3642c
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Jan 20 09:04:03 2009 +0100

build: use -avoid-version for modules

The modules are pretty much bound to ulogd, and it does not seem
to make sense to specially version these.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 filter/Makefile.am            |   16 ++++++++--------
 filter/raw2packet/Makefile.am |    2 +-
 input/flow/Makefile.am        |    4 ++--
 input/packet/Makefile.am      |    4 ++--
 output/Makefile.am            |   10 +++++-----
 output/dbi/Makefile.am        |    2 +-
 output/mysql/Makefile.am      |    2 +-
 output/pcap/Makefile.am       |    2 +-
 output/pgsql/Makefile.am      |    2 +-
 output/sqlite3/Makefile.am    |    2 +-
 10 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/filter/Makefile.am b/filter/Makefile.am
index 556705c..5c4e4ab 100644
--- a/filter/Makefile.am
+++ b/filter/Makefile.am
@@ -8,25 +8,25 @@ pkglib_LTLIBRARIES = ulogd_filter_IFINDEX.la ulogd_filter_PWSNIFF.la \
 		     ulogd_filter_HWHDR.la ulogd_filter_MARK.la
 
 ulogd_filter_IFINDEX_la_SOURCES = ulogd_filter_IFINDEX.c
-ulogd_filter_IFINDEX_la_LDFLAGS = -module -lnfnetlink
+ulogd_filter_IFINDEX_la_LDFLAGS = -avoid-version -module -lnfnetlink
 
 ulogd_filter_PWSNIFF_la_SOURCES = ulogd_filter_PWSNIFF.c
-ulogd_filter_PWSNIFF_la_LDFLAGS = -module
+ulogd_filter_PWSNIFF_la_LDFLAGS = -avoid-version -module
 
 ulogd_filter_IP2STR_la_SOURCES = ulogd_filter_IP2STR.c
-ulogd_filter_IP2STR_la_LDFLAGS = -module
+ulogd_filter_IP2STR_la_LDFLAGS = -avoid-version -module
 
 ulogd_filter_IP2BIN_la_SOURCES = ulogd_filter_IP2BIN.c
-ulogd_filter_IP2BIN_la_LDFLAGS = -module
+ulogd_filter_IP2BIN_la_LDFLAGS = -avoid-version -module
 
 ulogd_filter_HWHDR_la_SOURCES = ulogd_filter_HWHDR.c
-ulogd_filter_HWHDR_la_LDFLAGS = -module
+ulogd_filter_HWHDR_la_LDFLAGS = -avoid-version -module
 
 ulogd_filter_MARK_la_SOURCES = ulogd_filter_MARK.c
-ulogd_filter_MARK_la_LDFLAGS = -module
+ulogd_filter_MARK_la_LDFLAGS = -avoid-version -module
 
 ulogd_filter_PRINTPKT_la_SOURCES = ulogd_filter_PRINTPKT.c ../util/printpkt.c
-ulogd_filter_PRINTPKT_la_LDFLAGS = -module
+ulogd_filter_PRINTPKT_la_LDFLAGS = -avoid-version -module
 
 ulogd_filter_PRINTFLOW_la_SOURCES = ulogd_filter_PRINTFLOW.c ../util/printflow.c
-ulogd_filter_PRINTFLOW_la_LDFLAGS = -module
+ulogd_filter_PRINTFLOW_la_LDFLAGS = -avoid-version -module
diff --git a/filter/raw2packet/Makefile.am b/filter/raw2packet/Makefile.am
index 94adb3c..25111a8 100644
--- a/filter/raw2packet/Makefile.am
+++ b/filter/raw2packet/Makefile.am
@@ -4,4 +4,4 @@ INCLUDES = $(all_includes) -I$(top_srcdir)/include
 pkglib_LTLIBRARIES = ulogd_raw2packet_BASE.la 
 
 ulogd_raw2packet_BASE_la_SOURCES = ulogd_raw2packet_BASE.c
-ulogd_raw2packet_BASE_la_LDFLAGS = -module
+ulogd_raw2packet_BASE_la_LDFLAGS = -avoid-version -module
diff --git a/input/flow/Makefile.am b/input/flow/Makefile.am
index 288d335..012feb8 100644
--- a/input/flow/Makefile.am
+++ b/input/flow/Makefile.am
@@ -5,8 +5,8 @@ AM_CFLAGS=-fPIC -Wall
 pkglib_LTLIBRARIES = ulogd_inpflow_NFCT.la # ulogd_inpflow_IPFIX.la
 
 ulogd_inpflow_NFCT_la_SOURCES = ulogd_inpflow_NFCT.c
-ulogd_inpflow_NFCT_la_LDFLAGS = -module $(LIBNETFILTER_CONNTRACK_LIBS)
+ulogd_inpflow_NFCT_la_LDFLAGS = -avoid-version -module $(LIBNETFILTER_CONNTRACK_LIBS)
 ulogd_inpflow_NFCT_la_CFLAGS = $(AM_CFLAGS) $(LIBNETFILTER_CONNTRACK_CFLAGS)
 
 #ulogd_inpflow_IPFIX_la_SOURCES = ulogd_inpflow_IPFIX.c
-#ulogd_inpflow_IPFIX_la_LDFLAGS = -module
+#ulogd_inpflow_IPFIX_la_LDFLAGS = -avoid-version -module
diff --git a/input/packet/Makefile.am b/input/packet/Makefile.am
index a07f724..716ed38 100644
--- a/input/packet/Makefile.am
+++ b/input/packet/Makefile.am
@@ -6,9 +6,9 @@ LIBS=
 pkglib_LTLIBRARIES = ulogd_inppkt_NFLOG.la ulogd_inppkt_ULOG.la
 
 ulogd_inppkt_NFLOG_la_SOURCES = ulogd_inppkt_NFLOG.c
-ulogd_inppkt_NFLOG_la_LDFLAGS = -module $(LIBNETFILTER_LOG_LIBS)
+ulogd_inppkt_NFLOG_la_LDFLAGS = -avoid-version -module $(LIBNETFILTER_LOG_LIBS)
 ulogd_inppkt_NFLOG_la_CFLAGS = $(AM_CFLAGS) $(LIBNETFILTER_LOG_CFLAGS)
 
 ulogd_inppkt_ULOG_la_SOURCES = ulogd_inppkt_ULOG.c
-ulogd_inppkt_ULOG_la_LDFLAGS = -module
+ulogd_inppkt_ULOG_la_LDFLAGS = -avoid-version -module
 ulogd_inppkt_ULOG_la_LIBADD = ../../libipulog/libipulog.la
diff --git a/output/Makefile.am b/output/Makefile.am
index 69578a0..beceb6b 100644
--- a/output/Makefile.am
+++ b/output/Makefile.am
@@ -8,16 +8,16 @@ pkglib_LTLIBRARIES = ulogd_output_LOGEMU.la ulogd_output_SYSLOG.la \
 		     ulogd_output_NACCT.la
 
 ulogd_output_LOGEMU_la_SOURCES = ulogd_output_LOGEMU.c
-ulogd_output_LOGEMU_la_LDFLAGS = -module
+ulogd_output_LOGEMU_la_LDFLAGS = -avoid-version -module
 
 ulogd_output_SYSLOG_la_SOURCES = ulogd_output_SYSLOG.c
-ulogd_output_SYSLOG_la_LDFLAGS = -module
+ulogd_output_SYSLOG_la_LDFLAGS = -avoid-version -module
 
 ulogd_output_OPRINT_la_SOURCES = ulogd_output_OPRINT.c
-ulogd_output_OPRINT_la_LDFLAGS = -module
+ulogd_output_OPRINT_la_LDFLAGS = -avoid-version -module
 
 ulogd_output_IPFIX_la_SOURCES = ulogd_output_IPFIX.c
-ulogd_output_IPFIX_la_LDFLAGS = -module
+ulogd_output_IPFIX_la_LDFLAGS = -avoid-version -module
 
 ulogd_output_NACCT_la_SOURCES = ulogd_output_NACCT.c
-ulogd_output_NACCT_la_LDFLAGS = -module
+ulogd_output_NACCT_la_LDFLAGS = -avoid-version -module
diff --git a/output/dbi/Makefile.am b/output/dbi/Makefile.am
index d127587..382e698 100644
--- a/output/dbi/Makefile.am
+++ b/output/dbi/Makefile.am
@@ -7,6 +7,6 @@ if HAVE_DBI
 pkglib_LTLIBRARIES = ulogd_output_DBI.la
 
 ulogd_output_DBI_la_SOURCES = ulogd_output_DBI.c ../../util/db.c
-ulogd_output_DBI_la_LDFLAGS = -module
+ulogd_output_DBI_la_LDFLAGS = -avoid-version -module
 
 endif
diff --git a/output/mysql/Makefile.am b/output/mysql/Makefile.am
index 35ebd63..b807a4d 100644
--- a/output/mysql/Makefile.am
+++ b/output/mysql/Makefile.am
@@ -6,6 +6,6 @@ if HAVE_MYSQL
 pkglib_LTLIBRARIES = ulogd_output_MYSQL.la
 
 ulogd_output_MYSQL_la_SOURCES = ulogd_output_MYSQL.c ../../util/db.c
-ulogd_output_MYSQL_la_LDFLAGS = -module
+ulogd_output_MYSQL_la_LDFLAGS = -avoid-version -module
 
 endif
diff --git a/output/pcap/Makefile.am b/output/pcap/Makefile.am
index 98a222b..5e2019f 100644
--- a/output/pcap/Makefile.am
+++ b/output/pcap/Makefile.am
@@ -7,6 +7,6 @@ if HAVE_PCAP
 pkglib_LTLIBRARIES = ulogd_output_PCAP.la
 
 ulogd_output_PCAP_la_SOURCES = ulogd_output_PCAP.c
-ulogd_output_PCAP_la_LDFLAGS = -module
+ulogd_output_PCAP_la_LDFLAGS = -avoid-version -module
 
 endif
diff --git a/output/pgsql/Makefile.am b/output/pgsql/Makefile.am
index 5452455..e1e0d9f 100644
--- a/output/pgsql/Makefile.am
+++ b/output/pgsql/Makefile.am
@@ -7,6 +7,6 @@ if HAVE_PGSQL
 pkglib_LTLIBRARIES = ulogd_output_PGSQL.la
 
 ulogd_output_PGSQL_la_SOURCES = ulogd_output_PGSQL.c ../../util/db.c
-ulogd_output_PGSQL_la_LDFLAGS = -module
+ulogd_output_PGSQL_la_LDFLAGS = -avoid-version -module
 
 endif
diff --git a/output/sqlite3/Makefile.am b/output/sqlite3/Makefile.am
index 9920c22..736ecd4 100644
--- a/output/sqlite3/Makefile.am
+++ b/output/sqlite3/Makefile.am
@@ -6,6 +6,6 @@ if HAVE_SQLITE3
 pkglib_LTLIBRARIES = ulogd_output_SQLITE3.la
 
 ulogd_output_SQLITE3_la_SOURCES = ulogd_output_SQLITE3.c ../../util/db.c
-ulogd_output_SQLITE3_la_LDFLAGS = -module
+ulogd_output_SQLITE3_la_LDFLAGS = -avoid-version -module
 
 endif
