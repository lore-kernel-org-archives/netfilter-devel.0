Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECF530FF13
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Sep 2025 08:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757491407; cv=none; b=bbEe9d9LTIjCI3Y4PHkIPLDf/8t/iB40XMuUngRsBOeloV0mNYYk2bGkxiONH3vTzOEJJA/I2SU0wqOmEzO67Btr6XKHWA7NiQnz32CnQFIO2Eqcn+EX5jaYPABsrXjhql93ypThSQ1yA8GTUF74JfDp7KVQ6BUQzz1ZmD+wKVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757491407; c=relaxed/simple;
	bh=3zVQYOa1YVJi1+hemjfpjuhrIKT71CjTjnPBvnB2xWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NrIlNgjC8DxVPAazUbIo0V6dxwAl5OEz+kCiHbQE3/1g5zfVQNhMZ+2bLECh7e9yZIkLp8k51tGnN1LMBbDWwswccLDezBbQOopf3HQ4jdrqbsOi8qIOQA9P6NHHLYGc9H7BlXR4WAMWBQ44pls0446uEL+Em3ATpBcI2lvrXHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A5A036062E; Wed, 10 Sep 2025 10:03:22 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: s.hanreich@proxmox.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 3/5] netfilter: nf_tables: place base_seq in struct net
Date: Wed, 10 Sep 2025 10:02:20 +0200
Message-ID: <20250910080227.11174-4-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250910080227.11174-1-fw@strlen.de>
References: <20250910080227.11174-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will soon be read from packet path around same time as the gencursor.

Both gencursor and base_seq get incremented almost at the same time, so
it makes sense to place them in the same structure.

This doesn't increase struct net size on 64bit due to padding.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h |  1 -
 include/net/netns/nftables.h      |  1 +
 net/netfilter/nf_tables_api.c     | 65 ++++++++++++++++---------------
 3 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 891e43a01bdc..3faa80f5d801 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1912,7 +1912,6 @@ struct nftables_pernet {
 	struct mutex		commit_mutex;
 	u64			table_handle;
 	u64			tstamp;
-	unsigned int		base_seq;
 	unsigned int		gc_seq;
 	u8			validate_state;
 	struct work_struct	destroy_work;
diff --git a/include/net/netns/nftables.h b/include/net/netns/nftables.h
index cc8060c017d5..99dd166c5d07 100644
--- a/include/net/netns/nftables.h
+++ b/include/net/netns/nftables.h
@@ -3,6 +3,7 @@
 #define _NETNS_NFTABLES_H_
 
 struct netns_nftables {
+	unsigned int		base_seq;
 	u8			gencursor;
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c1082de09656..9518b50695ba 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1131,11 +1131,14 @@ nf_tables_chain_type_lookup(struct net *net, const struct nlattr *nla,
 	return ERR_PTR(-ENOENT);
 }
 
-static __be16 nft_base_seq(const struct net *net)
+static unsigned int nft_base_seq(const struct net *net)
 {
-	struct nftables_pernet *nft_net = nft_pernet(net);
+	return READ_ONCE(net->nft.base_seq);
+}
 
-	return htons(nft_net->base_seq & 0xffff);
+static __be16 nft_base_seq_be16(const struct net *net)
+{
+	return htons(nft_base_seq(net) & 0xffff);
 }
 
 static const struct nla_policy nft_table_policy[NFTA_TABLE_MAX + 1] = {
@@ -1155,7 +1158,7 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
 
 	nlh = nfnl_msg_put(skb, portid, seq,
 			   nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event),
-			   flags, family, NFNETLINK_V0, nft_base_seq(net));
+			   flags, family, NFNETLINK_V0, nft_base_seq_be16(net));
 	if (!nlh)
 		goto nla_put_failure;
 
@@ -1248,7 +1251,7 @@ static int nf_tables_dump_tables(struct sk_buff *skb,
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = READ_ONCE(nft_net->base_seq);
+	cb->seq = nft_base_seq(net);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
@@ -2030,7 +2033,7 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 
 	nlh = nfnl_msg_put(skb, portid, seq,
 			   nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event),
-			   flags, family, NFNETLINK_V0, nft_base_seq(net));
+			   flags, family, NFNETLINK_V0, nft_base_seq_be16(net));
 	if (!nlh)
 		goto nla_put_failure;
 
@@ -2133,7 +2136,7 @@ static int nf_tables_dump_chains(struct sk_buff *skb,
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = READ_ONCE(nft_net->base_seq);
+	cb->seq = nft_base_seq(net);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
@@ -3671,7 +3674,7 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
 	u16 type = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
 
 	nlh = nfnl_msg_put(skb, portid, seq, type, flags, family, NFNETLINK_V0,
-			   nft_base_seq(net));
+			   nft_base_seq_be16(net));
 	if (!nlh)
 		goto nla_put_failure;
 
@@ -3839,7 +3842,7 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = READ_ONCE(nft_net->base_seq);
+	cb->seq = nft_base_seq(net);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
@@ -4050,7 +4053,7 @@ static int nf_tables_getrule_reset(struct sk_buff *skb,
 	buf = kasprintf(GFP_ATOMIC, "%.*s:%u",
 			nla_len(nla[NFTA_RULE_TABLE]),
 			(char *)nla_data(nla[NFTA_RULE_TABLE]),
-			nft_net->base_seq);
+			nft_base_seq(net));
 	audit_log_nfcfg(buf, info->nfmsg->nfgen_family, 1,
 			AUDIT_NFT_OP_RULE_RESET, GFP_ATOMIC);
 	kfree(buf);
@@ -4887,7 +4890,7 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 	nlh = nfnl_msg_put(skb, portid, seq,
 			   nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event),
 			   flags, ctx->family, NFNETLINK_V0,
-			   nft_base_seq(ctx->net));
+			   nft_base_seq_be16(ctx->net));
 	if (!nlh)
 		goto nla_put_failure;
 
@@ -5032,7 +5035,7 @@ static int nf_tables_dump_sets(struct sk_buff *skb, struct netlink_callback *cb)
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = READ_ONCE(nft_net->base_seq);
+	cb->seq = nft_base_seq(net);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (ctx->family != NFPROTO_UNSPEC &&
@@ -6209,7 +6212,7 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = READ_ONCE(nft_net->base_seq);
+	cb->seq = nft_base_seq(net);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (dump_ctx->ctx.family != NFPROTO_UNSPEC &&
@@ -6238,7 +6241,7 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	seq    = cb->nlh->nlmsg_seq;
 
 	nlh = nfnl_msg_put(skb, portid, seq, event, NLM_F_MULTI,
-			   table->family, NFNETLINK_V0, nft_base_seq(net));
+			   table->family, NFNETLINK_V0, nft_base_seq_be16(net));
 	if (!nlh)
 		goto nla_put_failure;
 
@@ -6331,7 +6334,7 @@ static int nf_tables_fill_setelem_info(struct sk_buff *skb,
 
 	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
 	nlh = nfnl_msg_put(skb, portid, seq, event, flags, ctx->family,
-			   NFNETLINK_V0, nft_base_seq(ctx->net));
+			   NFNETLINK_V0, nft_base_seq_be16(ctx->net));
 	if (!nlh)
 		goto nla_put_failure;
 
@@ -6630,7 +6633,7 @@ static int nf_tables_getsetelem_reset(struct sk_buff *skb,
 		}
 		nelems++;
 	}
-	audit_log_nft_set_reset(dump_ctx.ctx.table, nft_net->base_seq, nelems);
+	audit_log_nft_set_reset(dump_ctx.ctx.table, nft_base_seq(info->net), nelems);
 
 out_unlock:
 	rcu_read_unlock();
@@ -8381,7 +8384,7 @@ static int nf_tables_fill_obj_info(struct sk_buff *skb, struct net *net,
 
 	nlh = nfnl_msg_put(skb, portid, seq,
 			   nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event),
-			   flags, family, NFNETLINK_V0, nft_base_seq(net));
+			   flags, family, NFNETLINK_V0, nft_base_seq_be16(net));
 	if (!nlh)
 		goto nla_put_failure;
 
@@ -8446,7 +8449,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = READ_ONCE(nft_net->base_seq);
+	cb->seq = nft_base_seq(net);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
@@ -8480,7 +8483,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 			idx++;
 		}
 		if (ctx->reset && entries)
-			audit_log_obj_reset(table, nft_net->base_seq, entries);
+			audit_log_obj_reset(table, nft_base_seq(net), entries);
 		if (rc < 0)
 			break;
 	}
@@ -8649,7 +8652,7 @@ static int nf_tables_getobj_reset(struct sk_buff *skb,
 	buf = kasprintf(GFP_ATOMIC, "%.*s:%u",
 			nla_len(nla[NFTA_OBJ_TABLE]),
 			(char *)nla_data(nla[NFTA_OBJ_TABLE]),
-			nft_net->base_seq);
+			nft_base_seq(net));
 	audit_log_nfcfg(buf, info->nfmsg->nfgen_family, 1,
 			AUDIT_NFT_OP_OBJ_RESET, GFP_ATOMIC);
 	kfree(buf);
@@ -8754,9 +8757,8 @@ void nft_obj_notify(struct net *net, const struct nft_table *table,
 		    struct nft_object *obj, u32 portid, u32 seq, int event,
 		    u16 flags, int family, int report, gfp_t gfp)
 {
-	struct nftables_pernet *nft_net = nft_pernet(net);
 	char *buf = kasprintf(gfp, "%s:%u",
-			      table->name, nft_net->base_seq);
+			      table->name, nft_base_seq(net));
 
 	audit_log_nfcfg(buf,
 			family,
@@ -9442,7 +9444,7 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 
 	nlh = nfnl_msg_put(skb, portid, seq,
 			   nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event),
-			   flags, family, NFNETLINK_V0, nft_base_seq(net));
+			   flags, family, NFNETLINK_V0, nft_base_seq_be16(net));
 	if (!nlh)
 		goto nla_put_failure;
 
@@ -9511,7 +9513,7 @@ static int nf_tables_dump_flowtable(struct sk_buff *skb,
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = READ_ONCE(nft_net->base_seq);
+	cb->seq = nft_base_seq(net);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
@@ -9696,17 +9698,16 @@ static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
 static int nf_tables_fill_gen_info(struct sk_buff *skb, struct net *net,
 				   u32 portid, u32 seq)
 {
-	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nlmsghdr *nlh;
 	char buf[TASK_COMM_LEN];
 	int event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, NFT_MSG_NEWGEN);
 
 	nlh = nfnl_msg_put(skb, portid, seq, event, 0, AF_UNSPEC,
-			   NFNETLINK_V0, nft_base_seq(net));
+			   NFNETLINK_V0, nft_base_seq_be16(net));
 	if (!nlh)
 		goto nla_put_failure;
 
-	if (nla_put_be32(skb, NFTA_GEN_ID, htonl(nft_net->base_seq)) ||
+	if (nla_put_be32(skb, NFTA_GEN_ID, htonl(nft_base_seq(net))) ||
 	    nla_put_be32(skb, NFTA_GEN_PROC_PID, htonl(task_pid_nr(current))) ||
 	    nla_put_string(skb, NFTA_GEN_PROC_NAME, get_task_comm(buf, current)))
 		goto nla_put_failure;
@@ -10968,11 +10969,11 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	 * Bump generation counter, invalidate any dump in progress.
 	 * Cannot fail after this point.
 	 */
-	base_seq = READ_ONCE(nft_net->base_seq);
+	base_seq = nft_base_seq(net);
 	while (++base_seq == 0)
 		;
 
-	WRITE_ONCE(nft_net->base_seq, base_seq);
+	WRITE_ONCE(net->nft.base_seq, base_seq);
 
 	gc_seq = nft_gc_seq_begin(nft_net);
 
@@ -11181,7 +11182,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 
 	nft_commit_notify(net, NETLINK_CB(skb).portid);
 	nf_tables_gen_notify(net, skb, NFT_MSG_NEWGEN);
-	nf_tables_commit_audit_log(&adl, nft_net->base_seq);
+	nf_tables_commit_audit_log(&adl, nft_base_seq(net));
 
 	nft_gc_seq_end(nft_net, gc_seq);
 	nft_net->validate_state = NFT_VALIDATE_SKIP;
@@ -11506,7 +11507,7 @@ static bool nf_tables_valid_genid(struct net *net, u32 genid)
 	mutex_lock(&nft_net->commit_mutex);
 	nft_net->tstamp = get_jiffies_64();
 
-	genid_ok = genid == 0 || nft_net->base_seq == genid;
+	genid_ok = genid == 0 || nft_base_seq(net) == genid;
 	if (!genid_ok)
 		mutex_unlock(&nft_net->commit_mutex);
 
@@ -12143,7 +12144,7 @@ static int __net_init nf_tables_init_net(struct net *net)
 	INIT_LIST_HEAD(&nft_net->module_list);
 	INIT_LIST_HEAD(&nft_net->notify_list);
 	mutex_init(&nft_net->commit_mutex);
-	nft_net->base_seq = 1;
+	net->nft.base_seq = 1;
 	nft_net->gc_seq = 0;
 	nft_net->validate_state = NFT_VALIDATE_SKIP;
 	INIT_WORK(&nft_net->destroy_work, nf_tables_trans_destroy_work);
-- 
2.49.1

