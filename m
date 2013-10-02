From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nftables PATCH] netfilter: nf_tables: allow to dump sets with
	NFPROTO_UNSPEC
Date: Wed, 02 Oct 2013 18:37:05 +0200
Message-ID: <20131002163704.3148.24691.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:40778 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753434Ab3JBQhR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:37:17 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Allow the userspace to request a list of sets using NFPROTO_UNSPEC.

This avoid to iterate afs in userspace when you require the complete
set of nftables sets.

So, there are now 3 ways to query for sets:
 * giving table and af != NFPROTO_UNSPECT,
 * giving af != NFPROTO_UNSPECT,
 * giving af == NFPROTO_UNSPECT

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 net/netfilter/nf_tables_api.c |   63 +++++++++++++++++++++++++++--------------
 1 file changed, 42 insertions(+), 21 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f2d7f93..380e5bc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2079,27 +2079,42 @@ static int nf_tables_dump_sets_all(struct nft_ctx *ctx, struct sk_buff *skb,
 {
 	const struct nft_set *set;
 	unsigned int idx = 0, s_idx = cb->args[0];
+	const struct nft_af_info *afi;
 	struct nft_table *table, *cur_table = (struct nft_table *)cb->args[2];
+	struct net *net = sock_net(skb->sk);
+	int family;
 
 	if (cb->args[1])
 		return skb->len;
 
-	list_for_each_entry(table, &ctx->afi->tables, list) {
-		if (cur_table && cur_table != table)
+	if (ctx->afi == NULL)
+		family = NFPROTO_UNSPEC;
+	else
+		family = ctx->afi->family;
+
+	list_for_each_entry(afi, &net->nft.af_info, list) {
+		if (family != NFPROTO_UNSPEC && family != afi->family)
 			continue;
 
-		ctx->table = table;
-		list_for_each_entry(set, &ctx->table->sets, list) {
-			if (idx < s_idx)
-				goto cont;
-			if (nf_tables_fill_set(skb, ctx, set, NFT_MSG_NEWSET,
-					       NLM_F_MULTI) < 0) {
-				cb->args[0] = idx;
-				cb->args[2] = (unsigned long) table;
-				goto done;
-			}
+		list_for_each_entry(table, &afi->tables, list) {
+			if (cur_table && cur_table != table)
+				continue;
+
+			ctx->table = table;
+			ctx->afi = afi;
+			list_for_each_entry(set, &ctx->table->sets, list) {
+				if (idx < s_idx)
+					goto cont;
+				if (nf_tables_fill_set(skb, ctx, set,
+						       NFT_MSG_NEWSET,
+						       NLM_F_MULTI) < 0) {
+					cb->args[0] = idx;
+					cb->args[2] = (unsigned long) table;
+					goto done;
+				}
 cont:
-			idx++;
+				idx++;
+			}
 		}
 	}
 	cb->args[1] = 1;
@@ -2111,6 +2126,7 @@ static int nf_tables_dump_sets(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
 	struct nlattr *nla[NFTA_SET_MAX + 1];
+	const struct nft_af_info *afi = NULL;
 	struct nft_ctx ctx;
 	int err, ret;
 
@@ -2119,9 +2135,15 @@ static int nf_tables_dump_sets(struct sk_buff *skb, struct netlink_callback *cb)
 	if (err < 0)
 		return err;
 
-	err = nft_ctx_init_from_setattr(&ctx, cb->skb, cb->nlh, (void *)nla);
-	if (err < 0)
-		return err;
+	if (nfmsg->nfgen_family == NFPROTO_UNSPEC) {
+		nft_ctx_init(&ctx, cb->skb, cb->nlh, afi, NULL, NULL,
+			     (void *)nla);
+	} else {
+		err = nft_ctx_init_from_setattr(&ctx, cb->skb, cb->nlh,
+						(void *)nla);
+		if (err < 0)
+			return err;
+	}
 
 	if (ctx.table == NULL)
 		ret = nf_tables_dump_sets_all(&ctx, skb, cb);
@@ -2140,11 +2162,6 @@ static int nf_tables_getset(struct sock *nlsk, struct sk_buff *skb,
 	struct sk_buff *skb2;
 	int err;
 
-	/* Verify existance before starting dump */
-	err = nft_ctx_init_from_setattr(&ctx, skb, nlh, nla);
-	if (err < 0)
-		return err;
-
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.dump = nf_tables_dump_sets,
@@ -2152,6 +2169,10 @@ static int nf_tables_getset(struct sock *nlsk, struct sk_buff *skb,
 		return netlink_dump_start(nlsk, skb, nlh, &c);
 	}
 
+	err = nft_ctx_init_from_setattr(&ctx, skb, nlh, nla);
+	if (err < 0)
+		return err;
+
 	set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_NAME]);
 	if (IS_ERR(set))
 		return PTR_ERR(set);

