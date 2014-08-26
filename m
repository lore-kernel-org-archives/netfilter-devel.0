From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nf_tables PATCH 5/5] netfilter: nf_tables: extend NFT_MSG_DELTABLE
 to support flushing the ruleset
Date: Tue, 26 Aug 2014 11:57:01 +0200
Message-ID: <20140826095700.3266.48972.stgit@nfdev.cica.es>
References: <20140826095238.3266.80742.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:47562 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754161AbaHZJ5E (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:57:04 -0400
In-Reply-To: <20140826095238.3266.80742.stgit@nfdev.cica.es>
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
 net/netfilter/nf_tables_api.c |   84 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 80 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d954eed..917bbc2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -698,6 +698,72 @@ static int nf_tables_newtable(struct sock *nlsk, struct sk_buff *skb,
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
+		if (set->flags & NFT_SET_ANONYMOUS)
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
+static int nft_flush_family(struct nft_ctx *ctx)
+{
+	int err = 0;
+	struct nft_table *table, *nt;
+
+	list_for_each_entry_safe(table, nt, &ctx->afi->tables, list) {
+		ctx->table = table;
+
+		err = nft_flush_table(ctx);
+		if (err < 0)
+			goto out;
+	}
+
+out:
+	return err;
+}
+
+static int nft_flush_ruleset(struct nft_ctx *ctx)
+{
+	int err = 0;
+	struct nft_af_info *afi;
+
+	list_for_each_entry(afi, &ctx->net->nft.af_info, list) {
+		ctx->afi = afi;
+
+		err = nft_flush_family(ctx);
+		if (err < 0)
+			goto out;
+	}
+
+out:
+	return err;
+}
+
 static int nf_tables_deltable(struct sock *nlsk, struct sk_buff *skb,
 			      const struct nlmsghdr *nlh,
 			      const struct nlattr * const nla[])
@@ -709,21 +775,31 @@ static int nf_tables_deltable(struct sock *nlsk, struct sk_buff *skb,
 	int family = nfmsg->nfgen_family;
 	struct nft_ctx ctx;
 
+	if (family == NFPROTO_UNSPEC) {
+		if (nla[NFTA_TABLE_NAME] != NULL)
+			return -EINVAL;
+
+		nft_ctx_init(&ctx, skb, nlh, NULL, NULL, NULL, nla);
+		return nft_flush_ruleset(&ctx);
+	}
+
 	afi = nf_tables_afinfo_lookup(net, family, false);
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
 
+	if (nla[NFTA_TABLE_NAME] == NULL) {
+		nft_ctx_init(&ctx, skb, nlh, afi, NULL, NULL, nla);
+		return nft_flush_family(&ctx);
+	}
+
 	table = nf_tables_table_lookup(afi, nla[NFTA_TABLE_NAME]);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 	if (table->flags & NFT_TABLE_INACTIVE)
 		return -ENOENT;
-	if (table->use > 0)
-		return -EBUSY;
 
 	nft_ctx_init(&ctx, skb, nlh, afi, table, NULL, nla);
-
-	return nft_deltable(&ctx);
+	return nft_flush_table(&ctx);
 }
 
 static void nf_tables_table_destroy(struct nft_ctx *ctx)

