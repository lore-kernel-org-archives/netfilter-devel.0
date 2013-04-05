From: Victor Julien <victor@inliniac.net>
Subject: [Ulogd2 PATCH 2/3] Lower libnfnetlink requirement to 1.0.0
Date: Fri,  5 Apr 2013 16:33:56 +0200
Message-ID: <1365172437-15042-3-git-send-email-victor@inliniac.net>
References: <1365172437-15042-1-git-send-email-victor@inliniac.net>
Cc: Victor Julien <victor@inliniac.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from static-27.netfusion.at ([83.215.238.27]:39534 "EHLO
	tulpe.vuurmuur.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161852Ab3DEOq1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Apr 2013 10:46:27 -0400
In-Reply-To: <1365172437-15042-1-git-send-email-victor@inliniac.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Build and run tested against 1.0.0, worked fine for me.

---
 configure.ac |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index a439bee..5755cf5 100644
--- a/configure.ac
+++ b/configure.ac
@@ -48,7 +48,7 @@ regular_CFLAGS="-Wall -Wextra -Wno-unused-parameter"
 AC_SUBST([regular_CFLAGS])
 
 dnl Check for the right nfnetlink version
-PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 1.0.1])
+PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 1.0.0])
 AC_ARG_ENABLE(nflog,
        AS_HELP_STRING([--enable-nflog], [Enable nflog module [default=yes]]),,[enable_nflog=yes])
 AS_IF([test "x$enable_nflog" = "xyes"], [
-- 
1.7.10.4

