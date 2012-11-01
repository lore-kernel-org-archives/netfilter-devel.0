From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nf-next/nf_tables-experiments - v2 PATCH 1/4] nf_tables: Change chain's name to be fixed sized
Date: Thu,  1 Nov 2012 13:38:30 +0200
Message-ID: <1351769913-5851-2-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1351769913-5851-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:53694 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187Ab2KALii (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Nov 2012 07:38:38 -0400
In-Reply-To: <1351769913-5851-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/linux/netfilter/nf_tables.h |  2 ++
 include/net/netfilter/nf_tables.h   |  2 +-
 net/netfilter/nf_tables_api.c       | 17 +++++++++--------
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 0115a2f..8962657 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_NF_TABLES_H
 #define _LINUX_NF_TABLES_H
 
+#define NFT_CHAIN_MAXNAMELEN 32
+
 enum nft_registers {
 	NFT_REG_VERDICT,
 	NFT_REG_1,
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 8ce0db4..74b8b770 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -357,7 +357,7 @@ struct nft_chain {
 	u16				use;
 	u16				level;
 	u16				hgenerator;
-	char				name[];
+	char				name[NFT_CHAIN_MAXNAMELEN];
 };
 
 /**
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e0e4616..a04139c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -478,7 +478,8 @@ static struct nft_chain *nf_tables_chain_lookup(const struct nft_table *table,
 }
 
 static const struct nla_policy nft_chain_policy[NFTA_CHAIN_MAX + 1] = {
-	[NFTA_CHAIN_NAME]	= { .type = NLA_STRING },
+	[NFTA_CHAIN_NAME]	= { .type = NLA_STRING,
+				    .len = NFT_CHAIN_MAXNAMELEN - 1 },
 	[NFTA_CHAIN_TABLE]	= { .type = NLA_STRING },
 	[NFTA_CHAIN_HOOK]	= { .type = NLA_NESTED },
 	[NFTA_CHAIN_POLICY]	= { .type = NLA_U32 },
@@ -687,7 +688,6 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 	struct nft_chain *chain;
 	struct nft_base_chain *basechain = NULL;
 	struct nlattr *ha[NFTA_HOOK_MAX + 1];
-	unsigned int size;
 	int family = nfmsg->nfgen_family;
 	int err;
 	bool create;
@@ -723,7 +723,6 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 		return 0;
 	}
 
-	size = nla_len(name);
 	if (nla[NFTA_CHAIN_HOOK]) {
 		struct nf_hook_ops *ops;
 
@@ -737,7 +736,7 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 		if (ntohl(nla_get_be32(ha[NFTA_HOOK_HOOKNUM])) >= afi->nhooks)
 			return -EINVAL;
 
-		basechain = kzalloc(sizeof(*basechain) + size, GFP_KERNEL);
+		basechain = kzalloc(sizeof(*basechain), GFP_KERNEL);
 		if (basechain == NULL)
 			return -ENOMEM;
 		chain = &basechain->chain;
@@ -764,7 +763,7 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 			}
 		}
 	} else {
-		chain = kzalloc(sizeof(*chain) + size, GFP_KERNEL);
+		chain = kzalloc(sizeof(*chain), GFP_KERNEL);
 		if (chain == NULL)
 			return -ENOMEM;
 
@@ -772,7 +771,7 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 	}
 
 	INIT_LIST_HEAD(&chain->rules);
-	nla_strlcpy(chain->name, name, size);
+	nla_strlcpy(chain->name, name, NFT_CHAIN_MAXNAMELEN);
 
 	list_add_tail(&chain->list, &table->chains);
 
@@ -1054,7 +1053,8 @@ static u16 nf_tables_rule_alloc_handle(struct nft_chain *chain)
 
 static const struct nla_policy nft_rule_policy[NFTA_RULE_MAX + 1] = {
 	[NFTA_RULE_TABLE]	= { .type = NLA_STRING },
-	[NFTA_RULE_CHAIN]	= { .type = NLA_STRING },
+	[NFTA_RULE_CHAIN]	= { .type = NLA_STRING,
+				    .len = NFT_CHAIN_MAXNAMELEN - 1 },
 	[NFTA_RULE_HANDLE]	= { .type = NLA_U16 },
 	[NFTA_RULE_EXPRESSIONS]	= { .type = NLA_NESTED },
 };
@@ -2454,7 +2454,8 @@ EXPORT_SYMBOL_GPL(nft_validate_data_load);
 
 static const struct nla_policy nft_verdict_policy[NFTA_VERDICT_MAX + 1] = {
 	[NFTA_VERDICT_CODE]	= { .type = NLA_U32 },
-	[NFTA_VERDICT_CHAIN]	= { .type = NLA_STRING },
+	[NFTA_VERDICT_CHAIN]	= { .type = NLA_STRING,
+				    .len = NFT_CHAIN_MAXNAMELEN - 1 },
 };
 
 static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
-- 
1.7.12.4

