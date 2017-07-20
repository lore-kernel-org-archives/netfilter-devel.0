From: Phil Sutter <phil@nwl.cc>
Subject: [nf-next PATCH 4/5] netfilter: nf_tables: Unlimit set name length
Date: Thu, 20 Jul 2017 17:24:49 +0200
Message-ID: <20170720152450.27693-5-phil@nwl.cc>
References: <20170720152450.27693-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:35911 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965361AbdGTPZQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jul 2017 11:25:16 -0400
In-Reply-To: <20170720152450.27693-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/net/netfilter/nf_tables.h        |  2 +-
 include/uapi/linux/netfilter/nf_tables.h |  1 -
 net/netfilter/nf_tables_api.c            | 24 ++++++++++++++++--------
 net/netfilter/nft_dynset.c               |  3 +--
 net/netfilter/nft_lookup.c               |  3 +--
 net/netfilter/nft_objref.c               |  3 +--
 6 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index be1610162ee02..66ba62fa7d90e 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -396,7 +396,7 @@ void nft_unregister_set(struct nft_set_type *type);
 struct nft_set {
 	struct list_head		list;
 	struct list_head		bindings;
-	char				name[NFT_SET_MAXNAMELEN];
+	char				*name;
 	u32				ktype;
 	u32				dtype;
 	u32				objtype;
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 08349c9faecda..343fea07dd4bd 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1,7 +1,6 @@
 #ifndef _LINUX_NF_TABLES_H
 #define _LINUX_NF_TABLES_H
 
-#define NFT_SET_MAXNAMELEN	32
 #define NFT_OBJ_MAXNAMELEN	32
 #define NFT_USERDATA_MAXLEN	256
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a83438ce89391..6ec3a58518feb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2537,8 +2537,7 @@ nft_select_set_ops(const struct nft_ctx *ctx,
 
 static const struct nla_policy nft_set_policy[NFTA_SET_MAX + 1] = {
 	[NFTA_SET_TABLE]		= { .type = NLA_STRING },
-	[NFTA_SET_NAME]			= { .type = NLA_STRING,
-					    .len = NFT_SET_MAXNAMELEN - 1 },
+	[NFTA_SET_NAME]			= { .type = NLA_STRING },
 	[NFTA_SET_FLAGS]		= { .type = NLA_U32 },
 	[NFTA_SET_KEY_TYPE]		= { .type = NLA_U32 },
 	[NFTA_SET_KEY_LEN]		= { .type = NLA_U32 },
@@ -2649,7 +2648,7 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 	unsigned long *inuse;
 	unsigned int n = 0, min = 0;
 
-	p = strnchr(name, NFT_SET_MAXNAMELEN, '%');
+	p = strchr(name, '%');
 	if (p != NULL) {
 		if (p[1] != 'd' || strchr(p + 2, '%'))
 			return -EINVAL;
@@ -2680,7 +2679,10 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 		free_page((unsigned long)inuse);
 	}
 
-	snprintf(set->name, sizeof(set->name), name, min + n);
+	set->name = kasprintf(GFP_KERNEL, name, min + n);
+	if (!set->name)
+		return -ENOMEM;
+
 	list_for_each_entry(i, &ctx->table->sets, list) {
 		if (!nft_is_active_next(ctx->net, i))
 			continue;
@@ -2957,7 +2959,7 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	struct nft_table *table;
 	struct nft_set *set;
 	struct nft_ctx ctx;
-	char name[NFT_SET_MAXNAMELEN];
+	char *name;
 	unsigned int size;
 	bool create;
 	u64 timeout;
@@ -3103,8 +3105,14 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 		goto err1;
 	}
 
-	nla_strlcpy(name, nla[NFTA_SET_NAME], sizeof(set->name));
+	name = nla_strdup(nla[NFTA_SET_NAME], GFP_KERNEL);
+	if (!name) {
+		err = -ENOMEM;
+		goto err2;
+	}
+
 	err = nf_tables_set_alloc_name(&ctx, set, name);
+	kfree(name);
 	if (err < 0)
 		goto err2;
 
@@ -3154,6 +3162,7 @@ static void nft_set_destroy(struct nft_set *set)
 {
 	set->ops->destroy(set);
 	module_put(set->ops->type->owner);
+	kfree(set->name);
 	kvfree(set);
 }
 
@@ -3303,8 +3312,7 @@ static const struct nla_policy nft_set_elem_policy[NFTA_SET_ELEM_MAX + 1] = {
 
 static const struct nla_policy nft_set_elem_list_policy[NFTA_SET_ELEM_LIST_MAX + 1] = {
 	[NFTA_SET_ELEM_LIST_TABLE]	= { .type = NLA_STRING },
-	[NFTA_SET_ELEM_LIST_SET]	= { .type = NLA_STRING,
-					    .len = NFT_SET_MAXNAMELEN - 1 },
+	[NFTA_SET_ELEM_LIST_SET]	= { .type = NLA_STRING },
 	[NFTA_SET_ELEM_LIST_ELEMENTS]	= { .type = NLA_NESTED },
 	[NFTA_SET_ELEM_LIST_SET_ID]	= { .type = NLA_U32 },
 };
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 66221ad891a9f..fa280e315077c 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -97,8 +97,7 @@ static void nft_dynset_eval(const struct nft_expr *expr,
 }
 
 static const struct nla_policy nft_dynset_policy[NFTA_DYNSET_MAX + 1] = {
-	[NFTA_DYNSET_SET_NAME]	= { .type = NLA_STRING,
-				    .len = NFT_SET_MAXNAMELEN - 1 },
+	[NFTA_DYNSET_SET_NAME]	= { .type = NLA_STRING },
 	[NFTA_DYNSET_SET_ID]	= { .type = NLA_U32 },
 	[NFTA_DYNSET_OP]	= { .type = NLA_U32 },
 	[NFTA_DYNSET_SREG_KEY]	= { .type = NLA_U32 },
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 475570e89ede7..cc073d8736681 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -49,8 +49,7 @@ static void nft_lookup_eval(const struct nft_expr *expr,
 }
 
 static const struct nla_policy nft_lookup_policy[NFTA_LOOKUP_MAX + 1] = {
-	[NFTA_LOOKUP_SET]	= { .type = NLA_STRING,
-				    .len = NFT_SET_MAXNAMELEN - 1 },
+	[NFTA_LOOKUP_SET]	= { .type = NLA_STRING },
 	[NFTA_LOOKUP_SET_ID]	= { .type = NLA_U32 },
 	[NFTA_LOOKUP_SREG]	= { .type = NLA_U32 },
 	[NFTA_LOOKUP_DREG]	= { .type = NLA_U32 },
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index 1dd428fbaaa3f..a242f2700c2e8 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -191,8 +191,7 @@ static const struct nla_policy nft_objref_policy[NFTA_OBJREF_MAX + 1] = {
 				    .len = NFT_OBJ_MAXNAMELEN - 1 },
 	[NFTA_OBJREF_IMM_TYPE]	= { .type = NLA_U32 },
 	[NFTA_OBJREF_SET_SREG]	= { .type = NLA_U32 },
-	[NFTA_OBJREF_SET_NAME]	= { .type = NLA_STRING,
-				    .len = NFT_SET_MAXNAMELEN - 1 },
+	[NFTA_OBJREF_SET_NAME]	= { .type = NLA_STRING },
 	[NFTA_OBJREF_SET_ID]	= { .type = NLA_U32 },
 };
 
-- 
2.13.1

