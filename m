From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/5] build: add missing LIBMNL_CFLAGS to compilation process
Date: Thu, 29 Dec 2011 22:24:50 +0100
Message-ID: <1325193891-20905-6-git-send-email-jengelh@medozas.de>
References: <1325193891-20905-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59725 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986Ab1L2VY6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Dec 2011 16:24:58 -0500
In-Reply-To: <1325193891-20905-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Otherwise, the preprocessor may fail to find libmnl if it is not in a
standard-searched directory.
---
 Make_global.am |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index caab49a..1654f10 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -20,5 +20,5 @@
 #
 LIBVERSION=0:0:0
 
-AM_CPPFLAGS = ${regular_CPPFLAGS} -I${top_srcdir}/include
+AM_CPPFLAGS = ${regular_CPPFLAGS} -I${top_srcdir}/include ${LIBMNL_CFLAGS}
 AM_CFLAGS = ${regular_CFLAGS} ${GCC_FVISIBILITY_HIDDEN}
-- 
1.7.3.4

