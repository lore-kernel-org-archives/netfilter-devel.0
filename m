From: Victor Julien <victor@inliniac.net>
Subject: [Ulog2 PATCH] Exec libmnl config check only if nfacct is enabled
Date: Fri,  5 Apr 2013 18:28:14 +0200
Message-ID: <1365179294-24481-1-git-send-email-victor@inliniac.net>
Cc: Victor Julien <victor@inliniac.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from static-27.netfusion.at ([83.215.238.27]:39549 "EHLO
	tulpe.vuurmuur.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161984Ab3DEQ2e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:28:34 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In case nfacct is not enabled in ulogd2, libmnl is not used. So it shouldn't
be a hard global dependency, but instead only a dependency in case nfacct is
enabled.
---
 configure.ac |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index c94704b..54a08aa 100644
--- a/configure.ac
+++ b/configure.ac
@@ -49,7 +49,6 @@ AC_SUBST([regular_CFLAGS])
 
 dnl Check for the right nfnetlink version
 PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 1.0.1])
-PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
 AC_ARG_ENABLE(nflog,
        AS_HELP_STRING([--enable-nflog], [Enable nflog module [default=yes]]),,[enable_nflog=yes])
 AS_IF([test "x$enable_nflog" = "xyes"], [
@@ -67,6 +66,7 @@ AM_CONDITIONAL([BUILD_NFCT], [test "x$enable_nfct" = "xyes"])
 AC_ARG_ENABLE(nfacct,
        AS_HELP_STRING([--enable-nfacct], [Enable nfacct module [default=yes]]),,[enable_nfacct=yes])
 AS_IF([test "x$enable_nfacct" = "xyes"], [
+    PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
     PKG_CHECK_MODULES([LIBNETFILTER_ACCT], [libnetfilter_acct >= 1.0.1])
     AC_DEFINE([BUILD_NFACCT], [1], [Building nfacct module])
 ])
-- 
1.7.10.4

