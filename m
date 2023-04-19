Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04892C77B7C
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Apr 2023 09:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbjDSJUi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Apr 2023 05:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232642AbjDSJUh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Apr 2023 05:20:37 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 860BD192
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2023 02:20:36 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v3 4/5] netfilter: nf_tables: support for deleting devices in an existing netdev chain
Date:   Wed, 19 Apr 2023 11:20:28 +0200
Message-Id: <20230419092029.68913-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230419092029.68913-1-pablo@netfilter.org>
References: <20230419092029.68913-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch allows for deleting devices in an existing netdev chain.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: rebase on top of nf-next

 net/netfilter/nf_tables_api.c | 100 ++++++++++++++++++++++++++++++----
 1 file changed, 89 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fd939537af62..2ef92077b98f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1647,7 +1647,7 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 			 NFTA_CHAIN_PAD))
 		goto nla_put_failure;
 
-	if (event == NFT_MSG_DELCHAIN) {
+	if (event == NFT_MSG_DELCHAIN && !hook_list) {
 		nlmsg_end(skb, nlh);
 		return 0;
 	}
@@ -2658,6 +2658,60 @@ static int nf_tables_newchain(struct sk_buff *skb, const struct nfnl_info *info,
 	return nf_tables_addchain(&ctx, family, genmask, policy, flags, extack);
 }
 
+static int nft_delchain_hook(struct nft_ctx *ctx, struct nft_chain *chain,
+			     struct netlink_ext_ack *extack)
+{
+	const struct nlattr * const *nla = ctx->nla;
+	struct nft_chain_hook chain_hook = {};
+	struct nft_base_chain *basechain;
+	struct nft_hook *this, *hook;
+	LIST_HEAD(chain_del_list);
+	struct nft_trans *trans;
+	int err;
+
+	if (!nft_is_base_chain(chain))
+		return -EOPNOTSUPP;
+
+	err = nft_chain_parse_hook(ctx->net, nla, &chain_hook, ctx->family,
+				   extack, false);
+	if (err < 0)
+		return err;
+
+	basechain = nft_base_chain(chain);
+
+	list_for_each_entry(this, &chain_hook.list, list) {
+		hook = nft_hook_list_find(&basechain->hook_list, this);
+		if (!hook) {
+			err = -ENOENT;
+			goto err_chain_del_hook;
+		}
+		list_move(&hook->list, &chain_del_list);
+	}
+
+	trans = nft_trans_alloc(ctx, NFT_MSG_DELCHAIN,
+				sizeof(struct nft_trans_chain));
+	if (!trans) {
+		err = -ENOMEM;
+		goto err_chain_del_hook;
+	}
+
+	nft_trans_basechain(trans) = basechain;
+	nft_trans_chain_update(trans) = true;
+	INIT_LIST_HEAD(&nft_trans_chain_hooks(trans));
+	list_splice(&chain_del_list, &nft_trans_chain_hooks(trans));
+	nft_chain_release_hook(&chain_hook);
+
+	nft_trans_commit_list_add_tail(ctx->net, trans);
+
+	return 0;
+
+err_chain_del_hook:
+	list_splice(&chain_del_list, &basechain->hook_list);
+	nft_chain_release_hook(&chain_hook);
+
+	return err;
+}
+
 static int nf_tables_delchain(struct sk_buff *skb, const struct nfnl_info *info,
 			      const struct nlattr * const nla[])
 {
@@ -2698,12 +2752,19 @@ static int nf_tables_delchain(struct sk_buff *skb, const struct nfnl_info *info,
 		return PTR_ERR(chain);
 	}
 
+	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, chain, nla);
+
+	if (nla[NFTA_CHAIN_HOOK]) {
+		if (chain->flags & NFT_CHAIN_HW_OFFLOAD)
+			return -EOPNOTSUPP;
+
+		return nft_delchain_hook(&ctx, chain, extack);
+	}
+
 	if (info->nlh->nlmsg_flags & NLM_F_NONREC &&
 	    chain->use > 0)
 		return -EBUSY;
 
-	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, chain, nla);
-
 	use = chain->use;
 	list_for_each_entry(rule, &chain->rules, list) {
 		if (!nft_is_active_next(net, rule))
@@ -8797,7 +8858,10 @@ static void nft_commit_release(struct nft_trans *trans)
 		break;
 	case NFT_MSG_DELCHAIN:
 	case NFT_MSG_DESTROYCHAIN:
-		nf_tables_chain_destroy(&trans->ctx);
+		if (nft_trans_chain_update(trans))
+			nft_hooks_destroy(&nft_trans_chain_hooks(trans));
+		else
+			nf_tables_chain_destroy(&trans->ctx);
 		break;
 	case NFT_MSG_DELRULE:
 	case NFT_MSG_DESTROYRULE:
@@ -9291,11 +9355,20 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			break;
 		case NFT_MSG_DELCHAIN:
 		case NFT_MSG_DESTROYCHAIN:
-			nft_chain_del(trans->ctx.chain);
-			nf_tables_chain_notify(&trans->ctx, trans->msg_type, NULL);
-			nf_tables_unregister_hook(trans->ctx.net,
-						  trans->ctx.table,
-						  trans->ctx.chain);
+			if (nft_trans_chain_update(trans)) {
+				nf_tables_chain_notify(&trans->ctx, NFT_MSG_DELCHAIN,
+						       &nft_trans_chain_hooks(trans));
+				nft_netdev_unregister_hooks(net,
+							    &nft_trans_chain_hooks(trans),
+							    true);
+			} else {
+				nft_chain_del(trans->ctx.chain);
+				nf_tables_chain_notify(&trans->ctx, NFT_MSG_DELCHAIN,
+						       NULL);
+				nf_tables_unregister_hook(trans->ctx.net,
+							  trans->ctx.table,
+							  trans->ctx.chain);
+			}
 			break;
 		case NFT_MSG_NEWRULE:
 			nft_clear(trans->ctx.net, nft_trans_rule(trans));
@@ -9545,8 +9618,13 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			break;
 		case NFT_MSG_DELCHAIN:
 		case NFT_MSG_DESTROYCHAIN:
-			trans->ctx.table->use++;
-			nft_clear(trans->ctx.net, trans->ctx.chain);
+			if (nft_trans_chain_update(trans)) {
+				list_splice(&nft_trans_chain_hooks(trans),
+					    &nft_trans_basechain(trans)->hook_list);
+			} else {
+				trans->ctx.table->use++;
+				nft_clear(trans->ctx.net, trans->ctx.chain);
+			}
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWRULE:
-- 
2.30.2

