From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH] netfilter: ipset: Fix configure failure when --with-kmod=no
Date: Fri, 11 Oct 2013 16:41:12 +0200
Message-ID: <1381502472-12217-2-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
References: <1381502472-12217-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:46731 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab3JKOm5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Oct 2013 10:42:57 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id 975559FF14
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Oct 2013 15:42:56 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id wPbaywVXOcCp for <netfilter-devel@vger.kernel.org>;
	Fri, 11 Oct 2013 15:41:44 +0100 (BST)
In-Reply-To: <1381502472-12217-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

When configuring the sources to build without kernel modules, the path
to the kernel sources was not set and the kernel header files were still
checked.

Now, we do not check the kernel sources for compatibility if we're not
going to build any kernel modules.

Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
---
 configure.ac | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/configure.ac b/configure.ac
index 0eb1022..d56328c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -167,6 +167,8 @@ AC_CHECK_TYPES([union nf_inet_addr],,,[#include <linux/types.h>
 dnl Checks for functions
 AC_CHECK_FUNCS(gethostbyname2)
 
+if test "$BUILDKMOD" == "yes"
+then
 dnl Check kernel incompatibilities... Ugly like hell
 AC_MSG_CHECKING([kernel source for struct xt_action_param])
 if test -f $ksourcedir/include/linux/netfilter/x_tables.h && \
@@ -309,6 +311,7 @@ else
 	AC_MSG_RESULT(no)
 	AC_MSG_ERROR([Netns support is required in the Linux kernel tree])
 fi
+fi
 
 dnl Checks for compiler characteristics.
 dnl Check extra warning flags except
-- 
1.8.3.2

