From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/4] build: use -Wall across the entire source
Date: Fri, 31 Dec 2010 00:41:40 +0100
Message-ID: <1293752503-13178-3-git-send-email-jengelh@medozas.de>
References: <1293752503-13178-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43761 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab0L3Xlq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:41:46 -0500
In-Reply-To: <1293752503-13178-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Make_global.am            |    1 +
 src/Makefile.am           |    2 --
 src/conntrack/Makefile.am |    2 --
 src/expect/Makefile.am    |    2 --
 4 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index 955a626..00bde49 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -5,3 +5,4 @@
 LIBVERSION=3:2:0
 
 AM_CPPFLAGS = -I$(top_srcdir)/include
+AM_CFLAGS = -Wall ${LIBNFNETLINK_CFLAGS}
diff --git a/src/Makefile.am b/src/Makefile.am
index 82030c4..a6d3343 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -6,8 +6,6 @@ include $(top_srcdir)/Make_global.am
 
 SUBDIRS=conntrack expect
 
-AM_CFLAGS = -Wall ${LIBNFNETLINK_CFLAGS}
-
 lib_LTLIBRARIES = libnetfilter_conntrack.la 
 
 libnetfilter_conntrack_la_LIBADD = conntrack/libnfconntrack.la \
diff --git a/src/conntrack/Makefile.am b/src/conntrack/Makefile.am
index 34afefb..fb6b048 100644
--- a/src/conntrack/Makefile.am
+++ b/src/conntrack/Makefile.am
@@ -1,7 +1,5 @@
 include $(top_srcdir)/Make_global.am
 
-AM_CFLAGS = -Wall ${LIBNFNETLINK_CFLAGS}
-
 noinst_LTLIBRARIES = libnfconntrack.la 
 
 libnfconntrack_la_SOURCES = api.c \
diff --git a/src/expect/Makefile.am b/src/expect/Makefile.am
index 380befa..8adf740 100644
--- a/src/expect/Makefile.am
+++ b/src/expect/Makefile.am
@@ -1,7 +1,5 @@
 include $(top_srcdir)/Make_global.am
 
-AM_CFLAGS = -Wall ${LIBNFNETLINK_CFLAGS}
-
 noinst_LTLIBRARIES = libnfexpect.la 
 
 libnfexpect_la_SOURCES = api.c \
-- 
1.7.1

