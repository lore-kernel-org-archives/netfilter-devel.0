From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next 2/3] netfilter: nf_tables: fix a endless jump loop when use vmap
Date: Sat, 11 Jun 2016 12:20:27 +0800
Message-ID: <1465618828-22162-3-git-send-email-zlpnobody@163.com>
References: <1465618828-22162-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:49441 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbcFKEVS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Jun 2016 00:21:18 -0400
In-Reply-To: <1465618828-22162-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Currently, user can add such a wrong nft rules successfully, which
will cause an endless jump loop:
  # nft add rule filter test tcp dport vmap {1: jump test}

This is because before we commit, the element in the current anonymous
set is inactive, so osp->walk will skip this element and miss the
validate check.

So we should also check the inactive element when we do loops check,
and ignore the inactive element when we do dump.

This patch also fix the testcase fail in
nftables/tests/shell/testcases/chains/0009masquerade_jump_1.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 include/net/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c     | 31 +++++++++++++++++--------------
 net/netfilter/nft_hash.c          |  3 ++-
 net/netfilter/nft_rbtree.c        |  3 ++-
 4 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 0922354..e35194a 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -167,6 +167,7 @@ struct nft_set_elem {
 
 struct nft_set;
 struct nft_set_iter {
+	bool		ignore_inactive;
 	unsigned int	count;
 	unsigned int	skip;
 	int		err;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e4a6d7e..d5f3602 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2949,10 +2949,11 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 				goto bind;
 		}
 
-		iter.skip 	= 0;
-		iter.count	= 0;
-		iter.err	= 0;
-		iter.fn		= nf_tables_bind_check_setelem;
+		iter.ignore_inactive	= false;
+		iter.skip		= 0;
+		iter.count		= 0;
+		iter.err		= 0;
+		iter.fn			= nf_tables_bind_check_setelem;
 
 		set->ops->walk(ctx, set, &iter);
 		if (iter.err < 0) {
@@ -3190,12 +3191,13 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	if (nest == NULL)
 		goto nla_put_failure;
 
-	args.cb		= cb;
-	args.skb	= skb;
-	args.iter.skip	= cb->args[0];
-	args.iter.count	= 0;
-	args.iter.err   = 0;
-	args.iter.fn	= nf_tables_dump_setelem;
+	args.cb				= cb;
+	args.skb			= skb;
+	args.iter.ignore_inactive	= true;
+	args.iter.skip			= cb->args[0];
+	args.iter.count			= 0;
+	args.iter.err			= 0;
+	args.iter.fn			= nf_tables_dump_setelem;
 	set->ops->walk(&ctx, set, &args.iter);
 
 	nla_nest_end(skb, nest);
@@ -4282,10 +4284,11 @@ static int nf_tables_check_loops(const struct nft_ctx *ctx,
 			    binding->chain != chain)
 				continue;
 
-			iter.skip 	= 0;
-			iter.count	= 0;
-			iter.err	= 0;
-			iter.fn		= nf_tables_loop_check_setelem;
+			iter.ignore_inactive	= false;
+			iter.skip		= 0;
+			iter.count		= 0;
+			iter.err		= 0;
+			iter.fn			= nf_tables_loop_check_setelem;
 
 			set->ops->walk(ctx, set, &iter);
 			if (iter.err < 0)
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index 6fa0165..7337580 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -218,7 +218,8 @@ static void nft_hash_walk(const struct nft_ctx *ctx, const struct nft_set *set,
 			goto cont;
 		if (nft_set_elem_expired(&he->ext))
 			goto cont;
-		if (!nft_set_elem_active(&he->ext, genmask))
+		if (iter->ignore_inactive &&
+		    !nft_set_elem_active(&he->ext, genmask))
 			goto cont;
 
 		elem.priv = he;
diff --git a/net/netfilter/nft_rbtree.c b/net/netfilter/nft_rbtree.c
index f762094..b948b72 100644
--- a/net/netfilter/nft_rbtree.c
+++ b/net/netfilter/nft_rbtree.c
@@ -219,7 +219,8 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 
 		if (iter->count < iter->skip)
 			goto cont;
-		if (!nft_set_elem_active(&rbe->ext, genmask))
+		if (iter->ignore_inactive &&
+		    !nft_set_elem_active(&rbe->ext, genmask))
 			goto cont;
 
 		elem.priv = rbe;
-- 
2.5.5


