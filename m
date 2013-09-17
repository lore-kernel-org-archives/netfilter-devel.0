From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -nftables v3 4/4] netfilter: nf_tables: all rule updates are transactional
Date: Wed, 18 Sep 2013 00:14:10 +0200
Message-ID: <1379456050-4016-2-git-send-email-pablo@netfilter.org>
References: <1379456050-4016-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35374 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271Ab3IQWOU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Sep 2013 18:14:20 -0400
In-Reply-To: <1379456050-4016-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch makes all rule updates transactional, this simplifies
the ruleset update logic. Suggested by Patrick McHardy.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: fix rule replacement case

 include/uapi/linux/netfilter/nf_tables.h |    5 ---
 net/netfilter/nf_tables_api.c            |   69 +++++++-----------------------
 2 files changed, 16 insertions(+), 58 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index cbb5c75..b8cd62f 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -120,11 +120,6 @@ enum nft_chain_attributes {
 };
 #define NFTA_CHAIN_MAX		(__NFTA_CHAIN_MAX - 1)
 
-enum {
-	NFT_RULE_F_COMMIT       = (1 << 0),
-	NFT_RULE_F_MASK         = NFT_RULE_F_COMMIT,
-};
-
 /**
  * enum nft_rule_attributes - nf_tables rule netlink attributes
  *
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d65f6e3..755d596 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1572,7 +1572,6 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	unsigned int size, i, n;
 	int err, rem;
 	bool create;
-	u32 flags = 0;
 	u64 handle, pos_handle;
 
 	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
@@ -1641,14 +1640,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	if (rule == NULL)
 		goto err1;
 
-	if (nla[NFTA_RULE_FLAGS]) {
-		flags = ntohl(nla_get_be32(nla[NFTA_RULE_FLAGS]));
-		if (flags & ~NFT_RULE_F_MASK)
-			return -EINVAL;
-
-		if (flags & NFT_RULE_F_COMMIT)
-			nft_rule_activate_next(net, rule);
-	}
+	nft_rule_activate_next(net, rule);
 
 	rule->handle = handle;
 	rule->dlen   = size;
@@ -1663,16 +1655,11 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	}
 
 	if (nlh->nlmsg_flags & NLM_F_REPLACE) {
-		if (flags & NFT_RULE_F_COMMIT) {
-			nft_rule_disactivate_next(net, old_rule);
-			rupd = nf_tables_trans_add(old_rule, &ctx);
-			if (rupd == NULL)
-				goto err2;
-			list_add_tail_rcu(&rule->list, &chain->rules);
-		} else {
-			list_replace_rcu(&old_rule->list, &rule->list);
-			nf_tables_rule_destroy(old_rule);
-		}
+		nft_rule_disactivate_next(net, old_rule);
+		rupd = nf_tables_trans_add(old_rule, &ctx);
+		if (rupd == NULL)
+			goto err2;
+		list_add_tail_rcu(&rule->list, &chain->rules);
 	} else if (nlh->nlmsg_flags & NLM_F_APPEND)
 		if (old_rule)
 			list_add_rcu(&rule->list, &old_rule->list);
@@ -1685,16 +1672,9 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 			list_add_rcu(&rule->list, &chain->rules);
 	}
 
-	if (flags & NFT_RULE_F_COMMIT) {
-		if (nf_tables_trans_add(rule, &ctx) == NULL) {
-			err = -ENOMEM;
-			goto err3;
-		}
-	} else {
-		nf_tables_rule_notify(skb, nlh, table, chain, rule,
-				      NFT_MSG_NEWRULE,
-				      nlh->nlmsg_flags & (NLM_F_APPEND | NLM_F_REPLACE),
-				      nfmsg->nfgen_family);
+	if (nf_tables_trans_add(rule, &ctx) == NULL) {
+		err = -ENOMEM;
+		goto err3;
 	}
 	return 0;
 
@@ -1715,22 +1695,13 @@ err1:
 }
 
 static int
-nf_tables_delrule_one(struct nft_ctx *ctx, struct nft_rule *rule, u32 flags)
+nf_tables_delrule_one(struct nft_ctx *ctx, struct nft_rule *rule)
 {
-	int err = 0;
+	nft_rule_disactivate_next(ctx->net, rule);
+	if (nf_tables_trans_add(rule, ctx) == NULL)
+		return -ENOMEM;
 
-	if (flags & NFT_RULE_F_COMMIT) {
-		nft_rule_disactivate_next(ctx->net, rule);
-		if (nf_tables_trans_add(rule, ctx) == NULL)
-			err = -ENOMEM;
-	} else {
-		list_del_rcu(&rule->list);
-		nf_tables_rule_notify(ctx->skb, ctx->nlh, ctx->table,
-				      ctx->chain, rule, NFT_MSG_DELRULE,
-				      0, ctx->afi->family);
-		nf_tables_rule_destroy(rule);
-	}
-	return err;
+	return 0;
 }
 
 static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
@@ -1745,7 +1716,6 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 	struct nft_rule *rule, *tmp;
 	int family = nfmsg->nfgen_family, err = 0;
 	struct nft_ctx ctx;
-	u32 flags = 0;
 
 	afi = nf_tables_afinfo_lookup(net, family, false);
 	if (IS_ERR(afi))
@@ -1761,23 +1731,16 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 
 	nft_ctx_init(&ctx, skb, nlh, afi, table, chain, nla);
 
-	if (nla[NFTA_RULE_FLAGS]) {
-		flags = ntohl(nla_get_be32(nla[NFTA_RULE_FLAGS]));
-
-		if (flags & ~NFT_RULE_F_MASK)
-			return -EINVAL;
-	}
-
 	if (nla[NFTA_RULE_HANDLE]) {
 		rule = nf_tables_rule_lookup(chain, nla[NFTA_RULE_HANDLE]);
 		if (IS_ERR(rule))
 			return PTR_ERR(rule);
 
-		err = nf_tables_delrule_one(&ctx, rule, flags);
+		err = nf_tables_delrule_one(&ctx, rule);
 	} else {
 		/* Remove all rules in this chain */
 		list_for_each_entry_safe(rule, tmp, &chain->rules, list) {
-			err = nf_tables_delrule_one(&ctx, rule, flags);
+			err = nf_tables_delrule_one(&ctx, rule);
 			if (err < 0)
 				break;
 		}
-- 
1.7.10.4

