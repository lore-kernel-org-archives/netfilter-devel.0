From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [iptables PATCH] configure: exit if libnftnl is not found
Date: Sun, 27 Mar 2016 12:05:46 +0200
Message-ID: <1459073146-11576-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36681 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbcC0KFv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Mar 2016 06:05:51 -0400
Received: by mail-wm0-f67.google.com with SMTP id l68so14177325wml.3
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Mar 2016 03:05:51 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

iptables building is broken if libnftnl is not installed
on the system, raising up the following errors:

nft-shared.c:25:27: fatal error: libnftnl/rule.h: No such file or directory
 #include <libnftnl/rule.h>
                           ^
compilation terminated.
nft.c:41:28: fatal error: libnftnl/table.h: No such file or directory
 #include <libnftnl/table.h>
                            ^
compilation terminated.
mv -f .deps/xtables_multi-iptables-restore.Tpo .deps/xtables_multi-iptables-restore.Po
In file included from nft.h:5:0,
                 from nft-ipv6.c:25:
nft-shared.h:6:27: fatal error: libnftnl/rule.h: No such file or directory
 #include <libnftnl/rule.h>
                           ^
mv -f .deps/xtables_multi-xshared.Tpo .deps/xtables_multi-xshared.Po
compilation terminated.
In file included from nft.h:5:0,
                 from nft-ipv4.c:26:
nft-shared.h:6:27: fatal error: libnftnl/rule.h: No such file or directory
 #include <libnftnl/rule.h>

configure script checks if libnftnl is installed, but doesn't
exit if it is not.

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 configure.ac | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/configure.ac b/configure.ac
index 33a8f2d..b08ecca 100644
--- a/configure.ac
+++ b/configure.ac
@@ -128,6 +128,13 @@ if test "x$enable_nftables" = "xyes"; then
 
 	PKG_CHECK_MODULES([libnftnl], [libnftnl >= 1.0.5], [nftables=1], [nftables=0])
 
+	if test "$nftables" = 0;
+	then
+		echo "*** Error: No suitable libnftnl found. ***"
+		echo "    Please install the 'libnftnl' package."
+		exit 1
+	fi
+
 	AM_PROG_LEX
 	AC_PROG_YACC
 
-- 
2.5.0

