From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/4] build: create a Make_global.am file
Date: Fri, 31 Dec 2010 00:42:13 +0100
Message-ID: <1293752536-13491-3-git-send-email-jengelh@medozas.de>
References: <1293752536-13491-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43789 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412Ab0L3XmT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:42:19 -0500
In-Reply-To: <1293752536-13491-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Just like the other Netfilter libraries.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Make_global.am    |    1 +
 src/Makefile.am   |    3 ++-
 utils/Makefile.am |    2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)
 create mode 100644 Make_global.am

diff --git a/Make_global.am b/Make_global.am
new file mode 100644
index 0000000..e0fc5fb
--- /dev/null
+++ b/Make_global.am
@@ -0,0 +1 @@
+AM_CPPFLAGS = -I${top_srcdir}/include
diff --git a/src/Makefile.am b/src/Makefile.am
index e78faa8..23f0a07 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -20,7 +20,8 @@
 #
 LIBVERSION=2:0:1
 
-AM_CPPFLAGS = -I$(top_srcdir)/include
+include ${top_srcdir}/Make_global.am
+
 AM_CFLAGS = -Wall ${LIBNFNETLINK_CFLAGS}
 
 lib_LTLIBRARIES = libnetfilter_log.la libnetfilter_log_libipulog.la
diff --git a/utils/Makefile.am b/utils/Makefile.am
index b6c333b..ae64c90 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -1,4 +1,4 @@
-AM_CPPFLAGS = -I$(top_srcdir)/include
+include ${top_srcdir}/Make_global.am
 
 check_PROGRAMS = nfulnl_test ulog_test
 
-- 
1.7.1

