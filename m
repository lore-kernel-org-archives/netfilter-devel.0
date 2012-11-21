From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH] build: support for Linux 3.7 UAPI
Date: Thu, 22 Nov 2012 00:05:42 +0100
Message-ID: <1353539142-31631-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:32808 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965019Ab2KVTOJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:14:09 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In Linux 3.7, nfnetlink.h moved below include/uapi/. Make configure
recognize that. Furthermore, we can drop the unnecessary indirection
via backticks and just ask grep directly if there was any result.
---
Also available via

	git://git.inai.de/ipset master

 configure.ac |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 7a6aa33..dea392d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -68,7 +68,8 @@ fi
 
 AC_PROG_GREP
 
-if test "X`$GREP 'NFNL_SUBSYS_IPSET' $ksourcedir/include/linux/netfilter/nfnetlink.h`" = "X"
+if ! $GREP -q "NFNL_SUBSYS_IPSET" "$ksourcedir/include/linux/netfilter/nfnetlink.h" && \
+   ! $GREP -q "NFNL_SUBSYS_IPSET" "$ksourcedir/include/uapi/linux/netfilter/nfnetlink.h";
 then
 	AC_MSG_ERROR([The kernel source directory $ksourcedir is not patched with netlink.patch to support ipset])
 fi
-- 
1.7.10.4

