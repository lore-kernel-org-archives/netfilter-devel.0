From: Phil Sutter <phil@nwl.cc>
Subject: [nf-next PATCH v2 4/5] netfilter: nf_tables: Unlimit set name length
Date: Mon, 24 Jul 2017 20:56:50 +0200
Message-ID: <20170724185651.24063-5-phil@nwl.cc>
References: <20170724185651.24063-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:33223 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753577AbdGXS5E (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jul 2017 14:57:04 -0400
In-Reply-To: <20170724185651.24063-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Same conversion as for table names, use NFT_NAME_MAXLEN as upper
boundary as well.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/net/netfilter/nf_tables.h        |  2 +-
 include/uapi/linux/netfilter/nf_tables.h |  1 -
 net/netfilter/nf_tables_api.c            | 22 ++++++++++++++++------
 net/netfilter/nft_dynset.c               |  2 +-
 net/netfilter/nft_lookup.c               |  2 +-
 net/netfilter/nft_objref.c               |  2 +-
 6 files changed, 20 insertions(+), 11 deletions(-)

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
index 29e57df26530f..73543b4f507eb 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -2,7 +2,6 @@
 #define _LINUX_NF_TABLES_H
 
 #define NFT_NAME_MAXLEN		256
-#define NFT_SET_MAXNAMELEN	32
 #define NFT_OBJ_MAXNAMELEN	32
 #define NFT_USERDATA_MAXLEN	256
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 002898e557a92..f48f8a46de89b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2544,7 +2544,7 @@ static const struct nla_policy nft_set_policy[NFTA_SET_MAX + 1] = {
 	[NFTA_SET_TABLE]		= { .type = NLA_STRING,
 					    .len = NFT_NAME_MAXLEN - 1 },
 	[NFTA_SET_NAME]			= { .type = NLA_STRING,
-					    .len = NFT_SET_MAXNAMELEN - 1 },
+					    .len = NFT_NAME_MAXLEN - 1 },
 	[NFTA_SET_FLAGS]		= { .type = NLA_U32 },
 	[NFTA_SET_KEY_TYPE]		= { .type = NLA_U32 },
 	[NFTA_SET_KEY_LEN]		= { .type = NLA_U32 },
@@ -2655,7 +2655,7 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 	unsigned long *inuse;
 	unsigned int n = 0, min = 0;
 
-	p = strnchr(name, NFT_SET_MAXNAMELEN, '%');
+	p = strchr(name, '%');
 	if (p != NULL) {
 		if (p[1] != 'd' || strchr(p + 2, '%'))
 			return -EINVAL;
@@ -2686,7 +2686,10 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
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
@@ -2963,7 +2966,7 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	struct nft_table *table;
 	struct nft_set *set;
 	struct nft_ctx ctx;
-	char name[NFT_SET_MAXNAMELEN];
+	char *name;
 	unsigned int size;
 	bool create;
 	u64 timeout;
@@ -3109,8 +3112,14 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
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
 
@@ -3160,6 +3169,7 @@ static void nft_set_destroy(struct nft_set *set)
 {
 	set->ops->destroy(set);
 	module_put(set->ops->type->owner);
+	kfree(set->name);
 	kvfree(set);
 }
 
@@ -3311,7 +3321,7 @@ static const struct nla_policy nft_set_elem_list_policy[NFTA_SET_ELEM_LIST_MAX +
 	[NFTA_SET_ELEM_LIST_TABLE]	= { .type = NLA_STRING,
 					    .len = NFT_NAME_MAXLEN - 1 },
 	[NFTA_SET_ELEM_LIST_SET]	= { .type = NLA_STRING,
-					    .len = NFT_SET_MAXNAMELEN - 1 },
+					    .len = NFT_NAME_MAXLEN - 1 },
 	[NFTA_SET_ELEM_LIST_ELEMENTS]	= { .type = NLA_NESTED },
 	[NFTA_SET_ELEM_LIST_SET_ID]	= { .type = NLA_U32 },
 };
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 66221ad891a9f..3528a03035825 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -98,7 +98,7 @@ static void nft_dynset_eval(const struct nft_expr *expr,
 
 static const struct nla_policy nft_dynset_policy[NFTA_DYNSET_MAX + 1] = {
 	[NFTA_DYNSET_SET_NAME]	= { .type = NLA_STRING,
-				    .len = NFT_SET_MAXNAMELEN - 1 },
+				    .len = NFT_NAME_MAXLEN - 1 },
 	[NFTA_DYNSET_SET_ID]	= { .type = NLA_U32 },
 	[NFTA_DYNSET_OP]	= { .type = NLA_U32 },
 	[NFTA_DYNSET_SREG_KEY]	= { .type = NLA_U32 },
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 475570e89ede7..000a6b729cb18 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -50,7 +50,7 @@ static void nft_lookup_eval(const struct nft_expr *expr,
 
 static const struct nla_policy nft_lookup_policy[NFTA_LOOKUP_MAX + 1] = {
 	[NFTA_LOOKUP_SET]	= { .type = NLA_STRING,
-				    .len = NFT_SET_MAXNAMELEN - 1 },
+				    .len = NFT_NAME_MAXLEN - 1 },
 	[NFTA_LOOKUP_SET_ID]	= { .type = NLA_U32 },
 	[NFTA_LOOKUP_SREG]	= { .type = NLA_U32 },
 	[NFTA_LOOKUP_DREG]	= { .type = NLA_U32 },
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index 1dd428fbaaa3f..20d2289e8587b 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -192,7 +192,7 @@ static const struct nla_policy nft_objref_policy[NFTA_OBJREF_MAX + 1] = {
 	[NFTA_OBJREF_IMM_TYPE]	= { .type = NLA_U32 },
 	[NFTA_OBJREF_SET_SREG]	= { .type = NLA_U32 },
 	[NFTA_OBJREF_SET_NAME]	= { .type = NLA_STRING,
-				    .len = NFT_SET_MAXNAMELEN - 1 },
+				    .len = NFT_NAME_MAXLEN - 1 },
 	[NFTA_OBJREF_SET_ID]	= { .type = NLA_U32 },
 };
 
-- 
2.13.1

