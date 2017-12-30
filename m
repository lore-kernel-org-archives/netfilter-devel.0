From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next RFC 3/8] netfilter: nf_tables: no need for struct nft_af_info to enable/disable table
Date: Sun, 31 Dec 2017 00:13:43 +0100
Message-ID: <20171230231348.5497-4-pablo@netfilter.org>
References: <20171230231348.5497-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39210 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750996AbdL3XN5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Dec 2017 18:13:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CCDF1C51A9
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:13:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BA98271D7
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:13:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B198471D7
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:13:53 +0100 (CET)
Received: from salvia.here (40.red-212-170-55.staticip.rima-tde.net [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8F8844265A32
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:13:53 +0100 (CET)
In-Reply-To: <20171230231348.5497-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nf_tables_table_enable() and nf_tables_table_disable() take a pointer to
struct nft_af_info that is never used, remove it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d696b3bad861..a5590a0106e9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -575,10 +575,7 @@ static int nf_tables_gettable(struct net *net, struct sock *nlsk,
 	return err;
 }
 
-static void _nf_tables_table_disable(struct net *net,
-				     const struct nft_af_info *afi,
-				     struct nft_table *table,
-				     u32 cnt)
+static void nft_table_disable(struct net *net, struct nft_table *table, u32 cnt)
 {
 	struct nft_chain *chain;
 	u32 i = 0;
@@ -596,9 +593,7 @@ static void _nf_tables_table_disable(struct net *net,
 	}
 }
 
-static int nf_tables_table_enable(struct net *net,
-				  const struct nft_af_info *afi,
-				  struct nft_table *table)
+static int nf_tables_table_enable(struct net *net, struct nft_table *table)
 {
 	struct nft_chain *chain;
 	int err, i = 0;
@@ -618,15 +613,13 @@ static int nf_tables_table_enable(struct net *net,
 	return 0;
 err:
 	if (i)
-		_nf_tables_table_disable(net, afi, table, i);
+		nft_table_disable(net, table, i);
 	return err;
 }
 
-static void nf_tables_table_disable(struct net *net,
-				    const struct nft_af_info *afi,
-				    struct nft_table *table)
+static void nf_tables_table_disable(struct net *net, struct nft_table *table)
 {
-	_nf_tables_table_disable(net, afi, table, 0);
+	nft_table_disable(net, table, 0);
 }
 
 static int nf_tables_updtable(struct nft_ctx *ctx)
@@ -655,7 +648,7 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 		nft_trans_table_enable(trans) = false;
 	} else if (!(flags & NFT_TABLE_F_DORMANT) &&
 		   ctx->table->flags & NFT_TABLE_F_DORMANT) {
-		ret = nf_tables_table_enable(ctx->net, ctx->afi, ctx->table);
+		ret = nf_tables_table_enable(ctx->net, ctx->table);
 		if (ret >= 0) {
 			ctx->table->flags &= ~NFT_TABLE_F_DORMANT;
 			nft_trans_table_enable(trans) = true;
@@ -5088,7 +5081,6 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			if (nft_trans_table_update(trans)) {
 				if (!nft_trans_table_enable(trans)) {
 					nf_tables_table_disable(net,
-								trans->ctx.afi,
 								trans->ctx.table);
 					trans->ctx.table->flags |= NFT_TABLE_F_DORMANT;
 				}
@@ -5232,7 +5224,6 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb)
 			if (nft_trans_table_update(trans)) {
 				if (nft_trans_table_enable(trans)) {
 					nf_tables_table_disable(net,
-								trans->ctx.afi,
 								trans->ctx.table);
 					trans->ctx.table->flags |= NFT_TABLE_F_DORMANT;
 				}
-- 
2.11.0

