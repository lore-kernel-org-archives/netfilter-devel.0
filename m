From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -nftables v2 4/4] netfilter: nf_tables: all rule updates are transactional
Date: Tue, 17 Sep 2013 12:43:13 +0200
Message-ID: <1379414593-17956-5-git-send-email-pablo@netfilter.org>
References: <1379414593-17956-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52651 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450Ab3IQKnc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Sep 2013 06:43:32 -0400
In-Reply-To: <1379414593-17956-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch makes all rule updates transactional, this simplifies
the ruleset update logic. Suggested by Patrick McHardy.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |    5 ---
 net/netfilter/nf_tables_api.c            |   62 ++++++------------------------
 2 files changed, 12 insertions(+), 55 deletions(-)

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
index ec2a566..c02a698 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1570,7 +1570,6 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	unsigned int size, i, n;
 	int err, rem;
 	bool create;
-	u32 flags = 0;
 	u64 handle, pos_handle;
 
 	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
@@ -1639,14 +1638,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
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
@@ -1661,13 +1653,8 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	}
 
 	if (nlh->nlmsg_flags & NLM_F_REPLACE) {
-		if (flags & NFT_RULE_F_COMMIT) {
-			nft_rule_disactivate_next(net, old_rule);
-			list_add_tail_rcu(&rule->list, &chain->rules);
-		} else {
-			list_replace_rcu(&old_rule->list, &rule->list);
-			nf_tables_rule_destroy(old_rule);
-		}
+		nft_rule_disactivate_next(net, old_rule);
+		list_add_tail_rcu(&rule->list, &chain->rules);
 	} else if (nlh->nlmsg_flags & NLM_F_APPEND)
 		if (old_rule)
 			list_add_rcu(&rule->list, &old_rule->list);
@@ -1680,16 +1667,10 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 			list_add_rcu(&rule->list, &chain->rules);
 	}
 
-	if (flags & NFT_RULE_F_COMMIT)
-		err = nf_tables_trans_add(rule, &ctx);
-		if (err < 0)
-			goto err2;
-	else {
-		nf_tables_rule_notify(skb, nlh, table, chain, rule,
-				      NFT_MSG_NEWRULE,
-				      nlh->nlmsg_flags & (NLM_F_APPEND | NLM_F_REPLACE),
-				      nfmsg->nfgen_family);
-	}
+	err = nf_tables_trans_add(rule, &ctx);
+	if (err < 0)
+		goto err2;
+
 	return 0;
 
 err2:
@@ -1703,21 +1684,10 @@ err1:
 }
 
 static int
-nf_tables_delrule_one(struct nft_ctx *ctx, struct nft_rule *rule, u32 flags)
+nf_tables_delrule_one(struct nft_ctx *ctx, struct nft_rule *rule)
 {
-	int err = 0;
-
-	if (flags & NFT_RULE_F_COMMIT) {
-		nft_rule_disactivate_next(ctx->net, rule);
-		err = nf_tables_trans_add(rule, ctx);
-	} else {
-		list_del_rcu(&rule->list);
-		nf_tables_rule_notify(ctx->skb, ctx->nlh, ctx->table,
-				      ctx->chain, rule, NFT_MSG_DELRULE,
-				      0, ctx->afi->family);
-		nf_tables_rule_destroy(rule);
-	}
-	return err;
+	nft_rule_disactivate_next(ctx->net, rule);
+	return nf_tables_trans_add(rule, ctx);
 }
 
 static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
@@ -1732,7 +1702,6 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 	struct nft_rule *rule, *tmp;
 	int family = nfmsg->nfgen_family, err = 0;
 	struct nft_ctx ctx;
-	u32 flags = 0;
 
 	afi = nf_tables_afinfo_lookup(net, family, false);
 	if (IS_ERR(afi))
@@ -1748,23 +1717,16 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 
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

