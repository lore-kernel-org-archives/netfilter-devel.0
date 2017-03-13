From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2 nf] Revert "netfilter: nf_tables: add flush field to struct nft_set_iter"
Date: Mon, 13 Mar 2017 13:27:51 +0100
Message-ID: <1489408071-6123-2-git-send-email-pablo@netfilter.org>
References: <1489408071-6123-1-git-send-email-pablo@netfilter.org>
Cc: zlpnobody@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52754 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750952AbdCMM2C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Mar 2017 08:28:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 182DEB7101
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 13:27:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 00E91DA865
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 13:27:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7AF5EDA85D
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 13:27:56 +0100 (CET)
In-Reply-To: <1489408071-6123-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This reverts commit 1f48ff6c5393aa7fe290faf5d633164f105b0aa7.

This patch is not required anymore now that we keep a dummy list of
set elements in the bitmap set implementation, so revert this before
we forget this code has not clients.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 1 -
 net/netfilter/nf_tables_api.c     | 4 ----
 2 files changed, 5 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 2aa8a9d80fbe..07e5c9c4f316 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -203,7 +203,6 @@ struct nft_set_elem {
 struct nft_set;
 struct nft_set_iter {
 	u8		genmask;
-	bool		flush;
 	unsigned int	count;
 	unsigned int	skip;
 	int		err;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5e0ccfd5bb37..434c739dfeca 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3145,7 +3145,6 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 		iter.count	= 0;
 		iter.err	= 0;
 		iter.fn		= nf_tables_bind_check_setelem;
-		iter.flush	= false;
 
 		set->ops->walk(ctx, set, &iter);
 		if (iter.err < 0)
@@ -3399,7 +3398,6 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	args.iter.count		= 0;
 	args.iter.err		= 0;
 	args.iter.fn		= nf_tables_dump_setelem;
-	args.iter.flush		= false;
 	set->ops->walk(&ctx, set, &args.iter);
 
 	nla_nest_end(skb, nest);
@@ -3963,7 +3961,6 @@ static int nf_tables_delsetelem(struct net *net, struct sock *nlsk,
 		struct nft_set_iter iter = {
 			.genmask	= genmask,
 			.fn		= nft_flush_set,
-			.flush		= true,
 		};
 		set->ops->walk(&ctx, set, &iter);
 
@@ -5114,7 +5111,6 @@ static int nf_tables_check_loops(const struct nft_ctx *ctx,
 			iter.count	= 0;
 			iter.err	= 0;
 			iter.fn		= nf_tables_loop_check_setelem;
-			iter.flush	= false;
 
 			set->ops->walk(ctx, set, &iter);
 			if (iter.err < 0)
-- 
2.1.4

