From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 6/6] nfnl_osf: add missing libnfnetlink_CFLAGS to compile process
Date: Fri, 30 Dec 2011 02:35:01 +0100
Message-ID: <1325208902-2014-7-git-send-email-jengelh@medozas.de>
References: <1325208902-2014-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40855 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354Ab1L3BfO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Dec 2011 20:35:14 -0500
In-Reply-To: <1325208902-2014-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 utils/Makefile.am |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/utils/Makefile.am b/utils/Makefile.am
index 306d993..f1bbfc5 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -1,7 +1,8 @@
 # -*- Makefile -*-
 
 AM_CFLAGS = ${regular_CFLAGS}
-AM_CPPFLAGS = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_srcdir}/include
+AM_CPPFLAGS = ${regular_CPPFLAGS} -I${top_builddir}/include \
+              -I${top_srcdir}/include ${libnfnetlink_CFLAGS}
 
 sbin_PROGRAMS = nfnl_osf
 pkgdata_DATA = pf.os
-- 
1.7.3.4

