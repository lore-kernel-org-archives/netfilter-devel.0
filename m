From: Victor Julien <victor@inliniac.net>
Subject: [Ulogd2 PATCH 3/3] Lower libnetfilter_conntrack requirement to 0.9.1
Date: Fri,  5 Apr 2013 16:33:57 +0200
Message-ID: <1365172437-15042-4-git-send-email-victor@inliniac.net>
References: <1365172437-15042-1-git-send-email-victor@inliniac.net>
Cc: Victor Julien <victor@inliniac.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from static-27.netfusion.at ([83.215.238.27]:39534 "EHLO
	tulpe.vuurmuur.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161852Ab3DEOq2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Apr 2013 10:46:28 -0400
In-Reply-To: <1365172437-15042-1-git-send-email-victor@inliniac.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Build tested, no warnings.

---
 configure.ac |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 5755cf5..b17ecb6 100644
--- a/configure.ac
+++ b/configure.ac
@@ -59,7 +59,7 @@ AM_CONDITIONAL([BUILD_NFLOG], [test "x$enable_nflog" = "xyes"])
 AC_ARG_ENABLE(nfct,
        AS_HELP_STRING([--enable-nfct], [Enable nfct module [default=yes]]),,[enable_nfct=yes])
 AS_IF([test "x$enable_nfct" = "xyes"], [
-    PKG_CHECK_MODULES([LIBNETFILTER_CONNTRACK], [libnetfilter_conntrack >= 1.0.2])
+    PKG_CHECK_MODULES([LIBNETFILTER_CONNTRACK], [libnetfilter_conntrack >= 0.9.1])
     AC_DEFINE([BUILD_NFCT], [1], [Building nfct module])
 ])
 AM_CONDITIONAL([BUILD_NFCT], [test "x$enable_nfct" = "xyes"])
-- 
1.7.10.4

