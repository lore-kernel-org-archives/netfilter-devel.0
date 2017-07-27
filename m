From: Phil Sutter <phil@nwl.cc>
Subject: [nf-next PATCH v3 5/6] netfilter: nf_tables: Allow set names of up to 255 chars
Date: Thu, 27 Jul 2017 16:56:43 +0200
Message-ID: <20170727145644.16888-6-phil@nwl.cc>
References: <20170727145644.16888-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:32903 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751636AbdG0O5V (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jul 2017 10:57:21 -0400
In-Reply-To: <20170727145644.16888-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Same conversion as for table names, use NFT_NAME_MAXLEN as upper
boundary as well.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Introduce NFT_NAME_MAXLEN as an upper boundary to restrict overly long
  names but still allow to use e.g. domain names.
- Adjust commit messages accordingly.

Changes since v2:
- Adjust commit summary - length is not really unlimited.
- Don't drop NFT_SET_MAXNAMELEN macro since it's UAPI.
- Keep using NFT_SET_MAXNAMELEN in netlink policies to reduce patch
  size.
---
 include/net/netfilter/nf_tables.h        |  2 +-
 include/uapi/linux/netfilter/nf_tables.h |  2 +-
 net/netfilter/nf_tables_api.c            | 18 ++++++++++++++----
 3 files changed, 16 insertions(+), 6 deletions(-)

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
index 6b586f43bd53a..375528546a968 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -4,7 +4,7 @@
 #define NFT_NAME_MAXLEN		256
 #define NFT_TABLE_MAXNAMELEN	NFT_NAME_MAXLEN
 #define NFT_CHAIN_MAXNAMELEN	NFT_NAME_MAXLEN
-#define NFT_SET_MAXNAMELEN	32
+#define NFT_SET_MAXNAMELEN	NFT_NAME_MAXLEN
 #define NFT_OBJ_MAXNAMELEN	32
 #define NFT_USERDATA_MAXLEN	256
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 55368ad7b9e7a..72672b557d5c8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
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
 
-- 
2.13.1

