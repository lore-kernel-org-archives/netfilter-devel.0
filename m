From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/4] build: use -Wall across the entire source
Date: Fri, 31 Dec 2010 00:42:14 +0100
Message-ID: <1293752536-13491-4-git-send-email-jengelh@medozas.de>
References: <1293752536-13491-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43795 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412Ab0L3XmV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:42:21 -0500
In-Reply-To: <1293752536-13491-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Make_global.am  |    1 +
 src/Makefile.am |    2 --
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index e0fc5fb..b7dab7b 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -1 +1,2 @@
 AM_CPPFLAGS = -I${top_srcdir}/include
+AM_CFLAGS = -Wall ${LIBNFNETLINK_CFLAGS}
diff --git a/src/Makefile.am b/src/Makefile.am
index 23f0a07..10a66e2 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -22,8 +22,6 @@ LIBVERSION=2:0:1
 
 include ${top_srcdir}/Make_global.am
 
-AM_CFLAGS = -Wall ${LIBNFNETLINK_CFLAGS}
-
 lib_LTLIBRARIES = libnetfilter_log.la libnetfilter_log_libipulog.la
 
 libnetfilter_log_la_LDFLAGS = -Wc,-nostartfiles -lnfnetlink	\
-- 
1.7.1

