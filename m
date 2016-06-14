From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Re: [PATCH nf-next 2/3] netfilter: nf_tables: fix a endless jump
 loop when use vmap
Date: Tue, 14 Jun 2016 17:38:51 +0200
Message-ID: <20160614153851.GA4582@salvia>
References: <1465618828-22162-1-git-send-email-zlpnobody@163.com>
 <1465618828-22162-3-git-send-email-zlpnobody@163.com>
 <20160613181902.GA2699@salvia>
 <6baeab0c.14c4e.1554ecf5f06.Coremail.zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="SLDf9lqlvOQaIe6s"
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59280 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbcFNPi7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jun 2016 11:38:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 970854BCCC
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 17:38:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8405C9EBA3
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 17:38:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2F2939EBB2
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 17:38:52 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <6baeab0c.14c4e.1554ecf5f06.Coremail.zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 14, 2016 at 08:07:41PM +0800, Liping Zhang wrote:
> Hi pablo,
> 
> At 2016-06-14 02:19:02, "Pablo Neira Ayuso" <pablo@netfilter.org> wrote:
> >On Sat, Jun 11, 2016 at 12:20:27PM +0800, Liping Zhang wrote:
> >
> >Thanks for tracking down and fixing this one.
> >
> >I've made a new version based on your original patch, find it
> >attached.
> >
> >Basically, the idea is to pass the genmask through iter, so we can
> >perform the conditional check based on whether 1) we're dumping or
> >2) checking for loops (ie. in the middle of a transaction).
> >
> >Let me know if you see any problem with this different approach,
> >thanks.
> 
> I think your patch is better than mine. I also test it, it works well.
> 
> Tested-by: Liping Zhang <liping.zhang@spreadtrum.com>

Thanks, I'm attaching a v2. I noticed I can simplify the previous
patch by using ctx->net. Will push this (and your patches) upstream
asap.

--SLDf9lqlvOQaIe6s
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-nf_tables-reject-loops-from-set-element-ju.patch"

>From e067bde1535ca78d9c8fea9f49f86c0731274732 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sat, 11 Jun 2016 12:20:27 +0800
Subject: [PATCH] netfilter: nf_tables: reject loops from set element jump to
 chain

Liping Zhang says:

"Users may add such a wrong nft rules successfully, which will cause an
endless jump loop:

  # nft add rule filter test tcp dport vmap {1: jump test}

This is because before we commit, the element in the current anonymous
set is inactive, so osp->walk will skip this element and miss the
validate check."

To resolve this problem, this patch passes the generation mask to the
walk function through the iter container structure depending on the code
path:

1) If we're dumping the elements, then we have to check if the element
   is active in the current generation. Thus, we check for the current
   bit in the genmask.

2) If we're checking for loops, then we have to check if the element is
   active in the next generation, as we're in the middle of a
   transaction. Thus, we check for the next bit in the genmask.

Based on original patch from Liping Zhang.

Reported-by: Liping Zhang <liping.zhang@spreadtrum.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Tested-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
v2: Simplify previous patch through using ctx->net instead of set_pnet().

 include/net/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c     | 15 +++++++++------
 net/netfilter/nft_hash.c          |  3 +--
 net/netfilter/nft_rbtree.c        |  3 +--
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 0922354..f7c291f 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -167,6 +167,7 @@ struct nft_set_elem {
 
 struct nft_set;
 struct nft_set_iter {
+	u8		genmask;
 	unsigned int	count;
 	unsigned int	skip;
 	int		err;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 492f6f8..0fd6998 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2951,6 +2951,7 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 				goto bind;
 		}
 
+		iter.genmask	= nft_genmask_next(ctx->net);
 		iter.skip 	= 0;
 		iter.count	= 0;
 		iter.err	= 0;
@@ -3192,12 +3193,13 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	if (nest == NULL)
 		goto nla_put_failure;
 
-	args.cb		= cb;
-	args.skb	= skb;
-	args.iter.skip	= cb->args[0];
-	args.iter.count	= 0;
-	args.iter.err   = 0;
-	args.iter.fn	= nf_tables_dump_setelem;
+	args.cb			= cb;
+	args.skb		= skb;
+	args.iter.genmask	= nft_genmask_cur(ctx.net);
+	args.iter.skip		= cb->args[0];
+	args.iter.count		= 0;
+	args.iter.err		= 0;
+	args.iter.fn		= nf_tables_dump_setelem;
 	set->ops->walk(&ctx, set, &args.iter);
 
 	nla_nest_end(skb, nest);
@@ -4284,6 +4286,7 @@ static int nf_tables_check_loops(const struct nft_ctx *ctx,
 			    binding->chain != chain)
 				continue;
 
+			iter.genmask	= nft_genmask_next(ctx->net);
 			iter.skip 	= 0;
 			iter.count	= 0;
 			iter.err	= 0;
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index 6fa0165..f39c53a 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -189,7 +189,6 @@ static void nft_hash_walk(const struct nft_ctx *ctx, const struct nft_set *set,
 	struct nft_hash_elem *he;
 	struct rhashtable_iter hti;
 	struct nft_set_elem elem;
-	u8 genmask = nft_genmask_cur(read_pnet(&set->pnet));
 	int err;
 
 	err = rhashtable_walk_init(&priv->ht, &hti, GFP_KERNEL);
@@ -218,7 +217,7 @@ static void nft_hash_walk(const struct nft_ctx *ctx, const struct nft_set *set,
 			goto cont;
 		if (nft_set_elem_expired(&he->ext))
 			goto cont;
-		if (!nft_set_elem_active(&he->ext, genmask))
+		if (!nft_set_elem_active(&he->ext, iter->genmask))
 			goto cont;
 
 		elem.priv = he;
diff --git a/net/netfilter/nft_rbtree.c b/net/netfilter/nft_rbtree.c
index f762094..7201d57 100644
--- a/net/netfilter/nft_rbtree.c
+++ b/net/netfilter/nft_rbtree.c
@@ -211,7 +211,6 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 	struct nft_rbtree_elem *rbe;
 	struct nft_set_elem elem;
 	struct rb_node *node;
-	u8 genmask = nft_genmask_cur(read_pnet(&set->pnet));
 
 	spin_lock_bh(&nft_rbtree_lock);
 	for (node = rb_first(&priv->root); node != NULL; node = rb_next(node)) {
@@ -219,7 +218,7 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 
 		if (iter->count < iter->skip)
 			goto cont;
-		if (!nft_set_elem_active(&rbe->ext, genmask))
+		if (!nft_set_elem_active(&rbe->ext, iter->genmask))
 			goto cont;
 
 		elem.priv = rbe;
-- 
2.1.4


--SLDf9lqlvOQaIe6s--
