From: Victor Julien <victor@inliniac.net>
Subject: [Ulogd2 PATCH 1/3] Remove configure check for libmnl, it is not used
Date: Fri,  5 Apr 2013 16:33:55 +0200
Message-ID: <1365172437-15042-2-git-send-email-victor@inliniac.net>
References: <1365172437-15042-1-git-send-email-victor@inliniac.net>
Cc: Victor Julien <victor@inliniac.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from static-27.netfusion.at ([83.215.238.27]:39534 "EHLO
	tulpe.vuurmuur.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161562Ab3DEOq0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Apr 2013 10:46:26 -0400
In-Reply-To: <1365172437-15042-1-git-send-email-victor@inliniac.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If libmnl is missing configure fails. However, the lib is not used nor
linked to.

---
 configure.ac |    1 -
 1 file changed, 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index c94704b..a439bee 100644
--- a/configure.ac
+++ b/configure.ac
@@ -49,7 +49,6 @@ AC_SUBST([regular_CFLAGS])
 
 dnl Check for the right nfnetlink version
 PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 1.0.1])
-PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
 AC_ARG_ENABLE(nflog,
        AS_HELP_STRING([--enable-nflog], [Enable nflog module [default=yes]]),,[enable_nflog=yes])
 AS_IF([test "x$enable_nflog" = "xyes"], [
-- 
1.7.10.4

