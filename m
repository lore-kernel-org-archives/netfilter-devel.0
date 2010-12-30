From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/3] build: create a Make_global.am file
Date: Fri, 31 Dec 2010 00:42:53 +0100
Message-ID: <1293752575-13611-3-git-send-email-jengelh@medozas.de>
References: <1293752575-13611-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43819 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734Ab0L3Xm7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:42:59 -0500
In-Reply-To: <1293752575-13611-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Make_global.am    |    1 +
 src/Makefile.am   |    2 +-
 utils/Makefile.am |    3 +--
 3 files changed, 3 insertions(+), 3 deletions(-)
 create mode 100644 Make_global.am

diff --git a/Make_global.am b/Make_global.am
new file mode 100644
index 0000000..fb31d42
--- /dev/null
+++ b/Make_global.am
@@ -0,0 +1 @@
+AM_CPPFLAGS = -I${top_srcdir}/include -I${KERNELDIR}
diff --git a/src/Makefile.am b/src/Makefile.am
index a745129..84892eb 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -20,7 +20,7 @@
 #
 LIBVERSION=2:0:1
 
-AM_CPPFLAGS = -I$(top_srcdir)/include -I${KERNELDIR}
+include ${top_srcdir}/Make_global.am
 AM_CFLAGS = -Wall ${LIBNFNETLINK_CFLAGS}
 
 lib_LTLIBRARIES = libnetfilter_queue.la
diff --git a/utils/Makefile.am b/utils/Makefile.am
index 1f52864..d3147e3 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -1,5 +1,4 @@
-
-AM_CPPFLAGS = -I$(top_srcdir)/include -I${KERNELDIR}
+include ${top_srcdir}/Make_global.am
 
 check_PROGRAMS = nfqnl_test
 
-- 
1.7.1

