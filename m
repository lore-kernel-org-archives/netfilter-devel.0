From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/31] netfilter: nf_tables: avoid BUG_ON usage
Date: Tue,  9 Oct 2018 01:01:03 +0200
Message-ID: <20181008230125.2330-10-pablo@netfilter.org>
References: <20181008230125.2330-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181008230125.2330-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

None of these spots really needs to crash the kernel.
In one two cases we can jsut report error to userspace, in the other
cases we can just use WARN_ON (and leak memory instead).

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 9 ++++++---
 net/netfilter/nft_cmp.c       | 6 ++++--
 net/netfilter/nft_reject.c    | 6 ++++--
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 72dbdb1faa3c..f0159eea2978 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1021,7 +1021,8 @@ static int nf_tables_deltable(struct net *net, struct sock *nlsk,
 
 static void nf_tables_table_destroy(struct nft_ctx *ctx)
 {
-	BUG_ON(ctx->table->use > 0);
+	if (WARN_ON(ctx->table->use > 0))
+		return;
 
 	rhltable_destroy(&ctx->table->chains_ht);
 	kfree(ctx->table->name);
@@ -1428,7 +1429,8 @@ static void nf_tables_chain_destroy(struct nft_ctx *ctx)
 {
 	struct nft_chain *chain = ctx->chain;
 
-	BUG_ON(chain->use > 0);
+	if (WARN_ON(chain->use > 0))
+		return;
 
 	/* no concurrent access possible anymore */
 	nf_tables_chain_free_chain_rules(chain);
@@ -7243,7 +7245,8 @@ int __nft_release_basechain(struct nft_ctx *ctx)
 {
 	struct nft_rule *rule, *nr;
 
-	BUG_ON(!nft_is_base_chain(ctx->chain));
+	if (WARN_ON(!nft_is_base_chain(ctx->chain)))
+		return 0;
 
 	nf_tables_unregister_hook(ctx->net, ctx->chain->table, ctx->chain);
 	list_for_each_entry_safe(rule, nr, &ctx->chain->rules, list) {
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index fa90a8402845..79d48c1d06f4 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -79,7 +79,8 @@ static int nft_cmp_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 
 	err = nft_data_init(NULL, &priv->data, sizeof(priv->data), &desc,
 			    tb[NFTA_CMP_DATA]);
-	BUG_ON(err < 0);
+	if (err < 0)
+		return err;
 
 	priv->sreg = nft_parse_register(tb[NFTA_CMP_SREG]);
 	err = nft_validate_register_load(priv->sreg, desc.len);
@@ -129,7 +130,8 @@ static int nft_cmp_fast_init(const struct nft_ctx *ctx,
 
 	err = nft_data_init(NULL, &data, sizeof(data), &desc,
 			    tb[NFTA_CMP_DATA]);
-	BUG_ON(err < 0);
+	if (err < 0)
+		return err;
 
 	priv->sreg = nft_parse_register(tb[NFTA_CMP_SREG]);
 	err = nft_validate_register_load(priv->sreg, desc.len);
diff --git a/net/netfilter/nft_reject.c b/net/netfilter/nft_reject.c
index 29f5bd2377b0..b48e58cceeb7 100644
--- a/net/netfilter/nft_reject.c
+++ b/net/netfilter/nft_reject.c
@@ -94,7 +94,8 @@ static u8 icmp_code_v4[NFT_REJECT_ICMPX_MAX + 1] = {
 
 int nft_reject_icmp_code(u8 code)
 {
-	BUG_ON(code > NFT_REJECT_ICMPX_MAX);
+	if (WARN_ON_ONCE(code > NFT_REJECT_ICMPX_MAX))
+		return ICMP_NET_UNREACH;
 
 	return icmp_code_v4[code];
 }
@@ -111,7 +112,8 @@ static u8 icmp_code_v6[NFT_REJECT_ICMPX_MAX + 1] = {
 
 int nft_reject_icmpv6_code(u8 code)
 {
-	BUG_ON(code > NFT_REJECT_ICMPX_MAX);
+	if (WARN_ON_ONCE(code > NFT_REJECT_ICMPX_MAX))
+		return ICMPV6_NOROUTE;
 
 	return icmp_code_v6[code];
 }
-- 
2.11.0
