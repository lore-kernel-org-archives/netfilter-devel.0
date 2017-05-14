From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: nf_tables: can't assume lock is acquired when dumping set elems
Date: Sun, 14 May 2017 21:35:22 +0800
Message-ID: <20170514133522.20980-1-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:60273 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752775AbdENNf6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 May 2017 09:35:58 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

When dumping the elements related to a specified set, we may invoke the
nf_tables_dump_set with the NFNL_SUBSYS_NFTABLES lock not acquired. So
we should use the proper rcu operation to avoid race condition, just
like other nft dump operations.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nf_tables_api.c | 78 +++++++++++++++++++++++++++++++------------
 net/netfilter/nft_set_hash.c  |  2 +-
 2 files changed, 57 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5592250..5f4a4d4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3367,35 +3367,50 @@ static int nf_tables_dump_setelem(const struct nft_ctx *ctx,
 	return nf_tables_fill_setelem(args->skb, set, elem);
 }
 
+struct nft_set_dump_ctx {
+	const struct nft_set	*set;
+	struct nft_ctx		ctx;
+};
+
 static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 {
+	struct nft_set_dump_ctx *dump_ctx = cb->data;
 	struct net *net = sock_net(skb->sk);
-	u8 genmask = nft_genmask_cur(net);
+	struct nft_af_info *afi;
+	struct nft_table *table;
 	struct nft_set *set;
 	struct nft_set_dump_args args;
-	struct nft_ctx ctx;
-	struct nlattr *nla[NFTA_SET_ELEM_LIST_MAX + 1];
+	bool set_found = false;
 	struct nfgenmsg *nfmsg;
 	struct nlmsghdr *nlh;
 	struct nlattr *nest;
 	u32 portid, seq;
-	int event, err;
+	int event;
 
-	err = nlmsg_parse(cb->nlh, sizeof(struct nfgenmsg), nla,
-			  NFTA_SET_ELEM_LIST_MAX, nft_set_elem_list_policy,
-			  NULL);
-	if (err < 0)
-		return err;
+	rcu_read_lock();
+	list_for_each_entry_rcu(afi, &net->nft.af_info, list) {
+		if (afi != dump_ctx->ctx.afi)
+			continue;
 
-	err = nft_ctx_init_from_elemattr(&ctx, net, cb->skb, cb->nlh,
-					 (void *)nla, genmask);
-	if (err < 0)
-		return err;
+		list_for_each_entry_rcu(table, &afi->tables, list) {
+			if (table != dump_ctx->ctx.table)
+				continue;
 
-	set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_ELEM_LIST_SET],
-				   genmask);
-	if (IS_ERR(set))
-		return PTR_ERR(set);
+			list_for_each_entry_rcu(set, &table->sets, list) {
+				if (set == dump_ctx->set) {
+					set_found = true;
+					break;
+				}
+			}
+			break;
+		}
+		break;
+	}
+
+	if (!set_found) {
+		rcu_read_unlock();
+		return -ENOENT;
+	}
 
 	event  = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, NFT_MSG_NEWSETELEM);
 	portid = NETLINK_CB(cb->skb).portid;
@@ -3407,11 +3422,11 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 		goto nla_put_failure;
 
 	nfmsg = nlmsg_data(nlh);
-	nfmsg->nfgen_family = ctx.afi->family;
+	nfmsg->nfgen_family = afi->family;
 	nfmsg->version      = NFNETLINK_V0;
-	nfmsg->res_id	    = htons(ctx.net->nft.base_seq & 0xffff);
+	nfmsg->res_id	    = htons(net->nft.base_seq & 0xffff);
 
-	if (nla_put_string(skb, NFTA_SET_ELEM_LIST_TABLE, ctx.table->name))
+	if (nla_put_string(skb, NFTA_SET_ELEM_LIST_TABLE, table->name))
 		goto nla_put_failure;
 	if (nla_put_string(skb, NFTA_SET_ELEM_LIST_SET, set->name))
 		goto nla_put_failure;
@@ -3422,12 +3437,13 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 
 	args.cb			= cb;
 	args.skb		= skb;
-	args.iter.genmask	= nft_genmask_cur(ctx.net);
+	args.iter.genmask	= nft_genmask_cur(net);
 	args.iter.skip		= cb->args[0];
 	args.iter.count		= 0;
 	args.iter.err		= 0;
 	args.iter.fn		= nf_tables_dump_setelem;
-	set->ops->walk(&ctx, set, &args.iter);
+	set->ops->walk(&dump_ctx->ctx, set, &args.iter);
+	rcu_read_unlock();
 
 	nla_nest_end(skb, nest);
 	nlmsg_end(skb, nlh);
@@ -3441,9 +3457,16 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 
 nla_put_failure:
+	rcu_read_unlock();
 	return -ENOSPC;
 }
 
+static int nf_tables_dump_set_done(struct netlink_callback *cb)
+{
+	kfree(cb->data);
+	return 0;
+}
+
 static int nf_tables_getsetelem(struct net *net, struct sock *nlsk,
 				struct sk_buff *skb, const struct nlmsghdr *nlh,
 				const struct nlattr * const nla[])
@@ -3465,7 +3488,18 @@ static int nf_tables_getsetelem(struct net *net, struct sock *nlsk,
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.dump = nf_tables_dump_set,
+			.done = nf_tables_dump_set_done,
 		};
+		struct nft_set_dump_ctx *dump_ctx;
+
+		dump_ctx = kmalloc(sizeof(*dump_ctx), GFP_KERNEL);
+		if (!dump_ctx)
+			return -ENOMEM;
+
+		dump_ctx->set = set;
+		dump_ctx->ctx = ctx;
+
+		c.data = dump_ctx;
 		return netlink_dump_start(nlsk, skb, nlh, &c);
 	}
 	return -EOPNOTSUPP;
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 8ec086b..3d3a6df 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -222,7 +222,7 @@ static void nft_hash_walk(const struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_set_elem elem;
 	int err;
 
-	err = rhashtable_walk_init(&priv->ht, &hti, GFP_KERNEL);
+	err = rhashtable_walk_init(&priv->ht, &hti, GFP_ATOMIC);
 	iter->err = err;
 	if (err)
 		return;
-- 
2.9.3


