From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] utils: indicate file and line on memory allocation errors
Date: Tue,  4 Nov 2014 14:29:53 +0100
Message-ID: <1415107793-5299-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53320 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234AbaKDN2N (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:28:13 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

For example:

 src/netlink.c:179: Memory allocation failure

This shouldn't happen, so this allows us to identify at what point the
memory allocation failure has happened. It may be helpful to identify
bugs.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/utils.h |    5 ++++-
 src/utils.c     |    4 ++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index cc5948c..15b2e39 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -76,7 +76,10 @@
 	(void) (&_max1 == &_max2);		\
 	_max1 > _max2 ? _max1 : _max2; })
 
-extern void memory_allocation_error(void) __noreturn;
+extern void __memory_allocation_error(const char *filename, uint32_t line) __noreturn;
+
+#define memory_allocation_error()		\
+	__memory_allocation_error(__FILE__, __LINE__);
 
 extern void xfree(const void *ptr);
 extern void *xmalloc(size_t size);
diff --git a/src/utils.c b/src/utils.c
index 96ff419..88708e7 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -18,9 +18,9 @@
 #include <nftables.h>
 #include <utils.h>
 
-void __noreturn memory_allocation_error(void)
+void __noreturn __memory_allocation_error(const char *filename, uint32_t line)
 {
-	fprintf(stderr, "Memory allocation failure\n");
+	fprintf(stderr, "%s:%u: Memory allocation failure\n", filename, line);
 	exit(NFT_EXIT_NOMEM);
 }
 
-- 
1.7.10.4

