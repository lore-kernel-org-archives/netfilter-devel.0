From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: nf_tables: fix missing rules flushing per table
Date: Fri,  6 Dec 2013 12:59:19 +0100
Message-ID: <1386331159-4104-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44118 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757863Ab3LFL73 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Dec 2013 06:59:29 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows you to atomically remove all rules stored in
a table via the NFT_MSG_DELRULE command. You only need to indicate
the specific table and no chain to flush all rules stored in that
table.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
I already indicated this in october:

http://patchwork.ozlabs.org/patch/280192/

but this probably got lost. I'm going to submit to qualify this as fix
otherwise we won't have sane table flushing in the first nftables release.

 net/netfilter/nf_tables_api.c |   46 +++++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index dcddc49..237b49a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1717,6 +1717,19 @@ nf_tables_delrule_one(struct nft_ctx *ctx, struct nft_rule *rule)
 	return -ENOENT;
 }
 
+static int nf_table_delrule_by_chain(struct nft_ctx *ctx)
+{
+	struct nft_rule *rule, *tmp;
+	int err;
+
+	list_for_each_entry_safe(rule, tmp, &ctx->chain->rules, list) {
+		err = nf_tables_delrule_one(ctx, rule);
+		if (err < 0)
+			return err;
+	}
+	return 0;
+}
+
 static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 			     const struct nlmsghdr *nlh,
 			     const struct nlattr * const nla[])
@@ -1725,8 +1738,8 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 	const struct nft_af_info *afi;
 	struct net *net = sock_net(skb->sk);
 	const struct nft_table *table;
-	struct nft_chain *chain;
-	struct nft_rule *rule, *tmp;
+	struct nft_chain *chain = NULL;
+	struct nft_rule *rule;
 	int family = nfmsg->nfgen_family, err = 0;
 	struct nft_ctx ctx;
 
@@ -1738,22 +1751,29 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
-	chain = nf_tables_chain_lookup(table, nla[NFTA_RULE_CHAIN]);
-	if (IS_ERR(chain))
-		return PTR_ERR(chain);
+	if (nla[NFTA_RULE_CHAIN]) {
+		chain = nf_tables_chain_lookup(table, nla[NFTA_RULE_CHAIN]);
+		if (IS_ERR(chain))
+			return PTR_ERR(chain);
+	}
 
 	nft_ctx_init(&ctx, skb, nlh, afi, table, chain, nla);
 
-	if (nla[NFTA_RULE_HANDLE]) {
-		rule = nf_tables_rule_lookup(chain, nla[NFTA_RULE_HANDLE]);
-		if (IS_ERR(rule))
-			return PTR_ERR(rule);
+	if (chain) {
+		if (nla[NFTA_RULE_HANDLE]) {
+			rule = nf_tables_rule_lookup(chain,
+						     nla[NFTA_RULE_HANDLE]);
+			if (IS_ERR(rule))
+				return PTR_ERR(rule);
 
-		err = nf_tables_delrule_one(&ctx, rule);
-	} else {
-		/* Remove all rules in this chain */
-		list_for_each_entry_safe(rule, tmp, &chain->rules, list) {
 			err = nf_tables_delrule_one(&ctx, rule);
+		} else {
+			err = nf_table_delrule_by_chain(&ctx);
+		}
+	} else {
+		list_for_each_entry(chain, &table->chains, list) {
+			ctx.chain = chain;
+			err = nf_table_delrule_by_chain(&ctx);
 			if (err < 0)
 				break;
 		}
-- 
1.7.10.4

