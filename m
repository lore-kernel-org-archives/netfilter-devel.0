From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [iptables PATCH] configure: make libmnl and libnftnl hard requirements
Date: Tue, 26 Apr 2016 21:27:58 +0200
Message-ID: <1461698878-4459-1-git-send-email-giuseppe@glongo.it>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35301 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbcDZT2D (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Apr 2016 15:28:03 -0400
Received: by mail-wm0-f68.google.com with SMTP id e201so7006005wme.2
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Apr 2016 12:28:02 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Giuseppe Longo <giuseppelng@gmail.com>

Iptables building is broken if either libmnl orlibnftnl
is not installed on the system.

Configure script actually checks if libmnl and libnftnl are installed,
but doesn't exit if they are not.

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 configure.ac | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/configure.ac b/configure.ac
index 12bffa9..b170add 100644
--- a/configure.ac
+++ b/configure.ac
@@ -122,8 +122,26 @@ AM_CONDITIONAL([HAVE_LIBNFNETLINK], [test "$nfnetlink" = 1])
 if test "x$enable_nftables" = "xyes"; then
 	PKG_CHECK_MODULES([libmnl], [libmnl >= 1.0], [mnl=1], [mnl=0])
 
+	if test "$mnl" = 0;
+	then
+		echo "*** Error: No suitable libmnl found. ***"
+		echo "    Please install the 'libmnl' package"
+		echo "    Or consider --disable-nftables to skip"
+		echo "    iptables-compat over nftables support."
+		exit 1
+	fi
+
 	PKG_CHECK_MODULES([libnftnl], [libnftnl >= 1.0.5], [nftables=1], [nftables=0])
 
+	if test "$nftables" = 0;
+	then
+		echo "*** Error: no suitable libnftnl found. ***"
+		echo "    Please install the 'libnftnl' package"
+		echo "    Or consider --disable-nftables to skip"
+		echo "    iptables-compat over nftables support."
+		exit 1
+	fi
+
 	AM_PROG_LEX
 	AC_PROG_YACC
 
-- 
2.5.0

