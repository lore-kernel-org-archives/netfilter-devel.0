From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -nftables 1/3] netfilter: nf_tables: allow to dump all existing sets
Date: Thu, 19 Sep 2013 22:18:51 +0200
Message-ID: <1379621933-6064-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37703 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734Ab3ISUTB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Sep 2013 16:19:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If no table specified, dump all existing sets. This simplifies
userspace applications, which don't require to iterate over the
existing list of tables anymore to retrieve all the existing
sets.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |   96 +++++++++++++++++++++++++++++++----------
 1 file changed, 74 insertions(+), 22 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4bb0ea5..35e23b7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1901,15 +1901,17 @@ static int nft_ctx_init_from_setattr(struct nft_ctx *ctx,
 	struct net *net = sock_net(skb->sk);
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	const struct nft_af_info *afi;
-	const struct nft_table *table;
+	const struct nft_table *table = NULL;
 
 	afi = nf_tables_afinfo_lookup(net, nfmsg->nfgen_family, false);
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
-	table = nf_tables_table_lookup(afi, nla[NFTA_SET_TABLE]);
-	if (IS_ERR(table))
-		return PTR_ERR(table);
+	if (nla[NFTA_SET_TABLE] != NULL) {
+		table = nf_tables_table_lookup(afi, nla[NFTA_SET_TABLE]);
+		if (IS_ERR(table))
+			return PTR_ERR(table);
+	}
 
 	nft_ctx_init(ctx, skb, nlh, afi, table, NULL, nla);
 	return 0;
@@ -2044,14 +2046,70 @@ err:
 	return err;
 }
 
+static int nf_tables_dump_sets_table(struct nft_ctx *ctx, struct sk_buff *skb,
+				     struct netlink_callback *cb)
+{
+	const struct nft_set *set;
+	unsigned int idx = 0, s_idx = cb->args[0];
+
+	if (cb->args[1])
+		return skb->len;
+
+	list_for_each_entry(set, &ctx->table->sets, list) {
+		if (idx < s_idx)
+			goto cont;
+		if (nf_tables_fill_set(skb, ctx, set, NFT_MSG_NEWSET,
+				       NLM_F_MULTI) < 0) {
+			cb->args[0] = idx;
+			goto done;
+		}
+cont:
+		idx++;
+	}
+	cb->args[1] = 1;
+done:
+	return skb->len;
+}
+
+static int nf_tables_dump_sets_all(struct nft_ctx *ctx, struct sk_buff *skb,
+				   struct netlink_callback *cb)
+{
+	const struct nft_set *set;
+	unsigned int idx = 0, s_idx = cb->args[0];
+	struct nft_table *table, *cur_table = (struct nft_table *)cb->args[2];
+
+	if (cb->args[1])
+		return skb->len;
+
+	list_for_each_entry(table, &ctx->afi->tables, list) {
+		if (cur_table && cur_table != table)
+			continue;
+
+		ctx->table = table;
+		list_for_each_entry(set, &ctx->table->sets, list) {
+			if (idx < s_idx)
+				goto cont;
+			if (nf_tables_fill_set(skb, ctx, set, NFT_MSG_NEWSET,
+					       NLM_F_MULTI) < 0) {
+				cb->args[0] = idx;
+				cb->args[2] = (unsigned long) table;
+				goto done;
+			}
+cont:
+			idx++;
+		}
+	}
+	cb->args[1] = 1;
+done:
+	return skb->len;
+}
+
 static int nf_tables_dump_sets(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
 	struct nlattr *nla[NFTA_SET_MAX + 1];
-	const struct nft_set *set;
 	struct nft_ctx ctx;
-	unsigned int idx = 0, s_idx = cb->args[0];
-	int err;
+	int err, ret;
 
 	err = nlmsg_parse(cb->nlh, sizeof(*nfmsg), nla, NFTA_SET_MAX,
 			  nft_set_policy);
@@ -2062,21 +2120,12 @@ static int nf_tables_dump_sets(struct sk_buff *skb, struct netlink_callback *cb)
 	if (err < 0)
 		return err;
 
-	list_for_each_entry(set, &ctx.table->sets, list) {
-		if (idx < s_idx)
-			goto cont;
-		if (idx > s_idx)
-			memset(&cb->args[1], 0,
-			       sizeof(cb->args) - sizeof(cb->args[0]));
-		if (nf_tables_fill_set(skb, &ctx, set, NFT_MSG_NEWSET,
-				       NLM_F_MULTI) < 0)
-			goto done;
-cont:
-		idx++;
-	}
-done:
-	cb->args[0] = idx;
-	return skb->len;
+	if (ctx.table == NULL)
+		ret = nf_tables_dump_sets_all(&ctx, skb, cb);
+	else
+		ret = nf_tables_dump_sets_table(&ctx, skb, cb);
+
+	return ret;
 }
 
 static int nf_tables_getset(struct sock *nlsk, struct sk_buff *skb,
@@ -2273,6 +2322,9 @@ static int nf_tables_delset(struct sock *nlsk, struct sk_buff *skb,
 	struct nft_ctx ctx;
 	int err;
 
+	if (nla[NFTA_SET_TABLE] == NULL)
+		return -EINVAL;
+
 	err = nft_ctx_init_from_setattr(&ctx, skb, nlh, nla);
 	if (err < 0)
 		return err;
-- 
1.7.10.4

