From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/5] build: remove unnecessary AC_EXEEXT
Date: Thu, 29 Dec 2011 22:24:47 +0100
Message-ID: <1325193891-20905-3-git-send-email-jengelh@medozas.de>
References: <1325193891-20905-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59711 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986Ab1L2VYz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Dec 2011 16:24:55 -0500
In-Reply-To: <1325193891-20905-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

${EXEEXT} is nowhere used in Makefiles.
---
 configure.ac |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/configure.ac b/configure.ac
index 98d163c..56c033b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -17,7 +17,6 @@ PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.0])
 
 AC_PROG_CC
 AM_PROG_CC_C_O
-AC_EXEEXT
 AC_DISABLE_STATIC
 LT_INIT
 CHECK_GCC_FVISIBILITY
-- 
1.7.3.4

