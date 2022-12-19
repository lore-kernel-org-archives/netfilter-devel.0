Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2EC9C4167B
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Dec 2022 19:29:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbiLST3X (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Dec 2022 14:29:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232758AbiLST2v (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Dec 2022 14:28:51 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A315C15A39
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Dec 2022 11:28:50 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nf,v2 4/4] netfilter: nf_tables: honor set timeout and garbage collection updates
Date:   Mon, 19 Dec 2022 20:28:44 +0100
Message-Id: <20221219192844.212253-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221219192844.212253-1-pablo@netfilter.org>
References: <20221219192844.212253-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Set timeout and garbage collection interval updates are ignored on
updates. Add transaction to update global set element timeout and
garbage collection interval.

Fixes: 96518518cc41 ("netfilter: add nftables")
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: new in this series

 include/net/netfilter/nf_tables.h | 13 ++++++++++-
 net/netfilter/nf_tables_api.c     | 38 +++++++++++++++++++------------
 2 files changed, 35 insertions(+), 16 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 4957b4775757..9430128aae99 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -597,7 +597,9 @@ void *nft_set_catchall_gc(const struct nft_set *set);
 
 static inline unsigned long nft_set_gc_interval(const struct nft_set *set)
 {
-	return set->gc_int ? msecs_to_jiffies(set->gc_int) : HZ;
+	u32 gc_int = READ_ONCE(set->gc_int);
+
+	return gc_int ? msecs_to_jiffies(gc_int) : HZ;
 }
 
 /**
@@ -1570,6 +1572,9 @@ struct nft_trans_rule {
 struct nft_trans_set {
 	struct nft_set			*set;
 	u32				set_id;
+	u32				gc_int;
+	u64				timeout;
+	bool				update;
 	bool				bound;
 };
 
@@ -1579,6 +1584,12 @@ struct nft_trans_set {
 	(((struct nft_trans_set *)trans->data)->set_id)
 #define nft_trans_set_bound(trans)	\
 	(((struct nft_trans_set *)trans->data)->bound)
+#define nft_trans_set_update(trans)	\
+	(((struct nft_trans_set *)trans->data)->update)
+#define nft_trans_set_timeout(trans)	\
+	(((struct nft_trans_set *)trans->data)->timeout)
+#define nft_trans_set_gc_int(trans)	\
+	(((struct nft_trans_set *)trans->data)->gc_int)
 
 struct nft_trans_chain {
 	bool				update;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b8cbfd3bf472..8460650884cc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -466,7 +466,7 @@ static int nft_delrule_by_chain(struct nft_ctx *ctx)
 }
 
 static int nft_trans_set_add(const struct nft_ctx *ctx, int msg_type,
-			     struct nft_set *set)
+			     struct nft_set *set, bool update)
 {
 	struct nft_trans *trans;
 
@@ -480,6 +480,7 @@ static int nft_trans_set_add(const struct nft_ctx *ctx, int msg_type,
 		nft_activate_next(ctx->net, set);
 	}
 	nft_trans_set(trans) = set;
+	nft_trans_set_update(trans) = update;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
 
 	return 0;
@@ -489,7 +490,7 @@ static int nft_delset(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	int err;
 
-	err = nft_trans_set_add(ctx, NFT_MSG_DELSET, set);
+	err = nft_trans_set_add(ctx, NFT_MSG_DELSET, set, false);
 	if (err < 0)
 		return err;
 
@@ -4044,8 +4045,9 @@ static int nf_tables_fill_set_concat(struct sk_buff *skb,
 static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 			      const struct nft_set *set, u16 event, u16 flags)
 {
-	struct nlmsghdr *nlh;
+	u64 timeout = READ_ONCE(set->timeout);
 	u32 portid = ctx->portid;
+	struct nlmsghdr *nlh;
 	struct nlattr *nest;
 	u32 seq = ctx->seq;
 	int i;
@@ -4081,9 +4083,9 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 	    nla_put_be32(skb, NFTA_SET_OBJ_TYPE, htonl(set->objtype)))
 		goto nla_put_failure;
 
-	if (set->timeout &&
+	if (timeout &&
 	    nla_put_be64(skb, NFTA_SET_TIMEOUT,
-			 nf_jiffies64_to_msecs(set->timeout),
+			 nf_jiffies64_to_msecs(timeout),
 			 NFTA_SET_PAD))
 		goto nla_put_failure;
 	if (set->gc_int &&
@@ -4707,7 +4709,7 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	set->num_exprs = num_exprs;
 	set->handle = nf_tables_alloc_handle(table);
 
-	err = nft_trans_set_add(&ctx, NFT_MSG_NEWSET, set);
+	err = nft_trans_set_add(&ctx, NFT_MSG_NEWSET, set, false);
 	if (err < 0)
 		goto err_set_expr_alloc;
 
@@ -6071,7 +6073,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			return err;
 	} else if (set->flags & NFT_SET_TIMEOUT &&
 		   !(flags & NFT_SET_ELEM_INTERVAL_END)) {
-		timeout = set->timeout;
+		timeout = READ_ONCE(set->timeout);
 	}
 
 	expiration = 0;
@@ -6172,7 +6174,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		if (err < 0)
 			goto err_parse_key_end;
 
-		if (timeout != set->timeout) {
+		if (timeout != READ_ONCE(set->timeout)) {
 			err = nft_set_ext_add(&tmpl, NFT_SET_EXT_TIMEOUT);
 			if (err < 0)
 				goto err_parse_key_end;
@@ -9094,14 +9096,20 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				nft_flow_rule_destroy(nft_trans_flow_rule(trans));
 			break;
 		case NFT_MSG_NEWSET:
-			nft_clear(net, nft_trans_set(trans));
-			/* This avoids hitting -EBUSY when deleting the table
-			 * from the transaction.
-			 */
-			if (nft_set_is_anonymous(nft_trans_set(trans)) &&
-			    !list_empty(&nft_trans_set(trans)->bindings))
-				trans->ctx.table->use--;
+			if (nft_trans_set_update(trans)) {
+				struct nft_set *set = nft_trans_set(trans);
 
+				WRITE_ONCE(set->timeout, nft_trans_set_timeout(trans));
+				WRITE_ONCE(set->gc_int, nft_trans_set_gc_int(trans));
+			} else {
+				nft_clear(net, nft_trans_set(trans));
+				/* This avoids hitting -EBUSY when deleting the table
+				 * from the transaction.
+				 */
+				if (nft_set_is_anonymous(nft_trans_set(trans)) &&
+				    !list_empty(&nft_trans_set(trans)->bindings))
+					trans->ctx.table->use--;
+			}
 			nf_tables_set_notify(&trans->ctx, nft_trans_set(trans),
 					     NFT_MSG_NEWSET, GFP_KERNEL);
 			nft_trans_destroy(trans);
-- 
2.30.2

