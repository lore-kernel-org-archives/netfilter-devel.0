From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libmnl] example: netfilter: get rid of aligned_be64 definitions
Date: Mon, 25 May 2015 20:51:09 +0200
Message-ID: <1432579869-8004-1-git-send-email-pablo@netfilter.org>
Cc: felix.janda@posteo.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34004 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbbEYSqK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 May 2015 14:46:10 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is defined in <linux/types.h>, which is included by the nfnetlink_* header
files.

Thus, we can get rid of u_int64_t which causes problems to musl according to
Felix Janda.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 examples/netfilter/nf-log.c   |    5 -----
 examples/netfilter/nf-queue.c |    5 -----
 2 files changed, 10 deletions(-)

diff --git a/examples/netfilter/nf-log.c b/examples/netfilter/nf-log.c
index 901bd80..4383b66 100644
--- a/examples/netfilter/nf-log.c
+++ b/examples/netfilter/nf-log.c
@@ -9,11 +9,6 @@
 #include <libmnl/libmnl.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nfnetlink.h>
-
-#ifndef aligned_be64
-#define aligned_be64 u_int64_t __attribute__((aligned(8)))
-#endif
-
 #include <linux/netfilter/nfnetlink_log.h>
 
 static int parse_attr_cb(const struct nlattr *attr, void *data)
diff --git a/examples/netfilter/nf-queue.c b/examples/netfilter/nf-queue.c
index 72779f0..957e365 100644
--- a/examples/netfilter/nf-queue.c
+++ b/examples/netfilter/nf-queue.c
@@ -9,11 +9,6 @@
 #include <libmnl/libmnl.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nfnetlink.h>
-
-#ifndef aligned_be64
-#define aligned_be64 u_int64_t __attribute__((aligned(8)))
-#endif
-
 #include <linux/netfilter/nfnetlink_queue.h>
 
 static int parse_attr_cb(const struct nlattr *attr, void *data)
-- 
1.7.10.4

