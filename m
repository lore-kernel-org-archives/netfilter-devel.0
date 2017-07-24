From: Phil Sutter <phil@nwl.cc>
Subject: [nf-next PATCH 6/5] netfilter: nf_tables: Reintroduce name length boundary
Date: Mon, 24 Jul 2017 17:10:05 +0200
Message-ID: <20170724151005.9454-1-phil@nwl.cc>
References: <20170720152450.27693-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:47283 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932377AbdGXPKS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jul 2017 11:10:18 -0400
In-Reply-To: <20170720152450.27693-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since all names in nftables are now dynamically allocated, choosing a
large hard-coded length limit does not bloat nftables' footprint
anymore.

Introduce a common upper limit on all names for sanity reasons - the
chosen value of 255 characters allows to use a DNS name as per RFC 1035.

Sugested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/uapi/linux/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c            | 36 +++++++++++++++++++++-----------
 net/netfilter/nft_dynset.c               |  3 ++-
 net/netfilter/nft_lookup.c               |  3 ++-
 net/netfilter/nft_objref.c               |  6 ++++--
 5 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 1bd17f45ea0d3..58263e23f3c5a 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_NF_TABLES_H
 #define _LINUX_NF_TABLES_H
 
+#define NFT_NAME_MAXLEN		256
 #define NFT_USERDATA_MAXLEN	256
 
 /**
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fb4dc66d00db3..0527d677716d1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -427,7 +427,8 @@ nf_tables_chain_type_lookup(const struct nft_af_info *afi,
 }
 
 static const struct nla_policy nft_table_policy[NFTA_TABLE_MAX + 1] = {
-	[NFTA_TABLE_NAME]	= { .type = NLA_STRING },
+	[NFTA_TABLE_NAME]	= { .type = NLA_STRING,
+				    .len = NFT_NAME_MAXLEN - 1 },
 	[NFTA_TABLE_FLAGS]	= { .type = NLA_U32 },
 };
 
@@ -939,9 +940,11 @@ static struct nft_chain *nf_tables_chain_lookup(const struct nft_table *table,
 }
 
 static const struct nla_policy nft_chain_policy[NFTA_CHAIN_MAX + 1] = {
-	[NFTA_CHAIN_TABLE]	= { .type = NLA_STRING },
+	[NFTA_CHAIN_TABLE]	= { .type = NLA_STRING,
+				    .len = NFT_NAME_MAXLEN - 1 },
 	[NFTA_CHAIN_HANDLE]	= { .type = NLA_U64 },
-	[NFTA_CHAIN_NAME]	= { .type = NLA_STRING },
+	[NFTA_CHAIN_NAME]	= { .type = NLA_STRING,
+				    .len = NFT_NAME_MAXLEN - 1 },
 	[NFTA_CHAIN_HOOK]	= { .type = NLA_NESTED },
 	[NFTA_CHAIN_POLICY]	= { .type = NLA_U32 },
 	[NFTA_CHAIN_TYPE]	= { .type = NLA_STRING },
@@ -1886,8 +1889,10 @@ static struct nft_rule *nf_tables_rule_lookup(const struct nft_chain *chain,
 }
 
 static const struct nla_policy nft_rule_policy[NFTA_RULE_MAX + 1] = {
-	[NFTA_RULE_TABLE]	= { .type = NLA_STRING },
-	[NFTA_RULE_CHAIN]	= { .type = NLA_STRING },
+	[NFTA_RULE_TABLE]	= { .type = NLA_STRING,
+				    .len = NFT_NAME_MAXLEN - 1 },
+	[NFTA_RULE_CHAIN]	= { .type = NLA_STRING,
+				    .len = NFT_NAME_MAXLEN - 1 },
 	[NFTA_RULE_HANDLE]	= { .type = NLA_U64 },
 	[NFTA_RULE_EXPRESSIONS]	= { .type = NLA_NESTED },
 	[NFTA_RULE_COMPAT]	= { .type = NLA_NESTED },
@@ -2536,8 +2541,10 @@ nft_select_set_ops(const struct nft_ctx *ctx,
 }
 
 static const struct nla_policy nft_set_policy[NFTA_SET_MAX + 1] = {
-	[NFTA_SET_TABLE]		= { .type = NLA_STRING },
-	[NFTA_SET_NAME]			= { .type = NLA_STRING },
+	[NFTA_SET_TABLE]		= { .type = NLA_STRING,
+					    .len = NFT_NAME_MAXLEN - 1 },
+	[NFTA_SET_NAME]			= { .type = NLA_STRING,
+					    .len = NFT_NAME_MAXLEN - 1 },
 	[NFTA_SET_FLAGS]		= { .type = NLA_U32 },
 	[NFTA_SET_KEY_TYPE]		= { .type = NLA_U32 },
 	[NFTA_SET_KEY_LEN]		= { .type = NLA_U32 },
@@ -3311,8 +3318,10 @@ static const struct nla_policy nft_set_elem_policy[NFTA_SET_ELEM_MAX + 1] = {
 };
 
 static const struct nla_policy nft_set_elem_list_policy[NFTA_SET_ELEM_LIST_MAX + 1] = {
-	[NFTA_SET_ELEM_LIST_TABLE]	= { .type = NLA_STRING },
-	[NFTA_SET_ELEM_LIST_SET]	= { .type = NLA_STRING },
+	[NFTA_SET_ELEM_LIST_TABLE]	= { .type = NLA_STRING,
+					    .len = NFT_NAME_MAXLEN - 1 },
+	[NFTA_SET_ELEM_LIST_SET]	= { .type = NLA_STRING,
+					    .len = NFT_NAME_MAXLEN - 1 },
 	[NFTA_SET_ELEM_LIST_ELEMENTS]	= { .type = NLA_NESTED },
 	[NFTA_SET_ELEM_LIST_SET_ID]	= { .type = NLA_U32 },
 };
@@ -4253,8 +4262,10 @@ struct nft_object *nf_tables_obj_lookup(const struct nft_table *table,
 EXPORT_SYMBOL_GPL(nf_tables_obj_lookup);
 
 static const struct nla_policy nft_obj_policy[NFTA_OBJ_MAX + 1] = {
-	[NFTA_OBJ_TABLE]	= { .type = NLA_STRING },
-	[NFTA_OBJ_NAME]		= { .type = NLA_STRING },
+	[NFTA_OBJ_TABLE]	= { .type = NLA_STRING,
+				    .len = NFT_NAME_MAXLEN - 1 },
+	[NFTA_OBJ_NAME]		= { .type = NLA_STRING,
+				    .len = NFT_NAME_MAXLEN - 1 },
 	[NFTA_OBJ_TYPE]		= { .type = NLA_U32 },
 	[NFTA_OBJ_DATA]		= { .type = NLA_NESTED },
 };
@@ -5487,7 +5498,8 @@ EXPORT_SYMBOL_GPL(nft_validate_register_store);
 
 static const struct nla_policy nft_verdict_policy[NFTA_VERDICT_MAX + 1] = {
 	[NFTA_VERDICT_CODE]	= { .type = NLA_U32 },
-	[NFTA_VERDICT_CHAIN]	= { .type = NLA_STRING },
+	[NFTA_VERDICT_CHAIN]	= { .type = NLA_STRING,
+				    .len = NFT_NAME_MAXLEN - 1 },
 };
 
 static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index fa280e315077c..3528a03035825 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -97,7 +97,8 @@ static void nft_dynset_eval(const struct nft_expr *expr,
 }
 
 static const struct nla_policy nft_dynset_policy[NFTA_DYNSET_MAX + 1] = {
-	[NFTA_DYNSET_SET_NAME]	= { .type = NLA_STRING },
+	[NFTA_DYNSET_SET_NAME]	= { .type = NLA_STRING,
+				    .len = NFT_NAME_MAXLEN - 1 },
 	[NFTA_DYNSET_SET_ID]	= { .type = NLA_U32 },
 	[NFTA_DYNSET_OP]	= { .type = NLA_U32 },
 	[NFTA_DYNSET_SREG_KEY]	= { .type = NLA_U32 },
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index cc073d8736681..000a6b729cb18 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -49,7 +49,8 @@ static void nft_lookup_eval(const struct nft_expr *expr,
 }
 
 static const struct nla_policy nft_lookup_policy[NFTA_LOOKUP_MAX + 1] = {
-	[NFTA_LOOKUP_SET]	= { .type = NLA_STRING },
+	[NFTA_LOOKUP_SET]	= { .type = NLA_STRING,
+				    .len = NFT_NAME_MAXLEN - 1 },
 	[NFTA_LOOKUP_SET_ID]	= { .type = NLA_U32 },
 	[NFTA_LOOKUP_SREG]	= { .type = NLA_U32 },
 	[NFTA_LOOKUP_DREG]	= { .type = NLA_U32 },
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index f88779c266e0d..8a331c70918f2 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -187,10 +187,12 @@ nft_objref_select_ops(const struct nft_ctx *ctx,
 }
 
 static const struct nla_policy nft_objref_policy[NFTA_OBJREF_MAX + 1] = {
-	[NFTA_OBJREF_IMM_NAME]	= { .type = NLA_STRING },
+	[NFTA_OBJREF_IMM_NAME]	= { .type = NLA_STRING,
+				    .len = NFT_NAME_MAXLEN - 1 },
 	[NFTA_OBJREF_IMM_TYPE]	= { .type = NLA_U32 },
 	[NFTA_OBJREF_SET_SREG]	= { .type = NLA_U32 },
-	[NFTA_OBJREF_SET_NAME]	= { .type = NLA_STRING },
+	[NFTA_OBJREF_SET_NAME]	= { .type = NLA_STRING,
+				    .len = NFT_NAME_MAXLEN - 1 },
 	[NFTA_OBJREF_SET_ID]	= { .type = NLA_U32 },
 };
 
-- 
2.13.1

