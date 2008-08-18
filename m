From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 01/06: Move linux/in.h and linux/in6.h inclusions outside of
Date: Mon, 18 Aug 2008 18:51:50 +0200 (MEST)
Message-ID: <20080818165149.18978.80469.sendpatchset@localhost.localdomain>
References: <20080818165147.18978.92208.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59341 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbYHRQvv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:51:51 -0400
In-Reply-To: <20080818165147.18978.92208.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: Move linux/in.h and linux/in6.h inclusions outside of #ifdef __KERNEL__

netfilter.h can't be used in userspace without including linux/in.h
and linux/in6.h first. netfilter.h includes its own linux/in.h and
linux/in6.h include statements, these are stripped by make
headers-install because they are inside #ifdef __KERNEL__ however.
Move them out to fix this.

Signed-off-by: Matt Kraai <kraai@ftbfs.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4f5e031a4fb1872eb30d473fef4706eddf58aa8f
tree 935aaca025e96dafbd80e80f2d482e519e9a2edb
parent 08013fa353fdcfc0a03cae805393abfc56722387
author Matt Kraai <kraai@ftbfs.org> Mon, 18 Aug 2008 13:17:03 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 18 Aug 2008 13:17:03 +0200

 include/linux/netfilter.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 0c5eb7e..6060e56 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -7,13 +7,13 @@
 #include <linux/net.h>
 #include <linux/netdevice.h>
 #include <linux/if.h>
-#include <linux/in.h>
-#include <linux/in6.h>
 #include <linux/wait.h>
 #include <linux/list.h>
 #include <net/net_namespace.h>
 #endif
 #include <linux/types.h>
+#include <linux/in.h>
+#include <linux/in6.h>
 #include <linux/compiler.h>
 
 /* Responses from hook functions. */
