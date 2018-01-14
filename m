From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] netfilter: nf_tables: allocate set handle and delete sets via set handle
Date: Sun, 14 Jan 2018 23:10:27 +0530
Message-ID: <20180114174027.23654-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, harshasharmaiitr@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:46433 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751797AbeANRky (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Jan 2018 12:40:54 -0500
Received: by mail-pf0-f195.google.com with SMTP id y5so7044339pff.13
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Jan 2018 09:40:54 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch add code to allocate unique set handles and delete sets via
those unique set handles.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 include/net/netfilter/nf_tables.h        |  2 ++
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c            | 26 +++++++++++++++++++++++++-
 3 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 488a8d8b41d2..144ffc750358 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -381,6 +381,7 @@ void nft_unregister_set(struct nft_set_type *type);
  *	@list: table set list node
  *	@bindings: list of set bindings
  * 	@name: name of the set
+ *	@handle: unique handle  of the set
  * 	@ktype: key type (numeric type defined by userspace, not used in the kernel)
  * 	@dtype: data type (verdict or numeric type defined by userspace)
  * 	@objtype: object type (see NFT_OBJECT_* definitions)
@@ -403,6 +404,7 @@ struct nft_set {
 	struct list_head		list;
 	struct list_head		bindings;
 	char				*name;
+	u64				handle;
 	u32				ktype;
 	u32				dtype;
 	u32				objtype;
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index a6ab9a962eae..240fe7d98604 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -301,6 +301,7 @@ enum nft_set_desc_attributes {
  *
  * @NFTA_SET_TABLE: table name (NLA_STRING)
  * @NFTA_SET_NAME: set name (NLA_STRING)
+ * @NFTA_SET_HANDLE: set handle (NLA_U64)
  * @NFTA_SET_FLAGS: bitmask of enum nft_set_flags (NLA_U32)
  * @NFTA_SET_KEY_TYPE: key data type, informational purpose only (NLA_U32)
  * @NFTA_SET_KEY_LEN: key data length (NLA_U32)
@@ -318,6 +319,7 @@ enum nft_set_attributes {
 	NFTA_SET_UNSPEC,
 	NFTA_SET_TABLE,
 	NFTA_SET_NAME,
+	NFTA_SET_HANDLE,
 	NFTA_SET_FLAGS,
 	NFTA_SET_KEY_TYPE,
 	NFTA_SET_KEY_LEN,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b4db7bd836d9..4f2ebcd16a1c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2633,6 +2633,7 @@ static const struct nla_policy nft_set_policy[NFTA_SET_MAX + 1] = {
 					    .len = NFT_TABLE_MAXNAMELEN - 1 },
 	[NFTA_SET_NAME]			= { .type = NLA_STRING,
 					    .len = NFT_SET_MAXNAMELEN - 1 },
+	[NFTA_SET_HANDLE]		= { .type = NLA_U64 },
 	[NFTA_SET_FLAGS]		= { .type = NLA_U32 },
 	[NFTA_SET_KEY_TYPE]		= { .type = NLA_U32 },
 	[NFTA_SET_KEY_LEN]		= { .type = NLA_U32 },
@@ -2698,6 +2699,22 @@ static struct nft_set *nf_tables_set_lookup(const struct nft_table *table,
 	return ERR_PTR(-ENOENT);
 }
 
+static struct nft_set *nf_tables_set_lookup_byhandle(const struct nft_table *table,
+						     const struct nlattr *nla, u8 genmask)
+{
+	struct nft_set *set;
+
+	if (nla == NULL)
+		return ERR_PTR(-EINVAL);
+
+	list_for_each_entry(set, &table->sets, list) {
+		if (be64_to_cpu(nla_get_be64(nla)) == set->handle &&
+		    nft_active_genmask(set, genmask))
+			return set;
+	}
+	return ERR_PTR(-ENOENT);
+}
+
 static struct nft_set *nf_tables_set_lookup_byid(const struct net *net,
 						 const struct nlattr *nla,
 						 u8 genmask)
@@ -2813,6 +2830,9 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 		goto nla_put_failure;
 	if (nla_put_string(skb, NFTA_SET_NAME, set->name))
 		goto nla_put_failure;
+	if (nla_put_be64(skb, NFTA_SET_HANDLE, cpu_to_be64(set->handle),
+			 NFTA_SET_PAD))
+		goto nla_put_failure;
 	if (set->flags != 0)
 		if (nla_put_be32(skb, NFTA_SET_FLAGS, htonl(set->flags)))
 			goto nla_put_failure;
@@ -3233,6 +3253,7 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	set->udata  = udata;
 	set->timeout = timeout;
 	set->gc_int = gc_int;
+	set->handle = nf_tables_alloc_handle(table);
 
 	err = ops->init(set, &desc, nla);
 	if (err < 0)
@@ -3290,7 +3311,10 @@ static int nf_tables_delset(struct net *net, struct sock *nlsk,
 	if (err < 0)
 		return err;
 
-	set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_NAME], genmask);
+	if (nla[NFTA_SET_HANDLE])
+		set = nf_tables_set_lookup_byhandle(ctx.table, nla[NFTA_SET_HANDLE], genmask);
+	else
+		set = nf_tables_set_lookup(ctx.table, nla[NFTA_SET_NAME], genmask);
 	if (IS_ERR(set))
 		return PTR_ERR(set);
 
-- 
2.11.0

