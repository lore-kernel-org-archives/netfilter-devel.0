From: Phil Sutter <phil@nwl.cc>
Subject: [nf-next PATCH 5/5] netfilter: nf_tables: Unlimit object name length
Date: Thu, 20 Jul 2017 17:24:50 +0200
Message-ID: <20170720152450.27693-6-phil@nwl.cc>
References: <20170720152450.27693-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:35459 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965021AbdGTPZW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jul 2017 11:25:22 -0400
In-Reply-To: <20170720152450.27693-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/net/netfilter/nf_tables.h        |  2 +-
 include/uapi/linux/netfilter/nf_tables.h |  1 -
 net/netfilter/nf_tables_api.c            | 14 ++++++++++----
 net/netfilter/nft_objref.c               |  3 +--
 4 files changed, 12 insertions(+), 8 deletions(-)

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
index 343fea07dd4bd..1bd17f45ea0d3 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1,7 +1,6 @@
 #ifndef _LINUX_NF_TABLES_H
 #define _LINUX_NF_TABLES_H
 
-#define NFT_OBJ_MAXNAMELEN	32
 #define NFT_USERDATA_MAXLEN	256
 
 /**
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6ec3a58518feb..fb4dc66d00db3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4254,8 +4254,7 @@ EXPORT_SYMBOL_GPL(nf_tables_obj_lookup);
 
 static const struct nla_policy nft_obj_policy[NFTA_OBJ_MAX + 1] = {
 	[NFTA_OBJ_TABLE]	= { .type = NLA_STRING },
-	[NFTA_OBJ_NAME]		= { .type = NLA_STRING,
-				    .len = NFT_OBJ_MAXNAMELEN - 1 },
+	[NFTA_OBJ_NAME]		= { .type = NLA_STRING },
 	[NFTA_OBJ_TYPE]		= { .type = NLA_U32 },
 	[NFTA_OBJ_DATA]		= { .type = NLA_NESTED },
 };
@@ -4397,15 +4396,21 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
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
@@ -4621,6 +4626,7 @@ static void nft_obj_destroy(struct nft_object *obj)
 		obj->type->destroy(obj);
 
 	module_put(obj->type->owner);
+	kfree(obj->name);
 	kfree(obj);
 }
 
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index a242f2700c2e8..f88779c266e0d 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -187,8 +187,7 @@ nft_objref_select_ops(const struct nft_ctx *ctx,
 }
 
 static const struct nla_policy nft_objref_policy[NFTA_OBJREF_MAX + 1] = {
-	[NFTA_OBJREF_IMM_NAME]	= { .type = NLA_STRING,
-				    .len = NFT_OBJ_MAXNAMELEN - 1 },
+	[NFTA_OBJREF_IMM_NAME]	= { .type = NLA_STRING },
 	[NFTA_OBJREF_IMM_TYPE]	= { .type = NLA_U32 },
 	[NFTA_OBJREF_SET_SREG]	= { .type = NLA_U32 },
 	[NFTA_OBJREF_SET_NAME]	= { .type = NLA_STRING },
-- 
2.13.1

