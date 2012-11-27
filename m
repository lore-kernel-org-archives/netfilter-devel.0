From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 2/2] build: move remaining preprocessor flags into CPPFLAGS
Date: Tue, 27 Nov 2012 13:49:06 +0100
Message-ID: <1354020546-4799-2-git-send-email-jengelh@inai.de>
References: <1354020546-4799-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: eric@regit.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:50805 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab2K0MtJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2012 07:49:09 -0500
In-Reply-To: <1354020546-4799-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The flags retrieved from `pkg-config --cflags ...` are generally only
preprocessor flags (mostly -I to point to the directories), since
anything else would inconvenience downstream users.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 filter/Makefile.am         |    4 ++--
 output/Makefile.am         |    6 +++---
 output/sqlite3/Makefile.am |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/filter/Makefile.am b/filter/Makefile.am
index 5af0696..875850b 100644
--- a/filter/Makefile.am
+++ b/filter/Makefile.am
@@ -1,7 +1,7 @@
 SUBDIRS = raw2packet packet2flow
 
-AM_CPPFLAGS = -I$(top_srcdir)/include
-AM_CFLAGS = ${regular_CFLAGS} ${LIBNFNETLINK_CFLAGS}
+AM_CPPFLAGS = -I$(top_srcdir)/include ${LIBNFNETLINK_CFLAGS}
+AM_CFLAGS = ${regular_CFLAGS}
 
 pkglib_LTLIBRARIES = ulogd_filter_IFINDEX.la ulogd_filter_PWSNIFF.la \
 			 ulogd_filter_PRINTPKT.la ulogd_filter_PRINTFLOW.la \
diff --git a/output/Makefile.am b/output/Makefile.am
index 61d827a..fe0a19c 100644
--- a/output/Makefile.am
+++ b/output/Makefile.am
@@ -1,6 +1,6 @@
-AM_CPPFLAGS = -I$(top_srcdir)/include ${LIBNETFILTER_ACCT_CFLAGS}
-AM_CFLAGS = ${regular_CFLAGS} ${LIBNETFILTER_LOG_CFLAGS} \
-	    ${LIBNETFILTER_CONNTRACK_CFLAGS}
+AM_CPPFLAGS = -I$(top_srcdir)/include ${LIBNETFILTER_ACCT_CFLAGS} \
+              ${LIBNETFILTER_CONNTRACK_CFLAGS} ${LIBNETFILTER_LOG_CFLAGS}
+AM_CFLAGS = ${regular_CFLAGS}
 
 SUBDIRS= pcap mysql pgsql sqlite3 dbi
 
diff --git a/output/sqlite3/Makefile.am b/output/sqlite3/Makefile.am
index dd148ec..62af267 100644
--- a/output/sqlite3/Makefile.am
+++ b/output/sqlite3/Makefile.am
@@ -1,5 +1,5 @@
-AM_CPPFLAGS = -I$(top_srcdir)/include
-AM_CFLAGS = ${regular_CFLAGS} ${libsqlite3_CFLAGS}
+AM_CPPFLAGS = -I$(top_srcdir)/include ${libsqlite3_CFLAGS}
+AM_CFLAGS = ${regular_CFLAGS}
 
 if HAVE_SQLITE3
 
-- 
1.7.10.4

