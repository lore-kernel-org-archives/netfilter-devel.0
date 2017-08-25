From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nf-next] net: netfilter: Remove NFDEBUG.
Date: Fri, 25 Aug 2017 16:11:12 +0530
Message-ID: <20170825104112.2620-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34137 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754518AbdHYKlf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Aug 2017 06:41:35 -0400
Received: by mail-pg0-f66.google.com with SMTP id 63so3403372pgc.1
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Aug 2017 03:41:34 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove NFDEBUG and use pr_debug() instead of it.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 net/netfilter/nf_internals.h | 6 ------
 net/netfilter/nf_sockopt.c   | 2 +-
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/net/netfilter/nf_internals.h b/net/netfilter/nf_internals.h
index 19f00a47a710..e40016742530 100644
--- a/net/netfilter/nf_internals.h
+++ b/net/netfilter/nf_internals.h
@@ -5,12 +5,6 @@
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 
-#ifdef CONFIG_NETFILTER_DEBUG
-#define NFDEBUG(format, args...)  printk(KERN_DEBUG format , ## args)
-#else
-#define NFDEBUG(format, args...)
-#endif
-
 /* nf_queue.c */
 int nf_queue(struct sk_buff *skb, struct nf_hook_state *state,
 	     struct nf_hook_entry **entryp, unsigned int verdict);
diff --git a/net/netfilter/nf_sockopt.c b/net/netfilter/nf_sockopt.c
index c68c1e58b362..d2a9e6b5d01f 100644
--- a/net/netfilter/nf_sockopt.c
+++ b/net/netfilter/nf_sockopt.c
@@ -33,7 +33,7 @@ int nf_register_sockopt(struct nf_sockopt_ops *reg)
 				reg->set_optmin, reg->set_optmax)
 			|| overlap(ops->get_optmin, ops->get_optmax,
 				   reg->get_optmin, reg->get_optmax))) {
-			NFDEBUG("nf_sock overlap: %u-%u/%u-%u v %u-%u/%u-%u\n",
+			pr_debug("nf_sock overlap: %u-%u/%u-%u v %u-%u/%u-%u\n",
 				ops->set_optmin, ops->set_optmax,
 				ops->get_optmin, ops->get_optmax,
 				reg->set_optmin, reg->set_optmax,
-- 
2.13.5

