Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A27C433FE
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Oct 2022 21:47:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiJNVrM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Oct 2022 17:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiJNVqu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Oct 2022 17:46:50 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0C6E196C
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Oct 2022 14:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DTbTz/MHfJCLN6WtTPhqWOivSDhbUJp3JDkkTHXT7no=; b=LpSrq+Pvfj43ptqvj7VCJ9F/Hb
        7dnlAJXcsAJsO7zYPL1fRU1wUEBU2TG47p4zZMzWl/XfZf6xILuzH0rl0/n4HvGI+wk0kBjCdOvqn
        SUXd9jtwfvASNqN1cKLY2ogoryB/jRZ8Avx3u887IoVlw2SvfmAPrAlQUFWUlHPpwDG7mvhQKxtBS
        lw7Ll9HTaw7k4J5Th6zkjv9tqzs/AsGqUTcbVs5SnnSiXDQUxy1smD0pn5jMgv5KdKkivVZ2jbku/
        0xxBEguT1h+uTk1l7G1yKWOLISreShtltrZCZO4gI8H4KQ23VFsxVrhXxR+OoE2Ey2SeXA/A8wLaw
        rrBuF5Ow==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ojSVR-0000aB-Vo; Fri, 14 Oct 2022 23:46:14 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH 2/2] netfilter: nf_tables: Introduce NFT_MSG_GETRULE_RESET
Date:   Fri, 14 Oct 2022 23:45:59 +0200
Message-Id: <20221014214559.22254-3-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221014214559.22254-1-phil@nwl.cc>
References: <20221014214559.22254-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Analogous to NFT_MSG_GETOBJ_RESET, but for rules: Reset stateful
expressions like counters or quotas. The latter two are the only
consumers, adjust their 'dump' callbacks to respect the parameter
introduced earlier.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/net/netfilter/nf_tables.h        |  2 +-
 include/uapi/linux/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c            | 49 ++++++++++++++++--------
 net/netfilter/nft_counter.c              |  2 +-
 net/netfilter/nft_dynset.c               |  4 +-
 net/netfilter/nft_quota.c                |  2 +-
 6 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index ea3922e85f091..3953b7b0a7bcc 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -378,7 +378,7 @@ static inline void *nft_expr_priv(const struct nft_expr *expr)
 int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src);
 void nft_expr_destroy(const struct nft_ctx *ctx, struct nft_expr *expr);
 int nft_expr_dump(struct sk_buff *skb, unsigned int attr,
-		  const struct nft_expr *expr);
+		  const struct nft_expr *expr, bool reset);
 bool nft_expr_reduce_bitwise(struct nft_regs_track *track,
 			     const struct nft_expr *expr);
 
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 466fd3f4447c2..713ce327e381e 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -124,6 +124,7 @@ enum nf_tables_msg_types {
 	NFT_MSG_NEWFLOWTABLE,
 	NFT_MSG_GETFLOWTABLE,
 	NFT_MSG_DELFLOWTABLE,
+	NFT_MSG_GETRULE_RESET,
 	NFT_MSG_MAX,
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4c75134e00e63..b058e39282e4a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2759,7 +2759,7 @@ static const struct nla_policy nft_expr_policy[NFTA_EXPR_MAX + 1] = {
 };
 
 static int nf_tables_fill_expr_info(struct sk_buff *skb,
-				    const struct nft_expr *expr)
+				    const struct nft_expr *expr, bool reset)
 {
 	if (nla_put_string(skb, NFTA_EXPR_NAME, expr->ops->type->name))
 		goto nla_put_failure;
@@ -2769,7 +2769,7 @@ static int nf_tables_fill_expr_info(struct sk_buff *skb,
 							    NFTA_EXPR_DATA);
 		if (data == NULL)
 			goto nla_put_failure;
-		if (expr->ops->dump(skb, expr, false) < 0)
+		if (expr->ops->dump(skb, expr, reset) < 0)
 			goto nla_put_failure;
 		nla_nest_end(skb, data);
 	}
@@ -2781,14 +2781,14 @@ static int nf_tables_fill_expr_info(struct sk_buff *skb,
 };
 
 int nft_expr_dump(struct sk_buff *skb, unsigned int attr,
-		  const struct nft_expr *expr)
+		  const struct nft_expr *expr, bool reset)
 {
 	struct nlattr *nest;
 
 	nest = nla_nest_start_noflag(skb, attr);
 	if (!nest)
 		goto nla_put_failure;
-	if (nf_tables_fill_expr_info(skb, expr) < 0)
+	if (nf_tables_fill_expr_info(skb, expr, reset) < 0)
 		goto nla_put_failure;
 	nla_nest_end(skb, nest);
 	return 0;
@@ -2997,7 +2997,8 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
 				    u32 flags, int family,
 				    const struct nft_table *table,
 				    const struct nft_chain *chain,
-				    const struct nft_rule *rule, u64 handle)
+				    const struct nft_rule *rule, u64 handle,
+				    bool reset)
 {
 	struct nlmsghdr *nlh;
 	const struct nft_expr *expr, *next;
@@ -3030,7 +3031,7 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
 	if (list == NULL)
 		goto nla_put_failure;
 	nft_rule_for_each_expr(expr, next, rule) {
-		if (nft_expr_dump(skb, NFTA_LIST_ELEM, expr) < 0)
+		if (nft_expr_dump(skb, NFTA_LIST_ELEM, expr, reset) < 0)
 			goto nla_put_failure;
 	}
 	nla_nest_end(skb, list);
@@ -3081,7 +3082,7 @@ static void nf_tables_rule_notify(const struct nft_ctx *ctx,
 
 	err = nf_tables_fill_rule_info(skb, ctx->net, ctx->portid, ctx->seq,
 				       event, flags, ctx->family, ctx->table,
-				       ctx->chain, rule, handle);
+				       ctx->chain, rule, handle, false);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
@@ -3102,7 +3103,8 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 				  unsigned int *idx,
 				  struct netlink_callback *cb,
 				  const struct nft_table *table,
-				  const struct nft_chain *chain)
+				  const struct nft_chain *chain,
+				  bool reset)
 {
 	struct net *net = sock_net(skb->sk);
 	const struct nft_rule *rule, *prule;
@@ -3129,7 +3131,7 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 					NFT_MSG_NEWRULE,
 					NLM_F_MULTI | NLM_F_APPEND,
 					table->family,
-					table, chain, rule, handle) < 0)
+					table, chain, rule, handle, reset) < 0)
 			return 1;
 
 		nl_dump_check_consistent(cb, nlmsg_hdr(skb));
@@ -3152,6 +3154,10 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
 	struct nftables_pernet *nft_net;
+	bool reset = false;
+
+	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETRULE_RESET)
+		reset = true;
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
@@ -3176,14 +3182,15 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 				if (!nft_is_active(net, chain))
 					continue;
 				__nf_tables_dump_rules(skb, &idx,
-						       cb, table, chain);
+						       cb, table, chain, reset);
 				break;
 			}
 			goto done;
 		}
 
 		list_for_each_entry_rcu(chain, &table->chains, list) {
-			if (__nf_tables_dump_rules(skb, &idx, cb, table, chain))
+			if (__nf_tables_dump_rules(skb, &idx,
+						   cb, table, chain, reset))
 				goto done;
 		}
 
@@ -3254,6 +3261,7 @@ static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 	struct net *net = info->net;
 	struct nft_table *table;
 	struct sk_buff *skb2;
+	bool reset = false;
 	int err;
 
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
@@ -3290,9 +3298,12 @@ static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 	if (!skb2)
 		return -ENOMEM;
 
+	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETRULE_RESET)
+		reset = true;
+
 	err = nf_tables_fill_rule_info(skb2, net, NETLINK_CB(skb).portid,
 				       info->nlh->nlmsg_seq, NFT_MSG_NEWRULE, 0,
-				       family, table, chain, rule, 0);
+				       family, table, chain, rule, 0, reset);
 	if (err < 0)
 		goto err_fill_rule_info;
 
@@ -4067,7 +4078,7 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 
 	if (set->num_exprs == 1) {
 		nest = nla_nest_start_noflag(skb, NFTA_SET_EXPR);
-		if (nf_tables_fill_expr_info(skb, set->exprs[0]) < 0)
+		if (nf_tables_fill_expr_info(skb, set->exprs[0], false) < 0)
 			goto nla_put_failure;
 
 		nla_nest_end(skb, nest);
@@ -4078,7 +4089,7 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 
 		for (i = 0; i < set->num_exprs; i++) {
 			if (nft_expr_dump(skb, NFTA_LIST_ELEM,
-					  set->exprs[i]) < 0)
+					  set->exprs[i], false) < 0)
 				goto nla_put_failure;
 		}
 		nla_nest_end(skb, nest);
@@ -4909,7 +4920,7 @@ static int nft_set_elem_expr_dump(struct sk_buff *skb,
 
 	if (num_exprs == 1) {
 		expr = nft_setelem_expr_at(elem_expr, 0);
-		if (nft_expr_dump(skb, NFTA_SET_ELEM_EXPR, expr) < 0)
+		if (nft_expr_dump(skb, NFTA_SET_ELEM_EXPR, expr, false) < 0)
 			return -1;
 
 		return 0;
@@ -4920,7 +4931,7 @@ static int nft_set_elem_expr_dump(struct sk_buff *skb,
 
 		nft_setelem_expr_foreach(expr, elem_expr, size) {
 			expr = nft_setelem_expr_at(elem_expr, size);
-			if (nft_expr_dump(skb, NFTA_LIST_ELEM, expr) < 0)
+			if (nft_expr_dump(skb, NFTA_LIST_ELEM, expr, false) < 0)
 				goto nla_put_failure;
 		}
 		nla_nest_end(skb, nest);
@@ -8273,6 +8284,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.attr_count	= NFTA_RULE_MAX,
 		.policy		= nft_rule_policy,
 	},
+	[NFT_MSG_GETRULE_RESET] = {
+		.call		= nf_tables_getrule,
+		.type		= NFNL_CB_RCU,
+		.attr_count	= NFTA_RULE_MAX,
+		.policy		= nft_rule_policy,
+	},
 	[NFT_MSG_DELRULE] = {
 		.call		= nf_tables_delrule,
 		.type		= NFNL_CB_BATCH,
diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index 06482fb9c1457..dccc68a5135ad 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -206,7 +206,7 @@ static int nft_counter_dump(struct sk_buff *skb,
 {
 	struct nft_counter_percpu_priv *priv = nft_expr_priv(expr);
 
-	return nft_counter_do_dump(skb, priv, false);
+	return nft_counter_do_dump(skb, priv, reset);
 }
 
 static int nft_counter_init(const struct nft_ctx *ctx,
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 01c61e090639d..274579b1696e0 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -380,7 +380,7 @@ static int nft_dynset_dump(struct sk_buff *skb,
 	if (priv->set->num_exprs == 0) {
 		if (priv->num_exprs == 1) {
 			if (nft_expr_dump(skb, NFTA_DYNSET_EXPR,
-					  priv->expr_array[0]))
+					  priv->expr_array[0], reset))
 				goto nla_put_failure;
 		} else if (priv->num_exprs > 1) {
 			struct nlattr *nest;
@@ -391,7 +391,7 @@ static int nft_dynset_dump(struct sk_buff *skb,
 
 			for (i = 0; i < priv->num_exprs; i++) {
 				if (nft_expr_dump(skb, NFTA_LIST_ELEM,
-						  priv->expr_array[i]))
+						  priv->expr_array[i], reset))
 					goto nla_put_failure;
 			}
 			nla_nest_end(skb, nest);
diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index b1a1217bca4cd..123578e289179 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -222,7 +222,7 @@ static int nft_quota_dump(struct sk_buff *skb,
 {
 	struct nft_quota *priv = nft_expr_priv(expr);
 
-	return nft_quota_do_dump(skb, priv, false);
+	return nft_quota_do_dump(skb, priv, reset);
 }
 
 static void nft_quota_destroy(const struct nft_ctx *ctx,
-- 
2.34.1

