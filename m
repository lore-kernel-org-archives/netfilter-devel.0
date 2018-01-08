From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH v2] netfilter: nf_tables: delete table via table handle
Date: Mon,  8 Jan 2018 23:28:18 +0530
Message-ID: <20180108175818.23100-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, harshasharmaiitr@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:41765 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754553AbeAHR6h (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jan 2018 12:58:37 -0500
Received: by mail-pf0-f195.google.com with SMTP id j3so2648469pfh.8
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Jan 2018 09:58:37 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch add code to delete table via unique table handle and table
family.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
Changes in v2:
 - Remove nf_tables_afinfo_lookup_byhandle
 - Change log message

 net/netfilter/nf_tables_api.c | 45 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ba6065c39674..1f1f3be37034 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -400,6 +400,28 @@ static struct nft_table *nft_table_lookup(const struct nft_af_info *afi,
 	return NULL;
 }
 
+static struct nft_table *__nft_table_lookup_byhandle(const struct nft_af_info *afi,
+						     u64 handle, u8 genmask)
+{
+	struct nft_table *table;
+
+	list_for_each_entry(table, &afi->tables, list) {
+		if (handle == table->handle &&
+		    nft_active_genmask(table, genmask))
+			return table;
+	}
+	return NULL;
+}
+
+static struct nft_table *nft_table_lookup_byhandle(const struct nft_af_info *afi,
+						   const struct nlattr *nla,
+						   u8 genmask)
+{
+	return __nft_table_lookup_byhandle(afi,
+					   be64_to_cpu(nla_get_be64(nla)),
+					   genmask);
+}
+
 static struct nft_table *nf_tables_table_lookup(const struct nft_af_info *afi,
 						const struct nlattr *nla,
 						u8 genmask)
@@ -416,6 +438,22 @@ static struct nft_table *nf_tables_table_lookup(const struct nft_af_info *afi,
 	return ERR_PTR(-ENOENT);
 }
 
+static struct nft_table *nf_tables_table_lookup_byhandle(const struct nft_af_info *afi,
+							 const struct nlattr *nla,
+							 u8 genmask)
+{
+	struct nft_table *table;
+
+	if (nla == NULL)
+		return ERR_PTR(-EINVAL);
+
+	table = nft_table_lookup_byhandle(afi, nla, genmask);
+	if (table != NULL)
+		return table;
+
+	return ERR_PTR(-ENOENT);
+}
+
 static inline u64 nf_tables_alloc_handle(struct nft_table *table)
 {
 	return ++table->hgenerator;
@@ -893,14 +931,17 @@ static int nf_tables_deltable(struct net *net, struct sock *nlsk,
 	struct nft_ctx ctx;
 
 	nft_ctx_init(&ctx, net, skb, nlh, NULL, NULL, NULL, nla);
-	if (family == AF_UNSPEC || nla[NFTA_TABLE_NAME] == NULL)
+	if (family == AF_UNSPEC || (nla[NFTA_TABLE_NAME] == NULL && nla[NFTA_TABLE_HANDLE] == NULL))
 		return nft_flush(&ctx, family);
 
 	afi = nf_tables_afinfo_lookup(net, family, false);
 	if (IS_ERR(afi))
 		return PTR_ERR(afi);
+	if (nla[NFTA_TABLE_HANDLE])
+		table = nf_tables_table_lookup_byhandle(afi, nla[NFTA_TABLE_HANDLE], genmask);
+	else
+		table = nf_tables_table_lookup(afi, nla[NFTA_TABLE_NAME], genmask);
 
-	table = nf_tables_table_lookup(afi, nla[NFTA_TABLE_NAME], genmask);
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
-- 
2.11.0

