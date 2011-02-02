From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/3] build: use compile/link information from pkgconfig
Date: Wed,  2 Feb 2011 22:51:07 +0100
Message-ID: <1296683468-30413-4-git-send-email-jengelh@medozas.de>
References: <1296683468-30413-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36974 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474Ab1BBVvN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:51:13 -0500
In-Reply-To: <1296683468-30413-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is important for when the libraries are in a non-default path.
Also, libs must be listed in LDADD/LIBADD, not LDFLAGS.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 filter/Makefile.am |    5 +++--
 output/Makefile.am |    8 +++++---
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/filter/Makefile.am b/filter/Makefile.am
index 83a0e52..ee0a722 100644
--- a/filter/Makefile.am
+++ b/filter/Makefile.am
@@ -1,7 +1,7 @@
 SUBDIRS = raw2packet packet2flow
 
 AM_CPPFLAGS = -I$(top_srcdir)/include
-AM_CFLAGS = ${regular_CFLAGS}
+AM_CFLAGS = ${regular_CFLAGS} ${LIBNFNETLINK_CFLAGS}
 
 pkglibexec_LTLIBRARIES = ulogd_filter_IFINDEX.la ulogd_filter_PWSNIFF.la \
 			 ulogd_filter_PRINTPKT.la ulogd_filter_PRINTFLOW.la \
@@ -9,7 +9,8 @@ pkglibexec_LTLIBRARIES = ulogd_filter_IFINDEX.la ulogd_filter_PWSNIFF.la \
 			 ulogd_filter_HWHDR.la ulogd_filter_MARK.la
 
 ulogd_filter_IFINDEX_la_SOURCES = ulogd_filter_IFINDEX.c
-ulogd_filter_IFINDEX_la_LDFLAGS = -avoid-version -module -lnfnetlink
+ulogd_filter_IFINDEX_la_LDFLAGS = -avoid-version -module
+ulogd_filter_IFINDEX_la_LIBADD  = ${LIBNFNETLINK_LIBS}
 
 ulogd_filter_PWSNIFF_la_SOURCES = ulogd_filter_PWSNIFF.c
 ulogd_filter_PWSNIFF_la_LDFLAGS = -avoid-version -module
diff --git a/output/Makefile.am b/output/Makefile.am
index 3811dad..2ec6e8d 100644
--- a/output/Makefile.am
+++ b/output/Makefile.am
@@ -1,5 +1,6 @@
 AM_CPPFLAGS = -I$(top_srcdir)/include
-AM_CFLAGS = ${regular_CFLAGS}
+AM_CFLAGS = ${regular_CFLAGS} ${LIBNETFILTER_LOG_CFLAGS} \
+	    ${LIBNETFILTER_CONNTRACK_CFLAGS}
 
 SUBDIRS= pcap mysql pgsql sqlite3 dbi
 
@@ -20,5 +21,6 @@ ulogd_output_NACCT_la_SOURCES = ulogd_output_NACCT.c
 ulogd_output_NACCT_la_LDFLAGS = -avoid-version -module
 
 ulogd_output_XML_la_SOURCES = ulogd_output_XML.c
-ulogd_output_XML_la_LDFLAGS = -avoid-version -module -lnetfilter_log \
-			      -lnetfilter_conntrack
+ulogd_output_XML_la_LIBADD  = ${LIBNETFILTER_LOG_LIBS} \
+			      ${LIBNETFILTER_CONNTRACK_LIBS}
+ulogd_output_XML_la_LDFLAGS = -avoid-version -module
-- 
1.7.1

