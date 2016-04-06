From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC nf-next 3/3] netfilter: nf_tables: support dump and reset for named expressions
Date: Wed,  6 Apr 2016 18:51:33 +0200
Message-ID: <1459961493-7494-4-git-send-email-pablo@netfilter.org>
References: <1459961493-7494-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42810 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbcDFQvr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Apr 2016 12:51:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0892FC9EF3
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Apr 2016 18:51:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E604BDA38C
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Apr 2016 18:51:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 296C4DA38C
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Apr 2016 18:51:42 +0200 (CEST)
In-Reply-To: <1459961493-7494-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a new NFT_MSG_GETNEXPR_RESET command to dump and to
atomically reset the internal state of the named expression.

Stateful expressions may implement the new reset() interface to allow
the reset of this named expressions.

This patch comes with the first client of it: the nft_counter
expression.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        |  3 ++
 include/uapi/linux/netfilter/nf_tables.h |  2 +
 net/netfilter/nf_tables_api.c            | 66 +++++++++++++++++++++++++-------
 net/netfilter/nft_counter.c              | 36 +++++++++++++----
 4 files changed, 85 insertions(+), 22 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index a84f787..8c39268 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -611,6 +611,7 @@ struct nft_expr_type {
  *	@init: initialization function
  *	@destroy: destruction function
  *	@dump: function to dump parameters
+ *	@reset: function to dump parameters and to reset internal state
  *	@type: expression type
  *	@validate: validate expression, called during loop detection
  *	@data: extra data to attach to this expression operation
@@ -631,6 +632,8 @@ struct nft_expr_ops {
 						   const struct nft_expr *expr);
 	int				(*dump)(struct sk_buff *skb,
 						const struct nft_expr *expr);
+	int				(*reset)(struct sk_buff *skb,
+						 const struct nft_expr *expr);
 	int				(*validate)(const struct nft_ctx *ctx,
 						    const struct nft_expr *expr,
 						    const struct nft_data **data);
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index f07b384..644c1dd 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -88,6 +88,7 @@ enum nft_verdicts {
  * @NFT_MSG_NEWNEXPR: create a new named expression (enum nft_nexpr_attributes)
  * @NFT_MSG_GETNEXPR: get a named expression (enum nft_nexpr_attributes)
  * @NFT_MSG_DELNEXPR: delete a named expression (enum nft_nexpr_attributes)
+ * @NFT_MSG_GETNEXPR_RESET: get and reset a named expression (enum nft_nexpr_attributes)
  */
 enum nf_tables_msg_types {
 	NFT_MSG_NEWTABLE,
@@ -111,6 +112,7 @@ enum nf_tables_msg_types {
 	NFT_MSG_NEWNEXPR,
 	NFT_MSG_GETNEXPR,
 	NFT_MSG_DELNEXPR,
+	NFT_MSG_GETNEXPR_RESET,
 	NFT_MSG_MAX,
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e506dca..94d51cd 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1630,7 +1630,7 @@ static const struct nla_policy nft_expr_policy[NFTA_EXPR_MAX + 1] = {
 };
 
 static int nf_tables_fill_expr_info(struct sk_buff *skb,
-				    const struct nft_expr *expr)
+				    const struct nft_expr *expr, bool reset)
 {
 	if (nla_put_string(skb, NFTA_EXPR_NAME, expr->ops->type->name))
 		goto nla_put_failure;
@@ -1639,8 +1639,13 @@ static int nf_tables_fill_expr_info(struct sk_buff *skb,
 		struct nlattr *data = nla_nest_start(skb, NFTA_EXPR_DATA);
 		if (data == NULL)
 			goto nla_put_failure;
-		if (expr->ops->dump(skb, expr) < 0)
-			goto nla_put_failure;
+		if (reset) {
+			if (expr->ops->reset(skb, expr) < 0)
+				goto nla_put_failure;
+		} else {
+			if (expr->ops->dump(skb, expr) < 0)
+				goto nla_put_failure;
+		}
 		nla_nest_end(skb, data);
 	}
 
@@ -1650,15 +1655,15 @@ nla_put_failure:
 	return -1;
 };
 
-int nft_expr_dump(struct sk_buff *skb, unsigned int attr,
-		  const struct nft_expr *expr)
+int __nft_expr_dump(struct sk_buff *skb, unsigned int attr,
+		    const struct nft_expr *expr, bool reset)
 {
 	struct nlattr *nest;
 
 	nest = nla_nest_start(skb, attr);
 	if (!nest)
 		goto nla_put_failure;
-	if (nf_tables_fill_expr_info(skb, expr) < 0)
+	if (nf_tables_fill_expr_info(skb, expr, reset) < 0)
 		goto nla_put_failure;
 	nla_nest_end(skb, nest);
 	return 0;
@@ -1667,6 +1672,12 @@ nla_put_failure:
 	return -1;
 }
 
+int nft_expr_dump(struct sk_buff *skb, unsigned int attr,
+		  const struct nft_expr *expr)
+{
+	return __nft_expr_dump(skb, attr, expr, false);
+}
+
 struct nft_expr_info {
 	const struct nft_expr_ops	*ops;
 	struct nlattr			*tb[NFT_EXPR_MAXATTR + 1];
@@ -3921,10 +3932,27 @@ err1:
 	return err;
 }
 
+static int nft_nexpr_dump(struct sk_buff *skb, const struct nft_table *table,
+			  const struct nft_nexpr *nexpr, bool reset)
+{
+	if (nla_put_string(skb, NFTA_NEXPR_TABLE, table->name) ||
+	    nla_put_string(skb, NFTA_NEXPR_NAME, nexpr->name) ||
+	    nla_put_be32(skb, NFTA_NEXPR_USE, htonl(nexpr->use)))
+		goto nla_put_failure;
+
+	if (__nft_expr_dump(skb, NFTA_NEXPR_EXPR, nexpr->expr, reset))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
 static int nf_tables_fill_nexpr_info(struct sk_buff *skb, struct net *net,
 				     u32 portid, u32 seq, int event, u32 flags,
 				     int family, const struct nft_table *table,
-				     const struct nft_nexpr *nexpr)
+				     const struct nft_nexpr *nexpr, bool reset)
 {
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
@@ -3939,10 +3967,7 @@ static int nf_tables_fill_nexpr_info(struct sk_buff *skb, struct net *net,
 	nfmsg->version		= NFNETLINK_V0;
 	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
 
-	if (nla_put_string(skb, NFTA_NEXPR_TABLE, table->name) ||
-	    nla_put_string(skb, NFTA_NEXPR_NAME, nexpr->name) ||
-	    nla_put_be32(skb, NFTA_NEXPR_USE, htonl(nexpr->use)) ||
-	    nft_expr_dump(skb, NFTA_NEXPR_EXPR, nexpr->expr))
+	if (nft_nexpr_dump(skb, table, nexpr, reset))
 		goto nla_put_failure;
 
 	nlmsg_end(skb, nlh);
@@ -3963,6 +3988,10 @@ static int nf_tables_dump_nexpr(struct sk_buff *skb,
 	unsigned int idx = 0, s_idx = cb->args[0];
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
+	bool reset = false;
+
+	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETNEXPR_RESET)
+		reset = true;
 
 	rcu_read_lock();
 	cb->seq = net->nft.base_seq;
@@ -3982,7 +4011,7 @@ static int nf_tables_dump_nexpr(struct sk_buff *skb,
 							      cb->nlh->nlmsg_seq,
 							      NFT_MSG_NEWNEXPR,
 							      NLM_F_MULTI | NLM_F_APPEND,
-							      afi->family, table, nexpr) < 0)
+							      afi->family, table, nexpr, reset) < 0)
 					goto done;
 
 				nl_dump_check_consistent(cb, nlmsg_hdr(skb));
@@ -4008,6 +4037,7 @@ static int nf_tables_getnexpr(struct net *net, struct sock *nlsk,
 	const struct nft_table *table;
 	struct nft_nexpr *nexpr;
 	struct sk_buff *skb2;
+	bool reset = false;
 	int err;
 
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
@@ -4035,9 +4065,12 @@ static int nf_tables_getnexpr(struct net *net, struct sock *nlsk,
 	if (!skb2)
 		return -ENOMEM;
 
+	if (NFNL_MSG_TYPE(nlh->nlmsg_type) == NFT_MSG_GETNEXPR_RESET)
+		reset = true;
+
 	err = nf_tables_fill_nexpr_info(skb2, net, NETLINK_CB(skb).portid,
 					nlh->nlmsg_seq, NFT_MSG_NEWNEXPR, 0,
-					family, table, nexpr);
+					family, table, nexpr, reset);
 	if (err < 0)
 		goto err;
 
@@ -4103,7 +4136,7 @@ static int nf_tables_nexpr_notify(const struct nft_ctx *ctx,
 
 	err = nf_tables_fill_nexpr_info(skb, ctx->net, ctx->portid, ctx->seq,
 					event, 0, ctx->afi->family, ctx->table,
-					nexpr);
+					nexpr, false);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
@@ -4213,6 +4246,11 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.attr_count	= NFTA_NEXPR_MAX,
 		.policy		= nft_nexpr_policy,
 	},
+	[NFT_MSG_GETNEXPR_RESET] = {
+		.call		= nf_tables_getnexpr,
+		.attr_count	= NFTA_NEXPR_MAX,
+		.policy		= nft_nexpr_policy,
+	},
 };
 
 static void nft_chain_commit_update(struct nft_trans *trans)
diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index c9743f7..eec5d63 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -47,21 +47,29 @@ static void nft_counter_eval(const struct nft_expr *expr,
 	local_bh_enable();
 }
 
-static void nft_counter_fetch(const struct nft_counter_percpu __percpu *counter,
-			      struct nft_counter *total)
+static void nft_counter_fetch(struct nft_counter_percpu __percpu *counter,
+			      struct nft_counter *total, bool reset)
 {
-	const struct nft_counter_percpu *cpu_stats;
+	struct nft_counter_percpu *cpu_stats;
 	u64 bytes, packets;
 	unsigned int seq;
 	int cpu;
 
 	memset(total, 0, sizeof(*total));
 	for_each_possible_cpu(cpu) {
+		if (reset)
+			bytes = packets = 0;
+
 		cpu_stats = per_cpu_ptr(counter, cpu);
 		do {
 			seq	= u64_stats_fetch_begin_irq(&cpu_stats->syncp);
-			bytes	= cpu_stats->counter.bytes;
-			packets	= cpu_stats->counter.packets;
+			if (reset) {
+				packets += xchg(&cpu_stats->counter.packets, 0);
+				bytes	+= xchg(&cpu_stats->counter.bytes, 0);
+			} else {
+				bytes	= cpu_stats->counter.bytes;
+				packets	= cpu_stats->counter.packets;
+			}
 		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, seq));
 
 		total->packets += packets;
@@ -69,12 +77,13 @@ static void nft_counter_fetch(const struct nft_counter_percpu __percpu *counter,
 	}
 }
 
-static int nft_counter_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int __nft_counter_dump(struct sk_buff *skb, const struct nft_expr *expr,
+			      bool reset)
 {
 	struct nft_counter_percpu_priv *priv = nft_expr_priv(expr);
 	struct nft_counter total;
 
-	nft_counter_fetch(priv->counter, &total);
+	nft_counter_fetch(priv->counter, &total, reset);
 
 	if (nla_put_be64(skb, NFTA_COUNTER_BYTES, cpu_to_be64(total.bytes)) ||
 	    nla_put_be64(skb, NFTA_COUNTER_PACKETS, cpu_to_be64(total.packets)))
@@ -85,6 +94,16 @@ nla_put_failure:
 	return -1;
 }
 
+static int nft_counter_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	return __nft_counter_dump(skb, expr, false);
+}
+
+static int nft_counter_reset(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	return __nft_counter_dump(skb, expr, true);
+}
+
 static const struct nla_policy nft_counter_policy[NFTA_COUNTER_MAX + 1] = {
 	[NFTA_COUNTER_PACKETS]	= { .type = NLA_U64 },
 	[NFTA_COUNTER_BYTES]	= { .type = NLA_U64 },
@@ -133,7 +152,7 @@ static int nft_counter_clone(struct nft_expr *dst, const struct nft_expr *src)
 	struct nft_counter_percpu *this_cpu;
 	struct nft_counter total;
 
-	nft_counter_fetch(priv->counter, &total);
+	nft_counter_fetch(priv->counter, &total, false);
 
 	cpu_stats = __netdev_alloc_pcpu_stats(struct nft_counter_percpu,
 					      GFP_ATOMIC);
@@ -158,6 +177,7 @@ static const struct nft_expr_ops nft_counter_ops = {
 	.init		= nft_counter_init,
 	.destroy	= nft_counter_destroy,
 	.dump		= nft_counter_dump,
+	.reset		= nft_counter_reset,
 	.clone		= nft_counter_clone,
 };
 
-- 
2.1.4

