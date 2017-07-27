From: Phil Sutter <phil@nwl.cc>
Subject: [nf-next PATCH v3 6/6] netfilter: nf_tables: Allow object names of up to 255 chars
Date: Thu, 27 Jul 2017 16:56:44 +0200
Message-ID: <20170727145644.16888-7-phil@nwl.cc>
References: <20170727145644.16888-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:43791 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751539AbdG0O5D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jul 2017 10:57:03 -0400
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
- Don't drop NFT_OBJ_MAXNAMELEN macro since it's UAPI.
- Keep using NFT_OBJ_MAXNAMELEN in netlink policies to reduce patch
  size.
---
 include/net/netfilter/nf_tables.h        |  2 +-
 include/uapi/linux/netfilter/nf_tables.h |  2 +-
 net/netfilter/nf_tables_api.c            | 11 +++++++++--
 3 files changed, 11 insertions(+), 4 deletions(-)

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
index 375528546a968..d72fda5f01b86 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -5,7 +5,7 @@
 #define NFT_TABLE_MAXNAMELEN	NFT_NAME_MAXLEN
 #define NFT_CHAIN_MAXNAMELEN	NFT_NAME_MAXLEN
 #define NFT_SET_MAXNAMELEN	NFT_NAME_MAXLEN
-#define NFT_OBJ_MAXNAMELEN	32
+#define NFT_OBJ_MAXNAMELEN	NFT_NAME_MAXLEN
 #define NFT_USERDATA_MAXLEN	256
 
 /**
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 72672b557d5c8..beb17b462da34 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
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
 
-- 
2.13.1

