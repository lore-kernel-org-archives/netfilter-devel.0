From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nftables kernel PATCH v2] netfilter: nf_tables: allow to dump sets
	using NFPROTO_UNSPEC
Date: Mon, 11 Nov 2013 10:25:26 +0100
Message-ID: <20131111092513.29113.38444.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:59580 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750994Ab3KKJZh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Nov 2013 04:25:37 -0500
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id AAE7851ED8D
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Nov 2013 09:25:34 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0bOyiZiNEXsJ for <netfilter-devel@vger.kernel.org>;
	Mon, 11 Nov 2013 10:25:29 +0100 (CET)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 5B94251ED56
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Nov 2013 10:25:29 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows you to obtain all existing sets in all families. After
this patch, there are three possible combinations:

* Pass table name and family != NFPROTO_UNSPEC, to obtain sets
  that belong to a table.
* Pass family != NFPROTO_UNSPEC, to obtain all sets from a specific
  family.
* Pass family == NFPROTO_UNSPEC, to obtain all sets, no matter what
  table and family they belong to.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: fix some netlink issues by Pablo.
 net/netfilter/nf_tables_api.c |   64 +++++++++++++++++++++++++++++------------
 1 file changed, 45 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index dcddc49..d2540f8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1903,9 +1903,12 @@ static int nft_ctx_init_from_setattr(struct nft_ctx *ctx,
 {
 	struct net *net = sock_net(skb->sk);
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	const struct nft_af_info *afi;
+	const struct nft_af_info *afi = NULL;
 	const struct nft_table *table = NULL;
 
+	if (nfmsg->nfgen_family == AF_UNSPEC)
+		goto out;
+
 	afi = nf_tables_afinfo_lookup(net, nfmsg->nfgen_family, false);
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
@@ -1915,7 +1918,7 @@ static int nft_ctx_init_from_setattr(struct nft_ctx *ctx,
 		if (IS_ERR(table))
 			return PTR_ERR(table);
 	}
-
+out:
 	nft_ctx_init(ctx, skb, nlh, afi, table, NULL, nla);
 	return 0;
 }
@@ -2079,27 +2082,46 @@ static int nf_tables_dump_sets_all(struct nft_ctx *ctx, struct sk_buff *skb,
 {
 	const struct nft_set *set;
 	unsigned int idx = 0, s_idx = cb->args[0];
+	const struct nft_af_info *afi;
 	struct nft_table *table, *cur_table = (struct nft_table *)cb->args[2];
+	struct net *net = sock_net(skb->sk);
+	int family, cur_family = cb->args[3];
 
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
+		if (cur_family && afi->family != cur_family)
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
+		if (family != NFPROTO_UNSPEC && family != afi->family)
+			continue;
+
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
+					cb->args[3] = afi->family;
+					goto done;
+				}
 cont:
-			idx++;
+				idx++;
+			}
 		}
 	}
 	cb->args[1] = 1;
@@ -2138,12 +2160,16 @@ static int nf_tables_getset(struct sock *nlsk, struct sk_buff *skb,
 	const struct nft_set *set;
 	struct nft_ctx ctx;
 	struct sk_buff *skb2;
+	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	int err;
 
-	/* Verify existance before starting dump */
-	err = nft_ctx_init_from_setattr(&ctx, skb, nlh, nla);
-	if (err < 0)
-		return err;
+	if (nfmsg->nfgen_family != AF_UNSPEC) {
+		/* Verify existance before starting dump */
+		err = nft_ctx_init_from_setattr(&ctx, skb, nlh, nla);
+		if (err < 0)
+			return err;
+	}
+
 
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {

