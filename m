Return-Path: <SRS0=aNn+=SO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C6F6C10F0E
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Apr 2019 09:12:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4EBF2084D
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Apr 2019 09:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726850AbfDLJMY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 05:12:24 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40726 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726616AbfDLJMY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 05:12:24 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hEsEP-0007n0-Mm; Fri, 12 Apr 2019 11:12:21 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Jann Haber <jann.haber@selfnet.de>
Subject: [PATCH nf] netfilter: nf_tables: delay chain policy update until transaction is complete
Date:   Fri, 12 Apr 2019 11:09:25 +0200
Message-Id: <20190412090925.8668-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When we process a long ruleset of the form

chain input {
   type filter hook input priority filter; policy drop;
   ...
}

Then the base chain gets registered early on, we then continue to
process/validate the next messages coming in the same transaction.

Problem is that if the base chain policy is 'drop', it will take effect
immediately, which causes all traffic to get blocked until the
transaction completes or is aborted.

Fix this by deferring the policy until the transaction has been
processed and all of the rules have been flagged as active.

Reported-by: Jann Haber <jann.haber@selfnet.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 50 +++++++++++++++++++++++++++--------
 1 file changed, 39 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ef7772e976cc..fc5da622a869 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -214,33 +214,33 @@ static int nft_deltable(struct nft_ctx *ctx)
 	return err;
 }
 
-static int nft_trans_chain_add(struct nft_ctx *ctx, int msg_type)
+static struct nft_trans *nft_trans_chain_add(struct nft_ctx *ctx, int msg_type)
 {
 	struct nft_trans *trans;
 
 	trans = nft_trans_alloc(ctx, msg_type, sizeof(struct nft_trans_chain));
 	if (trans == NULL)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	if (msg_type == NFT_MSG_NEWCHAIN)
 		nft_activate_next(ctx->net, ctx->chain);
 
 	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
-	return 0;
+	return trans;
 }
 
 static int nft_delchain(struct nft_ctx *ctx)
 {
-	int err;
+	struct nft_trans *trans;
 
-	err = nft_trans_chain_add(ctx, NFT_MSG_DELCHAIN);
-	if (err < 0)
-		return err;
+	trans = nft_trans_chain_add(ctx, NFT_MSG_DELCHAIN);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
 	ctx->table->use--;
 	nft_deactivate_next(ctx->net, ctx->chain);
 
-	return err;
+	return 0;
 }
 
 static void nft_rule_expr_activate(const struct nft_ctx *ctx,
@@ -1615,6 +1615,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	struct nft_base_chain *basechain;
 	struct nft_stats __percpu *stats;
 	struct net *net = ctx->net;
+	struct nft_trans *trans;
 	struct nft_chain *chain;
 	struct nft_rule **rules;
 	int err;
@@ -1662,7 +1663,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		ops->dev	= hook.dev;
 
 		chain->flags |= NFT_BASE_CHAIN;
-		basechain->policy = policy;
+		basechain->policy = NF_ACCEPT;
 	} else {
 		chain = kzalloc(sizeof(*chain), GFP_KERNEL);
 		if (chain == NULL)
@@ -1698,13 +1699,18 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	if (err)
 		goto err2;
 
-	err = nft_trans_chain_add(ctx, NFT_MSG_NEWCHAIN);
-	if (err < 0) {
+	trans = nft_trans_chain_add(ctx, NFT_MSG_NEWCHAIN);
+	if (IS_ERR(trans)) {
+		err = PTR_ERR(trans);
 		rhltable_remove(&table->chains_ht, &chain->rhlhead,
 				nft_chain_ht_params);
 		goto err2;
 	}
 
+	nft_trans_chain_policy(trans) = -1;
+	if (nft_is_base_chain(chain))
+		nft_trans_chain_policy(trans) = policy;
+
 	table->use++;
 	list_add_tail_rcu(&chain->list, &table->chains);
 
@@ -6311,6 +6317,27 @@ static int nf_tables_validate(struct net *net)
 	return 0;
 }
 
+/* a drop policy has to be deferred until all rules have been activated,
+ * otherwise a large ruleset that contains a drop-policy base chain will
+ * cause all packets to get dropped until the full transaction has been
+ * processed.
+ *
+ * We defer the drop policy until the transaction has been finalized.
+ */
+static void nft_chain_commit_drop_policy(struct nft_trans *trans)
+{
+	struct nft_base_chain *basechain;
+
+	if (nft_trans_chain_policy(trans) != NF_DROP)
+		return;
+
+	if (!nft_is_base_chain(trans->ctx.chain))
+		return;
+
+	basechain = nft_base_chain(trans->ctx.chain);
+	basechain->policy = NF_DROP;
+}
+
 static void nft_chain_commit_update(struct nft_trans *trans)
 {
 	struct nft_base_chain *basechain;
@@ -6632,6 +6659,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				nf_tables_chain_notify(&trans->ctx, NFT_MSG_NEWCHAIN);
 				/* trans destroyed after rcu grace period */
 			} else {
+				nft_chain_commit_drop_policy(trans);
 				nft_clear(net, trans->ctx.chain);
 				nf_tables_chain_notify(&trans->ctx, NFT_MSG_NEWCHAIN);
 				nft_trans_destroy(trans);
-- 
2.21.0

