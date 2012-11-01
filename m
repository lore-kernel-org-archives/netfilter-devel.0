From: pablo@netfilter.org
Subject: [PATCH 1/2] netfilter: nf_tables: use 64-bits rule handle instead of 16-bits
Date: Thu,  1 Nov 2012 17:02:23 +0100
Message-ID: <1351785744-7492-2-git-send-email-pablo@netfilter.org>
References: <1351785744-7492-1-git-send-email-pablo@netfilter.org>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37648 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964813Ab2KAQCi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Nov 2012 12:02:38 -0400
In-Reply-To: <1351785744-7492-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This allows fast handle allocation. This speeds up rule addition
from O(n) to O(1).

I assume 64-bits handle should be enough to avoid an overrun
(such thing may lead to two rules having the same handle quite
easily with 16-bits).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |    4 ++--
 net/netfilter/nf_tables_api.c     |   23 ++++++++---------------
 2 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 74b8b770..3289e0d 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -302,7 +302,7 @@ static inline void *nft_expr_priv(const struct nft_expr *expr)
  */
 struct nft_rule {
 	struct list_head		list;
-	u16				handle;
+	u64				handle;
 	u16				dlen;
 	unsigned char			data[]
 		__attribute__((aligned(__alignof__(struct nft_expr))));
@@ -356,7 +356,7 @@ struct nft_chain {
 	u8				policy;
 	u16				use;
 	u16				level;
-	u16				hgenerator;
+	u64				hgenerator;
 	char				name[NFT_CHAIN_MAXNAMELEN];
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e510f18..cfe6b85 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1061,7 +1061,7 @@ static void nf_tables_expr_destroy(const struct nft_ctx *ctx,
  */
 
 static struct nft_rule *__nf_tables_rule_lookup(const struct nft_chain *chain,
-						u16 handle)
+						u64 handle)
 {
 	struct nft_rule *rule;
 
@@ -1080,26 +1080,19 @@ static struct nft_rule *nf_tables_rule_lookup(const struct nft_chain *chain,
 	if (nla == NULL)
 		return ERR_PTR(-EINVAL);
 
-	return __nf_tables_rule_lookup(chain, ntohs(nla_get_be16(nla)));
+	return __nf_tables_rule_lookup(chain, be64_to_cpu(nla_get_be64(nla)));
 }
 
-static u16 nf_tables_rule_alloc_handle(struct nft_chain *chain)
+static inline u64 nf_tables_rule_alloc_handle(struct nft_chain *chain)
 {
-	int i = 0xFFFF;
-	u16 handle;
-
-	do {
-		handle = ++chain->hgenerator;
-	} while (--i > 0 && !IS_ERR(__nf_tables_rule_lookup(chain, handle)));
-
-	return i > 0 ? handle : 0;
+	return ++chain->hgenerator;
 }
 
 static const struct nla_policy nft_rule_policy[NFTA_RULE_MAX + 1] = {
 	[NFTA_RULE_TABLE]	= { .type = NLA_STRING },
 	[NFTA_RULE_CHAIN]	= { .type = NLA_STRING,
 				    .len = NFT_CHAIN_MAXNAMELEN - 1 },
-	[NFTA_RULE_HANDLE]	= { .type = NLA_U16 },
+	[NFTA_RULE_HANDLE]	= { .type = NLA_U64 },
 	[NFTA_RULE_EXPRESSIONS]	= { .type = NLA_NESTED },
 };
 
@@ -1129,7 +1122,7 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, u32 pid, u32 seq,
 		goto nla_put_failure;
 	if (nla_put_string(skb, NFTA_RULE_CHAIN, chain->name))
 		goto nla_put_failure;
-	if (nla_put_be16(skb, NFTA_RULE_HANDLE, htons(rule->handle)))
+	if (nla_put_be64(skb, NFTA_RULE_HANDLE, cpu_to_be64(rule->handle)))
 		goto nla_put_failure;
 
 	list = nla_nest_start(skb, NFTA_RULE_EXPRESSIONS);
@@ -1317,7 +1310,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	unsigned int size, i, n;
 	int err, rem;
 	bool create;
-	u16 handle;
+	u64 handle;
 
 	create = nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
 
@@ -1334,7 +1327,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 		return PTR_ERR(chain);
 
 	if (nla[NFTA_RULE_HANDLE]) {
-		handle = ntohs(nla_get_be16(nla[NFTA_RULE_HANDLE]));
+		handle = be64_to_cpu(nla_get_be64(nla[NFTA_RULE_HANDLE]));
 		rule = __nf_tables_rule_lookup(chain, handle);
 		if (IS_ERR(rule)) {
 			if (PTR_ERR(rule) != -ENOENT)
-- 
1.7.10.4

