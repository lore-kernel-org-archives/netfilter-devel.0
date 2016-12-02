From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v2,nf-next 05/11] netfilter: nf_tables: atomic dump and reset for stateful objects
Date: Fri,  2 Dec 2016 19:08:35 +0100
Message-ID: <1480702121-1782-6-git-send-email-pablo@netfilter.org>
References: <1480702121-1782-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47522 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751387AbcLBSJY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Dec 2016 13:09:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 015A8D1630
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Dec 2016 19:08:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E2A80DA729
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Dec 2016 19:08:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B17D0DA729
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Dec 2016 19:08:54 +0100 (CET)
In-Reply-To: <1480702121-1782-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a new NFT_MSG_GETOBJ_RESET command perform an atomic
dump-and-reset of the stateful object. This also comes with add support
for atomic dump and reset for counter and quota objects.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: Remove unnecessary nft_obj_dump() function, embed this code into
    fill_info function.

 include/net/netfilter/nf_tables.h        |  3 ++-
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c            | 29 ++++++++++++++++++++--------
 net/netfilter/nft_counter.c              | 33 ++++++++++++++++++++------------
 net/netfilter/nft_quota.c                | 12 +++++++-----
 5 files changed, 53 insertions(+), 26 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 16b6824dbdf6..20fb731a69f6 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -995,7 +995,8 @@ struct nft_object_type {
 						struct nft_object *obj);
 	void				(*destroy)(struct nft_object *obj);
 	int				(*dump)(struct sk_buff *skb,
-						const struct nft_object *obj);
+						struct nft_object *obj,
+						bool reset);
 };
 
 int nft_register_obj(struct nft_object_type *obj_type);
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index e95d5f4f136b..e1b11aa777f2 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -89,6 +89,7 @@ enum nft_verdicts {
  * @NFT_MSG_NEWOBJ: create a stateful object (enum nft_obj_attributes)
  * @NFT_MSG_GETOBJ: get a stateful object (enum nft_obj_attributes)
  * @NFT_MSG_DELOBJ: delete a stateful object (enum nft_obj_attributes)
+ * @NFT_MSG_GETOBJ_RESET: get and reset a stateful object (enum nft_obj_attributes)
  */
 enum nf_tables_msg_types {
 	NFT_MSG_NEWTABLE,
@@ -112,6 +113,7 @@ enum nf_tables_msg_types {
 	NFT_MSG_NEWOBJ,
 	NFT_MSG_GETOBJ,
 	NFT_MSG_DELOBJ,
+	NFT_MSG_GETOBJ_RESET,
 	NFT_MSG_MAX,
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fb5bc02c2ee8..6258a659d422 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3964,14 +3964,14 @@ static struct nft_object *nft_obj_init(const struct nft_object_type *type,
 }
 
 static int nft_object_dump(struct sk_buff *skb, unsigned int attr,
-			   const struct nft_object *obj)
+			   struct nft_object *obj, bool reset)
 {
 	struct nlattr *nest;
 
 	nest = nla_nest_start(skb, attr);
 	if (!nest)
 		goto nla_put_failure;
-	if (obj->type->dump(skb, obj) < 0)
+	if (obj->type->dump(skb, obj, reset) < 0)
 		goto nla_put_failure;
 	nla_nest_end(skb, nest);
 	return 0;
@@ -4088,7 +4088,7 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 static int nf_tables_fill_obj_info(struct sk_buff *skb, struct net *net,
 				   u32 portid, u32 seq, int event, u32 flags,
 				   int family, const struct nft_table *table,
-				   const struct nft_object *obj)
+				   struct nft_object *obj, bool reset)
 {
 	struct nfgenmsg *nfmsg;
 	struct nlmsghdr *nlh;
@@ -4107,7 +4107,7 @@ static int nf_tables_fill_obj_info(struct sk_buff *skb, struct net *net,
 	    nla_put_string(skb, NFTA_OBJ_NAME, obj->name) ||
 	    nla_put_be32(skb, NFTA_OBJ_TYPE, htonl(obj->type->type)) ||
 	    nla_put_be32(skb, NFTA_OBJ_USE, htonl(obj->use)) ||
-	    nft_object_dump(skb, NFTA_OBJ_DATA, obj))
+	    nft_object_dump(skb, NFTA_OBJ_DATA, obj, reset))
 		goto nla_put_failure;
 
 	nlmsg_end(skb, nlh);
@@ -4123,10 +4123,14 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 	const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
 	const struct nft_af_info *afi;
 	const struct nft_table *table;
-	const struct nft_object *obj;
 	unsigned int idx = 0, s_idx = cb->args[0];
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
+	struct nft_object *obj;
+	bool reset = false;
+
+	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
+		reset = true;
 
 	rcu_read_lock();
 	cb->seq = net->nft.base_seq;
@@ -4148,7 +4152,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 							    cb->nlh->nlmsg_seq,
 							    NFT_MSG_NEWOBJ,
 							    NLM_F_MULTI | NLM_F_APPEND,
-							    afi->family, table, obj) < 0)
+							    afi->family, table, obj, reset) < 0)
 					goto done;
 
 				nl_dump_check_consistent(cb, nlmsg_hdr(skb));
@@ -4175,6 +4179,7 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 	const struct nft_table *table;
 	struct nft_object *obj;
 	struct sk_buff *skb2;
+	bool reset = false;
 	u32 objtype;
 	int err;
 
@@ -4206,9 +4211,12 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 	if (!skb2)
 		return -ENOMEM;
 
+	if (NFNL_MSG_TYPE(nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
+		reset = true;
+
 	err = nf_tables_fill_obj_info(skb2, net, NETLINK_CB(skb).portid,
 				      nlh->nlmsg_seq, NFT_MSG_NEWOBJ, 0,
-				      family, table, obj);
+				      family, table, obj, reset);
 	if (err < 0)
 		goto err;
 
@@ -4283,7 +4291,7 @@ static int nf_tables_obj_notify(const struct nft_ctx *ctx,
 
 	err = nf_tables_fill_obj_info(skb, ctx->net, ctx->portid, ctx->seq,
 				      event, 0, ctx->afi->family, ctx->table,
-				      obj);
+				      obj, false);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
@@ -4474,6 +4482,11 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.attr_count	= NFTA_OBJ_MAX,
 		.policy		= nft_obj_policy,
 	},
+	[NFT_MSG_GETOBJ_RESET] = {
+		.call		= nf_tables_getobj,
+		.attr_count	= NFTA_OBJ_MAX,
+		.policy		= nft_obj_policy,
+	},
 };
 
 static void nft_chain_commit_update(struct nft_trans *trans)
diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index 6f3dd429f865..90e42140ee7b 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -100,21 +100,29 @@ static void nft_counter_obj_destroy(struct nft_object *obj)
 	nft_counter_do_destroy(priv);
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
@@ -123,11 +131,12 @@ static void nft_counter_fetch(const struct nft_counter_percpu __percpu *counter,
 }
 
 static int nft_counter_do_dump(struct sk_buff *skb,
-			       const struct nft_counter_percpu_priv *priv)
+			       const struct nft_counter_percpu_priv *priv,
+			       bool reset)
 {
 	struct nft_counter total;
 
-	nft_counter_fetch(priv->counter, &total);
+	nft_counter_fetch(priv->counter, &total, reset);
 
 	if (nla_put_be64(skb, NFTA_COUNTER_BYTES, cpu_to_be64(total.bytes),
 			 NFTA_COUNTER_PAD) ||
@@ -141,11 +150,11 @@ static int nft_counter_do_dump(struct sk_buff *skb,
 }
 
 static int nft_counter_obj_dump(struct sk_buff *skb,
-				const struct nft_object *obj)
+				struct nft_object *obj, bool reset)
 {
-	const struct nft_counter_percpu_priv *priv = nft_obj_data(obj);
+	struct nft_counter_percpu_priv *priv = nft_obj_data(obj);
 
-	return nft_counter_do_dump(skb, priv);
+	return nft_counter_do_dump(skb, priv, reset);
 }
 
 static const struct nla_policy nft_counter_policy[NFTA_COUNTER_MAX + 1] = {
@@ -178,7 +187,7 @@ static int nft_counter_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_counter_percpu_priv *priv = nft_expr_priv(expr);
 
-	return nft_counter_do_dump(skb, priv);
+	return nft_counter_do_dump(skb, priv, false);
 }
 
 static int nft_counter_init(const struct nft_ctx *ctx,
@@ -206,7 +215,7 @@ static int nft_counter_clone(struct nft_expr *dst, const struct nft_expr *src)
 	struct nft_counter_percpu *this_cpu;
 	struct nft_counter total;
 
-	nft_counter_fetch(priv->counter, &total);
+	nft_counter_fetch(priv->counter, &total, false);
 
 	cpu_stats = __netdev_alloc_pcpu_stats(struct nft_counter_percpu,
 					      GFP_ATOMIC);
diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index 09ce72b1d6bf..6fcd41b1a251 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -83,7 +83,8 @@ static int nft_quota_obj_init(const struct nlattr * const tb[],
 	return nft_quota_do_init(tb, priv);
 }
 
-static int nft_quota_do_dump(struct sk_buff *skb, const struct nft_quota *priv)
+static int nft_quota_do_dump(struct sk_buff *skb, struct nft_quota *priv,
+			     bool reset)
 {
 	u32 flags = priv->invert ? NFT_QUOTA_F_INV : 0;
 
@@ -97,11 +98,12 @@ static int nft_quota_do_dump(struct sk_buff *skb, const struct nft_quota *priv)
 	return -1;
 }
 
-static int nft_quota_obj_dump(struct sk_buff *skb, const struct nft_object *obj)
+static int nft_quota_obj_dump(struct sk_buff *skb, struct nft_object *obj,
+			      bool reset)
 {
 	struct nft_quota *priv = nft_obj_data(obj);
 
-	return nft_quota_do_dump(skb, priv);
+	return nft_quota_do_dump(skb, priv, reset);
 }
 
 static struct nft_object_type nft_quota_obj __read_mostly = {
@@ -135,9 +137,9 @@ static int nft_quota_init(const struct nft_ctx *ctx,
 
 static int nft_quota_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
-	const struct nft_quota *priv = nft_expr_priv(expr);
+	struct nft_quota *priv = nft_expr_priv(expr);
 
-	return nft_quota_do_dump(skb, priv);
+	return nft_quota_do_dump(skb, priv, false);
 }
 
 static struct nft_expr_type nft_quota_type;
-- 
2.1.4

