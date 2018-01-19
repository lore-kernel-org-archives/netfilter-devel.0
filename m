From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next] netfilter: nf_tables: allocate flowtable handle and delete flowtable via handle
Date: Fri, 19 Jan 2018 13:02:37 +0100
Message-ID: <20180119120237.13370-1-pablo@netfilter.org>
Cc: harshasharmaiitr@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34350 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754771AbeASMCr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 07:02:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BD0071BCFC4
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 13:02:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AFCDDDA858
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 13:02:44 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch add code to allocate unique object handles and delete objects
via those unique object handles.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Harsha: Only this one missing, I quickly made it here.

 include/net/netfilter/nf_tables.h        |  2 ++
 include/uapi/linux/netfilter/nf_tables.h |  3 +++
 net/netfilter/nf_tables_api.c            | 31 ++++++++++++++++++++++++++++---
 3 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index a0b394be1190..140c7cef2cf8 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1079,6 +1079,7 @@ void nft_unregister_obj(struct nft_object_type *obj_type);
  *	@ops_len: number of hooks in array
  *	@genmask: generation mask
  *	@use: number of references to this flow table
+ * 	@handle: unique object handle
  *	@data: rhashtable and garbage collector
  * 	@ops: array of hooks
  */
@@ -1091,6 +1092,7 @@ struct nft_flowtable {
 	int				ops_len;
 	u32				genmask:2,
 					use:30;
+	u64				handle;
 	/* runtime data below here */
 	struct nf_hook_ops		*ops ____cacheline_aligned;
 	struct nf_flowtable		data;
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 026ca07da3be..66dceee0ae30 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1340,6 +1340,7 @@ enum nft_object_attributes {
  * @NFTA_FLOWTABLE_NAME: name of this flow table (NLA_STRING)
  * @NFTA_FLOWTABLE_HOOK: netfilter hook configuration(NLA_U32)
  * @NFTA_FLOWTABLE_USE: number of references to this flow table (NLA_U32)
+ * @NFTA_FLOWTABLE_HANDLE: object handle (NLA_U64)
  */
 enum nft_flowtable_attributes {
 	NFTA_FLOWTABLE_UNSPEC,
@@ -1347,6 +1348,8 @@ enum nft_flowtable_attributes {
 	NFTA_FLOWTABLE_NAME,
 	NFTA_FLOWTABLE_HOOK,
 	NFTA_FLOWTABLE_USE,
+	NFTA_FLOWTABLE_HANDLE,
+	NFTA_FLOWTABLE_PAD,
 	__NFTA_FLOWTABLE_MAX
 };
 #define NFTA_FLOWTABLE_MAX	(__NFTA_FLOWTABLE_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d0c646bc8a19..1addc401ff7d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4832,6 +4832,7 @@ static const struct nla_policy nft_flowtable_policy[NFTA_FLOWTABLE_MAX + 1] = {
 	[NFTA_FLOWTABLE_NAME]		= { .type = NLA_STRING,
 					    .len = NFT_NAME_MAXLEN - 1 },
 	[NFTA_FLOWTABLE_HOOK]		= { .type = NLA_NESTED },
+	[NFTA_FLOWTABLE_HANDLE]		= { .type = NLA_U64 },
 };
 
 struct nft_flowtable *nf_tables_flowtable_lookup(const struct nft_table *table,
@@ -4849,6 +4850,20 @@ struct nft_flowtable *nf_tables_flowtable_lookup(const struct nft_table *table,
 }
 EXPORT_SYMBOL_GPL(nf_tables_flowtable_lookup);
 
+struct nft_flowtable *
+nf_tables_flowtable_lookup_byhandle(const struct nft_table *table,
+				    const struct nlattr *nla, u8 genmask)
+{
+       struct nft_flowtable *flowtable;
+
+       list_for_each_entry(flowtable, &table->flowtables, list) {
+               if (be64_to_cpu(nla_get_be64(nla)) == flowtable->handle &&
+                   nft_active_genmask(flowtable, genmask))
+                       return flowtable;
+       }
+       return ERR_PTR(-ENOENT);
+}
+
 #define NFT_FLOWTABLE_DEVICE_MAX	8
 
 static int nf_tables_parse_devices(const struct nft_ctx *ctx,
@@ -5057,6 +5072,8 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 		return -ENOMEM;
 
 	flowtable->table = table;
+	flowtable->handle = nf_tables_alloc_handle(table);
+
 	flowtable->name = nla_strdup(nla[NFTA_FLOWTABLE_NAME], GFP_KERNEL);
 	if (!flowtable->name) {
 		err = -ENOMEM;
@@ -5131,8 +5148,14 @@ static int nf_tables_delflowtable(struct net *net, struct sock *nlsk,
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
-	flowtable = nf_tables_flowtable_lookup(table, nla[NFTA_FLOWTABLE_NAME],
-					       genmask);
+	if (nla[NFTA_FLOWTABLE_HANDLE])
+		flowtable = nf_tables_flowtable_lookup_byhandle(table,
+								nla[NFTA_FLOWTABLE_HANDLE],
+								genmask);
+	else
+		flowtable = nf_tables_flowtable_lookup(table,
+						       nla[NFTA_FLOWTABLE_NAME],
+						       genmask);
 	if (IS_ERR(flowtable))
                 return PTR_ERR(flowtable);
 	if (flowtable->use > 0)
@@ -5165,7 +5188,9 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 
 	if (nla_put_string(skb, NFTA_FLOWTABLE_TABLE, flowtable->table->name) ||
 	    nla_put_string(skb, NFTA_FLOWTABLE_NAME, flowtable->name) ||
-	    nla_put_be32(skb, NFTA_FLOWTABLE_USE, htonl(flowtable->use)))
+	    nla_put_be32(skb, NFTA_FLOWTABLE_USE, htonl(flowtable->use)) ||
+	    nla_put_be64(skb, NFTA_FLOWTABLE_HANDLE, cpu_to_be64(flowtable->handle),
+			 NFTA_FLOWTABLE_PAD))
 		goto nla_put_failure;
 
 	nest = nla_nest_start(skb, NFTA_FLOWTABLE_HOOK);
-- 
2.11.0

