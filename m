From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 1/2] build: avoid per-target CFLAGS
Date: Tue, 27 Nov 2012 13:49:05 +0100
Message-ID: <1354020546-4799-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: eric@regit.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:50806 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab2K0MtJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2012 07:49:09 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There is no harm in putting the includes in the global AM_CPPFLAGS;
this can generally save number of compilations of a file when a
source file is used multiple times.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
Available in
	git://git.inai.de/ulogd master

 input/flow/Makefile.am   |    3 +--
 input/packet/Makefile.am |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/input/flow/Makefile.am b/input/flow/Makefile.am
index 36c34ca..0e07a7d 100644
--- a/input/flow/Makefile.am
+++ b/input/flow/Makefile.am
@@ -1,5 +1,5 @@
 
-AM_CPPFLAGS = -I$(top_srcdir)/include
+AM_CPPFLAGS = -I$(top_srcdir)/include ${LIBNETFILTER_CONNTRACK_CFLAGS}
 AM_CFLAGS = ${regular_CFLAGS}
 
 if BUILD_NFCT
@@ -7,7 +7,6 @@ pkglib_LTLIBRARIES = ulogd_inpflow_NFCT.la # ulogd_inpflow_IPFIX.la
 
 ulogd_inpflow_NFCT_la_SOURCES = ulogd_inpflow_NFCT.c
 ulogd_inpflow_NFCT_la_LDFLAGS = -avoid-version -module $(LIBNETFILTER_CONNTRACK_LIBS)
-ulogd_inpflow_NFCT_la_CFLAGS = $(AM_CFLAGS) $(LIBNETFILTER_CONNTRACK_CFLAGS)
 endif
 
 #ulogd_inpflow_IPFIX_la_SOURCES = ulogd_inpflow_IPFIX.c
diff --git a/input/packet/Makefile.am b/input/packet/Makefile.am
index debea91..1c884b8 100644
--- a/input/packet/Makefile.am
+++ b/input/packet/Makefile.am
@@ -1,5 +1,5 @@
 
-AM_CPPFLAGS = -I$(top_srcdir)/include
+AM_CPPFLAGS = -I$(top_srcdir)/include ${LIBNETFILTER_LOG_CFLAGS}
 AM_CFLAGS = ${regular_CFLAGS}
 
 pkglib_LTLIBRARIES = ulogd_inppkt_ULOG.la ulogd_inppkt_UNIXSOCK.la
@@ -9,7 +9,6 @@ endif
 
 ulogd_inppkt_NFLOG_la_SOURCES = ulogd_inppkt_NFLOG.c
 ulogd_inppkt_NFLOG_la_LDFLAGS = -avoid-version -module $(LIBNETFILTER_LOG_LIBS)
-ulogd_inppkt_NFLOG_la_CFLAGS = $(AM_CFLAGS) $(LIBNETFILTER_LOG_CFLAGS)
 
 ulogd_inppkt_ULOG_la_SOURCES = ulogd_inppkt_ULOG.c
 ulogd_inppkt_ULOG_la_LDFLAGS = -avoid-version -module
-- 
1.7.10.4

