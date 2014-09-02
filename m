From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nf_tables PATCH 5/6 v5] netfilter: nf_tables: extend NFT_MSG_DELTABLE to support flushing the ruleset
Date: Tue,  2 Sep 2014 16:42:26 +0200
Message-ID: <1409668946-8168-6-git-send-email-arturo.borrero.glez@gmail.com>
References: <1409668946-8168-1-git-send-email-arturo.borrero.glez@gmail.com>
Cc: pablo@netfilter.org, kaber@trash.net,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4.cica.es ([150.214.5.182]:49444 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753942AbaIBOmz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Sep 2014 10:42:55 -0400
In-Reply-To: <1409668946-8168-1-git-send-email-arturo.borrero.glez@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch extend the NFT_MSG_DELTABLE call to support flushing the entire
ruleset.

The options now are:
 * No family speficied, no table specified: flush all the ruleset.
 * Family specified, no table specified: flush all tables in the AF.
 * Family specified, table specified: flush the given table.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: address comments by Pablo:
    * don't return EINVAL if called with AF_UNSPEC and a concrete table.
    * A more generic function, nft_flush()

v3: no changes, resending the series.
v4: no changes, resending the series because v3 series was invalid.
v5: address comment by Pablo: delete set if the list of bindings is empty.

 net/netfilter/nf_tables_api.c |   75 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 71 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8f9bcce..2520ba7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -707,6 +707,69 @@ static int nf_tables_newtable(struct sock *nlsk, struct sk_buff *skb,
 	return 0;
 }
 
+static int nft_flush_table(struct nft_ctx *ctx)
+{
+	int err;
+	struct nft_chain *chain, *nc;
+	struct nft_set *set, *ns;
+
+	list_for_each_entry_safe(chain, nc, &ctx->table->chains, list) {
+		ctx->chain = chain;
+
+		err = nft_delrule_by_chain(ctx);
+		if (err < 0)
+			goto out;
+
+		err = nft_delchain(ctx);
+		if (err < 0)
+			goto out;
+	}
+
+	list_for_each_entry_safe(set, ns, &ctx->table->sets, list) {
+		if (set->flags & NFT_SET_ANONYMOUS &&
+		    !list_empty(&set->bindings))
+			continue;
+
+		err = nft_delset(ctx, set);
+		if (err < 0)
+			goto out;
+	}
+
+	err = nft_deltable(ctx);
+out:
+	return err;
+}
+
+static int nft_flush(struct nft_ctx *ctx, int family)
+{
+	struct nft_af_info *afi;
+	struct nft_table *table, *nt;
+	const struct nlattr * const *nla = ctx->nla;
+	int err = 0;
+
+	list_for_each_entry(afi, &ctx->net->nft.af_info, list) {
+		if (family != AF_UNSPEC && afi->family != family)
+			continue;
+
+		ctx->afi = afi;
+
+		list_for_each_entry_safe(table, nt, &afi->tables, list) {
+			if (nla[NFTA_TABLE_NAME] &&
+			    nla_strcmp(nla[NFTA_TABLE_NAME], table->name) != 0)
+				continue;
+
+			ctx->table = table;
+
+			err = nft_flush_table(ctx);
+			if (err < 0)
+				goto out;
+		}
+	}
+
+out:
+	return err;
+}
+
 static int nf_tables_deltable(struct sock *nlsk, struct sk_buff *skb,
 			      const struct nlmsghdr *nlh,
 			      const struct nlattr * const nla[])
@@ -718,6 +781,11 @@ static int nf_tables_deltable(struct sock *nlsk, struct sk_buff *skb,
 	int family = nfmsg->nfgen_family;
 	struct nft_ctx ctx;
 
+	nft_ctx_init(&ctx, skb, nlh, NULL, NULL, NULL, nla);
+	if (family == AF_UNSPEC || nla[NFTA_TABLE_NAME] == NULL)
+		return nft_flush(&ctx, family);
+
+
 	afi = nf_tables_afinfo_lookup(net, family, false);
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
@@ -727,12 +795,11 @@ static int nf_tables_deltable(struct sock *nlsk, struct sk_buff *skb,
 		return PTR_ERR(table);
 	if (table->flags & NFT_TABLE_INACTIVE)
 		return -ENOENT;
-	if (table->use > 0)
-		return -EBUSY;
 
-	nft_ctx_init(&ctx, skb, nlh, afi, table, NULL, nla);
+	ctx.afi = afi;
+	ctx.table = table;
 
-	return nft_deltable(&ctx);
+	return nft_flush_table(&ctx);
 }
 
 static void nf_tables_table_destroy(struct nft_ctx *ctx)
-- 
1.7.10.4

