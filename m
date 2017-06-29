From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 16/29] netfilter: nf_tables: allow large allocations for new sets
Date: Fri, 30 Jun 2017 00:53:14 +0200
Message-ID: <1498776807-11124-17-git-send-email-pablo@netfilter.org>
References: <1498776807-11124-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57650 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752362AbdF2Wxz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Jun 2017 18:53:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2023BBDF4F
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Jun 2017 00:53:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 081E3D1CAF
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Jun 2017 00:53:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E48AEDA46B
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Jun 2017 00:53:35 +0200 (CEST)
In-Reply-To: <1498776807-11124-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The new fixed size hashtable backend implementation may result in a
large array of buckets that would spew splats from mm. Update this code
to fall back on vmalloc in case the memory allocation order is too
costly.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2969016d8cad..bc8f03a53734 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -13,6 +13,7 @@
 #include <linux/list.h>
 #include <linux/skbuff.h>
 #include <linux/netlink.h>
+#include <linux/vmalloc.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
@@ -3054,10 +3055,11 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	if (ops->privsize != NULL)
 		size = ops->privsize(nla, &desc);
 
-	err = -ENOMEM;
-	set = kzalloc(sizeof(*set) + size + udlen, GFP_KERNEL);
-	if (set == NULL)
+	set = kvzalloc(sizeof(*set) + size + udlen, GFP_KERNEL);
+	if (!set) {
+		err = -ENOMEM;
 		goto err1;
+	}
 
 	nla_strlcpy(name, nla[NFTA_SET_NAME], sizeof(set->name));
 	err = nf_tables_set_alloc_name(&ctx, set, name);
@@ -3100,7 +3102,7 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 err3:
 	ops->destroy(set);
 err2:
-	kfree(set);
+	kvfree(set);
 err1:
 	module_put(ops->type->owner);
 	return err;
@@ -3110,7 +3112,7 @@ static void nft_set_destroy(struct nft_set *set)
 {
 	set->ops->destroy(set);
 	module_put(set->ops->type->owner);
-	kfree(set);
+	kvfree(set);
 }
 
 static void nf_tables_set_destroy(const struct nft_ctx *ctx, struct nft_set *set)
-- 
2.1.4

