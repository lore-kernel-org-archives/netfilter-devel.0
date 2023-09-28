Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B05B5E732F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Sep 2023 16:52:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbjI1Qwy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Sep 2023 12:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbjI1Qww (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2023 12:52:52 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69081AC
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Sep 2023 09:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ef/C5H+KN92sEYt6WZASjZ2f4kc/BJ3sBgTYh7VlXos=; b=SpqauHIeSyZ/fxjRKzzFncmALS
        FK0WAHjYePSp3USMf6+NpfubiJc7AT1R03zOj0IZimCVflhK4ZFIQjF/VPWvO7tQ5ccLgCrMgXxSP
        wn8JCpRzt2V5BVN4MeljS9QmZvJT65xceParg5yl6sz7KfZxLMHT522q9p3/7cVnD6JNntGR5oWzk
        pUa8FjL8qTQgtqdPX9qpThYC89P+D2RmfLi+txDUfPhqTGCAgEKj9QIqg3lTzyGl8gf5VZhR8NSZ+
        rXVXuXGfSVvRCZRAAE3l4Dg0Jv7N3EYrBwNlCjUcFQWGITcHLU3yHOCMjUTRwiEfcj0NvFWZouZNd
        p4KBFbFQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qluFt-0004wX-9y; Thu, 28 Sep 2023 18:52:49 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: [nf PATCH v2 1/8] netfilter: nf_tables: Don't allocate nft_rule_dump_ctx
Date:   Thu, 28 Sep 2023 18:52:37 +0200
Message-ID: <20230928165244.7168-2-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230928165244.7168-1-phil@nwl.cc>
References: <20230928165244.7168-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Eliminate the direct use of netlink_callback::args when dumping rules by
casting nft_rule_dump_ctx over netlink_callback::ctx as suggested in
the struct's comment.

The value for 's_idx' has to be stored inside nft_rule_dump_ctx now and
make it hold the 'reset' boolean as well.

Note how this patch removes the zeroing of netlink_callback::args[1-5] -
none of the rule dump callbacks seem to make use of them.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Fix description: 'idx' is not moved into the struct
---
 net/netfilter/nf_tables_api.c | 81 ++++++++++++++---------------------
 1 file changed, 32 insertions(+), 49 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4356189360fb8..511508407867d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3441,20 +3441,21 @@ static void audit_log_rule_reset(const struct nft_table *table,
 }
 
 struct nft_rule_dump_ctx {
+	unsigned int s_idx;
 	char *table;
 	char *chain;
+	bool reset;
 };
 
 static int __nf_tables_dump_rules(struct sk_buff *skb,
 				  unsigned int *idx,
 				  struct netlink_callback *cb,
 				  const struct nft_table *table,
-				  const struct nft_chain *chain,
-				  bool reset)
+				  const struct nft_chain *chain)
 {
+	struct nft_rule_dump_ctx *ctx = (void *)cb->ctx;
 	struct net *net = sock_net(skb->sk);
 	const struct nft_rule *rule, *prule;
-	unsigned int s_idx = cb->args[0];
 	unsigned int entries = 0;
 	int ret = 0;
 	u64 handle;
@@ -3463,12 +3464,9 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 	list_for_each_entry_rcu(rule, &chain->rules, list) {
 		if (!nft_is_active(net, rule))
 			goto cont_skip;
-		if (*idx < s_idx)
+		if (*idx < ctx->s_idx)
 			goto cont;
-		if (*idx > s_idx) {
-			memset(&cb->args[1], 0,
-					sizeof(cb->args) - sizeof(cb->args[0]));
-		}
+
 		if (prule)
 			handle = prule->handle;
 		else
@@ -3479,7 +3477,7 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 					NFT_MSG_NEWRULE,
 					NLM_F_MULTI | NLM_F_APPEND,
 					table->family,
-					table, chain, rule, handle, reset) < 0) {
+					table, chain, rule, handle, ctx->reset) < 0) {
 			ret = 1;
 			break;
 		}
@@ -3491,7 +3489,7 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 		(*idx)++;
 	}
 
-	if (reset && entries)
+	if (ctx->reset && entries)
 		audit_log_rule_reset(table, cb->seq, entries);
 
 	return ret;
@@ -3501,17 +3499,13 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 				struct netlink_callback *cb)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
-	const struct nft_rule_dump_ctx *ctx = cb->data;
+	struct nft_rule_dump_ctx *ctx = (void *)cb->ctx;
 	struct nft_table *table;
 	const struct nft_chain *chain;
 	unsigned int idx = 0;
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
 	struct nftables_pernet *nft_net;
-	bool reset = false;
-
-	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETRULE_RESET)
-		reset = true;
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
@@ -3521,10 +3515,10 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 		if (family != NFPROTO_UNSPEC && family != table->family)
 			continue;
 
-		if (ctx && ctx->table && strcmp(ctx->table, table->name) != 0)
+		if (ctx->table && strcmp(ctx->table, table->name) != 0)
 			continue;
 
-		if (ctx && ctx->table && ctx->chain) {
+		if (ctx->table && ctx->chain) {
 			struct rhlist_head *list, *tmp;
 
 			list = rhltable_lookup(&table->chains_ht, ctx->chain,
@@ -3536,7 +3530,7 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 				if (!nft_is_active(net, chain))
 					continue;
 				__nf_tables_dump_rules(skb, &idx,
-						       cb, table, chain, reset);
+						       cb, table, chain);
 				break;
 			}
 			goto done;
@@ -3544,62 +3538,51 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 
 		list_for_each_entry_rcu(chain, &table->chains, list) {
 			if (__nf_tables_dump_rules(skb, &idx,
-						   cb, table, chain, reset))
+						   cb, table, chain))
 				goto done;
 		}
 
-		if (ctx && ctx->table)
+		if (ctx->table)
 			break;
 	}
 done:
 	rcu_read_unlock();
 
-	cb->args[0] = idx;
+	ctx->s_idx = idx;
 	return skb->len;
 }
 
 static int nf_tables_dump_rules_start(struct netlink_callback *cb)
 {
+	struct nft_rule_dump_ctx *ctx = (void *)cb->ctx;
 	const struct nlattr * const *nla = cb->data;
-	struct nft_rule_dump_ctx *ctx = NULL;
 
-	if (nla[NFTA_RULE_TABLE] || nla[NFTA_RULE_CHAIN]) {
-		ctx = kzalloc(sizeof(*ctx), GFP_ATOMIC);
-		if (!ctx)
-			return -ENOMEM;
+	BUILD_BUG_ON(sizeof(*ctx) > sizeof(cb->ctx));
 
-		if (nla[NFTA_RULE_TABLE]) {
-			ctx->table = nla_strdup(nla[NFTA_RULE_TABLE],
-							GFP_ATOMIC);
-			if (!ctx->table) {
-				kfree(ctx);
-				return -ENOMEM;
-			}
-		}
-		if (nla[NFTA_RULE_CHAIN]) {
-			ctx->chain = nla_strdup(nla[NFTA_RULE_CHAIN],
-						GFP_ATOMIC);
-			if (!ctx->chain) {
-				kfree(ctx->table);
-				kfree(ctx);
-				return -ENOMEM;
-			}
+	if (nla[NFTA_RULE_TABLE]) {
+		ctx->table = nla_strdup(nla[NFTA_RULE_TABLE], GFP_ATOMIC);
+		if (!ctx->table)
+			return -ENOMEM;
+	}
+	if (nla[NFTA_RULE_CHAIN]) {
+		ctx->chain = nla_strdup(nla[NFTA_RULE_CHAIN], GFP_ATOMIC);
+		if (!ctx->chain) {
+			kfree(ctx->table);
+			return -ENOMEM;
 		}
 	}
+	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETRULE_RESET)
+		ctx->reset = true;
 
-	cb->data = ctx;
 	return 0;
 }
 
 static int nf_tables_dump_rules_done(struct netlink_callback *cb)
 {
-	struct nft_rule_dump_ctx *ctx = cb->data;
+	struct nft_rule_dump_ctx *ctx = (void *)cb->ctx;
 
-	if (ctx) {
-		kfree(ctx->table);
-		kfree(ctx->chain);
-		kfree(ctx);
-	}
+	kfree(ctx->table);
+	kfree(ctx->chain);
 	return 0;
 }
 
-- 
2.41.0

