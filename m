Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7B8EC433B4
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 May 2021 10:14:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1ABF601FA
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 May 2021 10:14:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345942AbhESKPt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 May 2021 06:15:49 -0400
Received: from mail.netfilter.org ([217.70.188.207]:45308 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347544AbhESKPZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 May 2021 06:15:25 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id F2F9F6417D;
        Wed, 19 May 2021 12:13:09 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, dvyukov@google.com
Subject: [PATCH nf,v2] netfilter: nftables: accept all dummy chain when table is dormant
Date:   Wed, 19 May 2021 12:14:01 +0200
Message-Id: <20210519101402.45141-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The dormant flag need to be updated from the preparation phase,
otherwise, two consecutive requests to dorm a table in the same batch
might try to remove the same hooks twice, resulting in the following
warning:

 hook not found, pf 3 num 0
 WARNING: CPU: 0 PID: 334 at net/netfilter/core.c:480 __nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480
 Modules linked in:
 CPU: 0 PID: 334 Comm: kworker/u4:5 Not tainted 5.12.0-syzkaller #0
 Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
 Workqueue: netns cleanup_net
 RIP: 0010:__nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480

This patch is a partial revert of 0ce7cf4127f1 ("netfilter: nftables:
update table flags from the commit phase") to restore the previous
behaviour, which updates the dormant flag from the preparation phase
to address this issue.

However, there is still another problem: A batch containing a series of
dorm-wakeup-dorm table and vice-versa also trigger the warning above
since hook unregistration happens from the preparation phase, while hook
registration occurs from the commit phase.

To fix this problem, this patch adds a dummy accept-all-rule that is
used in case the table enters dormant state. This patch removes
nf_tables_table_enable() and nf_tables_table_disable() since chain hooks
are always registered, therefore, they are not needed anymore.

The new __NFT_TABLE_F_UPDATE internal flag is used to signal the commit
phase that the dormant flag has been updated.

Reported-by: syzbot+7ad5cd1615f2d89c6e7e@syzkaller.appspotmail.com
Fixes: 0ce7cf4127f1 ("netfilter: nftables: update table flags from the commit phase")
Fixes: 9ddf63235749 ("netfilter: nf_tables: add support for dormant tables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: untoggle __NFT_TABLE_F_UPDATE from the commit transaction loop instead of
    doing this right after nf_tables_commit_chain_prepare().

 include/net/netfilter/nf_tables.h |   3 -
 net/netfilter/nf_tables_api.c     | 148 +++++++++++++++---------------
 2 files changed, 75 insertions(+), 76 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 27eeb613bb4e..8ad2839c4dd2 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1507,15 +1507,12 @@ struct nft_trans_chain {
 struct nft_trans_table {
 	bool				update;
 	u8				state;
-	u32				flags;
 };
 
 #define nft_trans_table_update(trans)	\
 	(((struct nft_trans_table *)trans->data)->update)
 #define nft_trans_table_state(trans)	\
 	(((struct nft_trans_table *)trans->data)->state)
-#define nft_trans_table_flags(trans)	\
-	(((struct nft_trans_table *)trans->data)->flags)
 
 struct nft_trans_elem {
 	struct nft_set			*set;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d63d2d8f769c..104b9a47be5f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -32,6 +32,7 @@ static LIST_HEAD(nf_tables_objects);
 static LIST_HEAD(nf_tables_flowtables);
 static LIST_HEAD(nf_tables_destroy_list);
 static DEFINE_SPINLOCK(nf_tables_destroy_list_lock);
+static struct nft_rule *nft_accept_all_rule;
 static u64 table_handle;
 
 enum {
@@ -237,8 +238,7 @@ static int nf_tables_register_hook(struct net *net,
 	struct nft_base_chain *basechain;
 	const struct nf_hook_ops *ops;
 
-	if (table->flags & NFT_TABLE_F_DORMANT ||
-	    !nft_is_base_chain(chain))
+	if (!nft_is_base_chain(chain))
 		return 0;
 
 	basechain = nft_base_chain(chain);
@@ -260,8 +260,7 @@ static void nf_tables_unregister_hook(struct net *net,
 	struct nft_base_chain *basechain;
 	const struct nf_hook_ops *ops;
 
-	if (table->flags & NFT_TABLE_F_DORMANT ||
-	    !nft_is_base_chain(chain))
+	if (!nft_is_base_chain(chain))
 		return;
 	basechain = nft_base_chain(chain);
 	ops = &basechain->ops;
@@ -736,7 +735,8 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
 		goto nla_put_failure;
 
 	if (nla_put_string(skb, NFTA_TABLE_NAME, table->name) ||
-	    nla_put_be32(skb, NFTA_TABLE_FLAGS, htonl(table->flags)) ||
+	    nla_put_be32(skb, NFTA_TABLE_FLAGS,
+			 htonl(table->flags & NFT_TABLE_F_MASK)) ||
 	    nla_put_be32(skb, NFTA_TABLE_USE, htonl(table->use)) ||
 	    nla_put_be64(skb, NFTA_TABLE_HANDLE, cpu_to_be64(table->handle),
 			 NFTA_TABLE_PAD))
@@ -902,65 +902,18 @@ static int nf_tables_gettable(struct sk_buff *skb, const struct nfnl_info *info,
 	return err;
 }
 
-static void nft_table_disable(struct net *net, struct nft_table *table, u32 cnt)
-{
-	struct nft_chain *chain;
-	u32 i = 0;
-
-	list_for_each_entry(chain, &table->chains, list) {
-		if (!nft_is_active_next(net, chain))
-			continue;
-		if (!nft_is_base_chain(chain))
-			continue;
-
-		if (cnt && i++ == cnt)
-			break;
-
-		nf_tables_unregister_hook(net, table, chain);
-	}
-}
-
-static int nf_tables_table_enable(struct net *net, struct nft_table *table)
-{
-	struct nft_chain *chain;
-	int err, i = 0;
-
-	list_for_each_entry(chain, &table->chains, list) {
-		if (!nft_is_active_next(net, chain))
-			continue;
-		if (!nft_is_base_chain(chain))
-			continue;
-
-		err = nf_tables_register_hook(net, table, chain);
-		if (err < 0)
-			goto err_register_hooks;
-
-		i++;
-	}
-	return 0;
-
-err_register_hooks:
-	if (i)
-		nft_table_disable(net, table, i);
-	return err;
-}
-
-static void nf_tables_table_disable(struct net *net, struct nft_table *table)
-{
-	nft_table_disable(net, table, 0);
-}
-
 enum {
 	NFT_TABLE_STATE_UNCHANGED	= 0,
 	NFT_TABLE_STATE_DORMANT,
 	NFT_TABLE_STATE_WAKEUP
 };
 
+#define __NFT_TABLE_F_UPDATE	(NFT_TABLE_F_MASK + 1)
+
 static int nf_tables_updtable(struct nft_ctx *ctx)
 {
 	struct nft_trans *trans;
 	u32 flags;
-	int ret = 0;
 
 	if (!ctx->nla[NFTA_TABLE_FLAGS])
 		return 0;
@@ -985,23 +938,19 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 
 	if ((flags & NFT_TABLE_F_DORMANT) &&
 	    !(ctx->table->flags & NFT_TABLE_F_DORMANT)) {
+		ctx->table->flags |= NFT_TABLE_F_DORMANT | __NFT_TABLE_F_UPDATE;
 		nft_trans_table_state(trans) = NFT_TABLE_STATE_DORMANT;
 	} else if (!(flags & NFT_TABLE_F_DORMANT) &&
 		   ctx->table->flags & NFT_TABLE_F_DORMANT) {
-		ret = nf_tables_table_enable(ctx->net, ctx->table);
-		if (ret >= 0)
-			nft_trans_table_state(trans) = NFT_TABLE_STATE_WAKEUP;
+		ctx->table->flags &= ~NFT_TABLE_F_DORMANT;
+		ctx->table->flags |= __NFT_TABLE_F_UPDATE;
+		nft_trans_table_state(trans) = NFT_TABLE_STATE_WAKEUP;
 	}
-	if (ret < 0)
-		goto err;
 
-	nft_trans_table_flags(trans) = flags;
 	nft_trans_table_update(trans) = true;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
+
 	return 0;
-err:
-	nft_trans_destroy(trans);
-	return ret;
 }
 
 static u32 nft_chain_hash(const void *data, u32 len, u32 seed)
@@ -8214,6 +8163,17 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 	if (chain->rules_next || !nft_is_active_next(net, chain))
 		return 0;
 
+	if (chain->table->flags & NFT_TABLE_F_DORMANT) {
+		chain->rules_next = nf_tables_chain_alloc_rules(chain, 1);
+		if (!chain->rules_next)
+			return -ENOMEM;
+
+		chain->rules_next[0] = nft_accept_all_rule;
+		chain->rules_next[1] = NULL;
+
+		return 0;
+	}
+
 	rule = list_entry(&chain->rules, struct nft_rule, list);
 	i = 0;
 
@@ -8513,8 +8473,21 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			nf_tables_commit_chain_prepare_cancel(net);
 			return ret;
 		}
-		if (trans->msg_type == NFT_MSG_NEWRULE ||
-		    trans->msg_type == NFT_MSG_DELRULE) {
+		switch (trans->msg_type) {
+		case NFT_MSG_NEWTABLE:
+			if (!(trans->ctx.table->flags & __NFT_TABLE_F_UPDATE))
+				break;
+
+			list_for_each_entry(chain, &trans->ctx.table->chains, list) {
+				ret = nf_tables_commit_chain_prepare(net, chain);
+				if (ret < 0) {
+					nf_tables_commit_chain_prepare_cancel(net);
+					return ret;
+				}
+			}
+			break;
+		case NFT_MSG_NEWRULE:
+		case NFT_MSG_DELRULE:
 			chain = trans->ctx.chain;
 
 			ret = nf_tables_commit_chain_prepare(net, chain);
@@ -8522,6 +8495,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				nf_tables_commit_chain_prepare_cancel(net);
 				return ret;
 			}
+			break;
 		}
 	}
 
@@ -8546,14 +8520,11 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 					       trans->msg_type);
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWTABLE:
-			if (nft_trans_table_update(trans)) {
-				if (nft_trans_table_state(trans) == NFT_TABLE_STATE_DORMANT)
-					nf_tables_table_disable(net, trans->ctx.table);
-
-				trans->ctx.table->flags = nft_trans_table_flags(trans);
-			} else {
+			if (nft_trans_table_update(trans))
+				trans->ctx.table->flags &= ~__NFT_TABLE_F_UPDATE;
+			else
 				nft_clear(net, trans->ctx.table);
-			}
+
 			nf_tables_table_notify(&trans->ctx, NFT_MSG_NEWTABLE);
 			nft_trans_destroy(trans);
 			break;
@@ -8769,8 +8740,11 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		case NFT_MSG_NEWTABLE:
 			if (nft_trans_table_update(trans)) {
 				if (nft_trans_table_state(trans) == NFT_TABLE_STATE_WAKEUP)
-					nf_tables_table_disable(net, trans->ctx.table);
+					trans->ctx.table->flags |= NFT_TABLE_F_DORMANT;
+				else if (nft_trans_table_state(trans) == NFT_TABLE_STATE_DORMANT)
+					trans->ctx.table->flags &= ~NFT_TABLE_F_DORMANT;
 
+				trans->ctx.table->flags &= ~__NFT_TABLE_F_UPDATE;
 				nft_trans_destroy(trans);
 			} else {
 				list_del_rcu(&trans->ctx.table->list);
@@ -9669,6 +9643,27 @@ static struct pernet_operations nf_tables_net_ops = {
 	.size		= sizeof(struct nftables_pernet),
 };
 
+static int nft_rule_accept_all_init(void)
+{
+	struct nft_immediate_expr *priv;
+	struct nft_rule *rule;
+	struct nft_expr *expr;
+
+	rule = kzalloc(sizeof(*rule) +
+		       NFT_EXPR_SIZE(sizeof(struct nft_immediate_expr)),
+		       GFP_KERNEL);
+	if (!rule)
+		return -ENOMEM;
+
+	expr = nft_expr_first(rule);
+	priv = nft_expr_priv(expr);
+	priv->dreg = NFT_REG_VERDICT;
+	priv->data.verdict.code = NF_ACCEPT;
+	nft_accept_all_rule = rule;
+
+	return 0;
+}
+
 static int __init nf_tables_module_init(void)
 {
 	int err;
@@ -9697,6 +9692,10 @@ static int __init nf_tables_module_init(void)
 	if (err < 0)
 		goto err_offload;
 
+	err = nft_rule_accept_all_init();
+	if (err < 0)
+		goto err_accept_all_rule;
+
 	err = netlink_register_notifier(&nft_nl_notifier);
 	if (err < 0)
 		goto err_netlink_notifier;
@@ -9713,6 +9712,8 @@ static int __init nf_tables_module_init(void)
 err_nfnl_subsys:
 	netlink_unregister_notifier(&nft_nl_notifier);
 err_netlink_notifier:
+	kfree(nft_accept_all_rule);
+err_accept_all_rule:
 	nft_offload_exit();
 err_offload:
 	rhltable_destroy(&nft_objname_ht);
@@ -9731,6 +9732,7 @@ static void __exit nf_tables_module_exit(void)
 {
 	nfnetlink_subsys_unregister(&nf_tables_subsys);
 	netlink_unregister_notifier(&nft_nl_notifier);
+	kfree(nft_accept_all_rule);
 	nft_offload_exit();
 	unregister_netdevice_notifier(&nf_tables_flowtable_notifier);
 	nft_chain_filter_fini();
-- 
2.30.2

