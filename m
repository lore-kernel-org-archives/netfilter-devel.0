From: Phil Sutter <phil@nwl.cc>
Subject: [nf-next PATCH v2 5/5] netfilter: nf_tables: Unlimit object name length
Date: Mon, 24 Jul 2017 20:56:51 +0200
Message-ID: <20170724185651.24063-6-phil@nwl.cc>
References: <20170724185651.24063-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:58661 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755990AbdGXS5f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jul 2017 14:57:35 -0400
In-Reply-To: <20170724185651.24063-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Same conversion as for table names, use NFT_NAME_MAXLEN as upper
boundary as well.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/net/netfilter/nf_tables.h        |  2 +-
 include/uapi/linux/netfilter/nf_tables.h |  1 -
 net/netfilter/nf_tables_api.c            | 13 ++++++++++---
 net/netfilter/nft_objref.c               |  2 +-
 4 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 66ba62fa7d90e..f9795fe394f31 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1016,7 +1016,7 @@ int nft_verdict_dump(struct sk_buff *skb, int type,
  */
 struct nft_object {
 	struct list_head		list;
-	char				name[NFT_OBJ_MAXNAMELEN];
+	char				*name;
 	struct nft_table		*table;
 	u32				genmask:2,
 					use:30;
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 73543b4f507eb..58263e23f3c5a 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -2,7 +2,6 @@
 #define _LINUX_NF_TABLES_H
 
 #define NFT_NAME_MAXLEN		256
-#define NFT_OBJ_MAXNAMELEN	32
 #define NFT_USERDATA_MAXLEN	256
 
 /**
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f48f8a46de89b..0527d677716d1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4265,7 +4265,7 @@ static const struct nla_policy nft_obj_policy[NFTA_OBJ_MAX + 1] = {
 	[NFTA_OBJ_TABLE]	= { .type = NLA_STRING,
 				    .len = NFT_NAME_MAXLEN - 1 },
 	[NFTA_OBJ_NAME]		= { .type = NLA_STRING,
-				    .len = NFT_OBJ_MAXNAMELEN - 1 },
+				    .len = NFT_NAME_MAXLEN - 1 },
 	[NFTA_OBJ_TYPE]		= { .type = NLA_U32 },
 	[NFTA_OBJ_DATA]		= { .type = NLA_NESTED },
 };
@@ -4407,15 +4407,21 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 		goto err1;
 	}
 	obj->table = table;
-	nla_strlcpy(obj->name, nla[NFTA_OBJ_NAME], NFT_OBJ_MAXNAMELEN);
+	obj->name = nla_strdup(nla[NFTA_OBJ_NAME], GFP_KERNEL);
+	if (!obj->name) {
+		err = -ENOMEM;
+		goto err2;
+	}
 
 	err = nft_trans_obj_add(&ctx, NFT_MSG_NEWOBJ, obj);
 	if (err < 0)
-		goto err2;
+		goto err3;
 
 	list_add_tail_rcu(&obj->list, &table->objects);
 	table->use++;
 	return 0;
+err3:
+	kfree(obj->name);
 err2:
 	if (obj->type->destroy)
 		obj->type->destroy(obj);
@@ -4631,6 +4637,7 @@ static void nft_obj_destroy(struct nft_object *obj)
 		obj->type->destroy(obj);
 
 	module_put(obj->type->owner);
+	kfree(obj->name);
 	kfree(obj);
 }
 
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index 20d2289e8587b..8a331c70918f2 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -188,7 +188,7 @@ nft_objref_select_ops(const struct nft_ctx *ctx,
 
 static const struct nla_policy nft_objref_policy[NFTA_OBJREF_MAX + 1] = {
 	[NFTA_OBJREF_IMM_NAME]	= { .type = NLA_STRING,
-				    .len = NFT_OBJ_MAXNAMELEN - 1 },
+				    .len = NFT_NAME_MAXLEN - 1 },
 	[NFTA_OBJREF_IMM_TYPE]	= { .type = NLA_U32 },
 	[NFTA_OBJREF_SET_SREG]	= { .type = NLA_U32 },
 	[NFTA_OBJREF_SET_NAME]	= { .type = NLA_STRING,
-- 
2.13.1

