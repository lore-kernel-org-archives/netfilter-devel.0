Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ABB4C4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Dec 2022 15:50:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiLTPuH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Dec 2022 10:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiLTPuG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Dec 2022 10:50:06 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 75DCCBC0
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2022 07:50:03 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nf,v4 4/4] netfilter: nf_tables: honor set timeout and garbage collection updates
Date:   Tue, 20 Dec 2022 16:49:57 +0100
Message-Id: <20221220154957.63695-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
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
v4: check for !desc in __nft_trans_set_add() not to toggle genmask bits for set updates.

 include/net/netfilter/nf_tables.h | 13 +++++++-
 net/netfilter/nf_tables_api.c     | 54 ++++++++++++++++++++++---------
 2 files changed, 50 insertions(+), 17 deletions(-)

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
index b8cbfd3bf472..71b5cad40489 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -465,8 +465,9 @@ static int nft_delrule_by_chain(struct nft_ctx *ctx)
 	return 0;
 }
 
-static int nft_trans_set_add(const struct nft_ctx *ctx, int msg_type,
-			     struct nft_set *set)
+static int __nft_trans_set_add(const struct nft_ctx *ctx, int msg_type,
+			       struct nft_set *set,
+			       const struct nft_set_desc *desc)
 {
 	struct nft_trans *trans;
 
@@ -474,17 +475,28 @@ static int nft_trans_set_add(const struct nft_ctx *ctx, int msg_type,
 	if (trans == NULL)
 		return -ENOMEM;
 
-	if (msg_type == NFT_MSG_NEWSET && ctx->nla[NFTA_SET_ID] != NULL) {
+	if (msg_type == NFT_MSG_NEWSET && ctx->nla[NFTA_SET_ID] && !desc) {
 		nft_trans_set_id(trans) =
 			ntohl(nla_get_be32(ctx->nla[NFTA_SET_ID]));
 		nft_activate_next(ctx->net, set);
 	}
 	nft_trans_set(trans) = set;
+	if (desc) {
+		nft_trans_set_update(trans) = true;
+		nft_trans_set_gc_int(trans) = desc->gc_int;
+		nft_trans_set_timeout(trans) = desc->timeout;
+	}
 	nft_trans_commit_list_add_tail(ctx->net, trans);
 
 	return 0;
 }
 
+static int nft_trans_set_add(const struct nft_ctx *ctx, int msg_type,
+			     struct nft_set *set)
+{
+	return __nft_trans_set_add(ctx, msg_type, set, NULL);
+}
+
 static int nft_delset(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	int err;
@@ -4044,8 +4056,9 @@ static int nf_tables_fill_set_concat(struct sk_buff *skb,
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
@@ -4081,9 +4094,9 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
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
@@ -4633,7 +4646,10 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 		for (i = 0; i < num_exprs; i++)
 			nft_expr_destroy(&ctx, exprs[i]);
 
-		return err;
+		if (err < 0)
+			return err;
+
+		return __nft_trans_set_add(&ctx, NFT_MSG_NEWSET, set, &desc);
 	}
 
 	if (!(info->nlh->nlmsg_flags & NLM_F_CREATE))
@@ -6071,7 +6087,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			return err;
 	} else if (set->flags & NFT_SET_TIMEOUT &&
 		   !(flags & NFT_SET_ELEM_INTERVAL_END)) {
-		timeout = set->timeout;
+		timeout = READ_ONCE(set->timeout);
 	}
 
 	expiration = 0;
@@ -6172,7 +6188,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		if (err < 0)
 			goto err_parse_key_end;
 
-		if (timeout != set->timeout) {
+		if (timeout != READ_ONCE(set->timeout)) {
 			err = nft_set_ext_add(&tmpl, NFT_SET_EXT_TIMEOUT);
 			if (err < 0)
 				goto err_parse_key_end;
@@ -9094,14 +9110,20 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
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

