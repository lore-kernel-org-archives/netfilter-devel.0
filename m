From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 7/9] netfilter: nf_tables: allow large allocations for new sets
Date: Wed, 24 May 2017 11:50:51 +0200
Message-ID: <1495619453-22307-8-git-send-email-pablo@netfilter.org>
References: <1495619453-22307-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41524 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938640AbdEXJvx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 May 2017 05:51:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 183541EC2CA
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 11:51:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 08746FF6F9
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 11:51:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E54BDFF2CE
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 11:51:00 +0200 (CEST)
In-Reply-To: <1495619453-22307-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The new fixed size hashtable backend implementation may result in a
large array of buckets that would spew splats from mm. Update this code
to fall back on vmalloc in case the memory allocation order is too
costly.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2969016d8cad..0e54090caa8a 100644
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
@@ -2909,13 +2910,13 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u8 genmask = nft_genmask_next(net);
+	unsigned int size, alloc_size;
 	const struct nft_set_ops *ops;
 	struct nft_af_info *afi;
 	struct nft_table *table;
 	struct nft_set *set;
 	struct nft_ctx ctx;
 	char name[NFT_SET_MAXNAMELEN];
-	unsigned int size;
 	bool create;
 	u64 timeout;
 	u32 ktype, dtype, flags, policy, gc_int, objtype;
@@ -3031,6 +3032,8 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	if (IS_ERR(set)) {
 		if (PTR_ERR(set) != -ENOENT)
 			return PTR_ERR(set);
+
+		set = NULL;
 	} else {
 		if (nlh->nlmsg_flags & NLM_F_EXCL)
 			return -EEXIST;
@@ -3054,10 +3057,16 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	if (ops->privsize != NULL)
 		size = ops->privsize(nla, &desc);
 
-	err = -ENOMEM;
-	set = kzalloc(sizeof(*set) + size + udlen, GFP_KERNEL);
+	alloc_size = sizeof(*set) + size + udlen;
+	if (alloc_size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER))
+		set = kzalloc(alloc_size, GFP_KERNEL | __GFP_NOWARN |
+					  __GFP_NORETRY);
 	if (set == NULL)
+		set = vzalloc(alloc_size);
+	if (set == NULL) {
+		err = -ENOMEM;
 		goto err1;
+	}
 
 	nla_strlcpy(name, nla[NFTA_SET_NAME], sizeof(set->name));
 	err = nf_tables_set_alloc_name(&ctx, set, name);
@@ -3100,7 +3109,7 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 err3:
 	ops->destroy(set);
 err2:
-	kfree(set);
+	kvfree(set);
 err1:
 	module_put(ops->type->owner);
 	return err;
@@ -3110,7 +3119,7 @@ static void nft_set_destroy(struct nft_set *set)
 {
 	set->ops->destroy(set);
 	module_put(set->ops->type->owner);
-	kfree(set);
+	kvfree(set);
 }
 
 static void nf_tables_set_destroy(const struct nft_ctx *ctx, struct nft_set *set)
-- 
2.1.4

