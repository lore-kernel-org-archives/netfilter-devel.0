From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH v3] netfilter: nf_tables: delete table via table handle
Date: Tue,  9 Jan 2018 14:23:34 +0530
Message-ID: <20180109085334.3500-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, harshasharmaiitr@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:45981 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751728AbeAIIxs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Jan 2018 03:53:48 -0500
Received: by mail-pf0-f196.google.com with SMTP id u19so8082087pfa.12
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Jan 2018 00:53:48 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch add code to delete table via unique table handle and table
family.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
Changes in v3:
 -Remove __nft_table_lookup_byhandle

Changes in v2:
 - Remove nf_tables_afinfo_lookup_byhandle
 - Change log message

 net/netfilter/nf_tables_api.c | 38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index dabdd2ed66c8..f12671e0ec48 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -367,6 +367,20 @@ static struct nft_table *nft_table_lookup(const struct nft_af_info *afi,
 	return NULL;
 }
 
+static struct nft_table *nft_table_lookup_byhandle(const struct nft_af_info *afi,
+						   const struct nlattr *nla,
+								 u8 genmask)
+{
+	struct nft_table *table;
+
+	list_for_each_entry(table, &afi->tables, list) {
+		if (be64_to_cpu(nla_get_be64(nla)) == table->handle &&
+		    nft_active_genmask(table, genmask))
+			return table;
+	}
+	return NULL;
+}
+
 static struct nft_table *nf_tables_table_lookup(const struct nft_af_info *afi,
 						const struct nlattr *nla,
 						u8 genmask)
@@ -383,6 +397,22 @@ static struct nft_table *nf_tables_table_lookup(const struct nft_af_info *afi,
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
@@ -854,14 +884,18 @@ static int nf_tables_deltable(struct net *net, struct sock *nlsk,
 	struct nft_ctx ctx;
 
 	nft_ctx_init(&ctx, net, skb, nlh, NULL, NULL, NULL, nla);
-	if (family == AF_UNSPEC || nla[NFTA_TABLE_NAME] == NULL)
+	if (family == AF_UNSPEC ||
+	    (!nla[NFTA_TABLE_NAME] && !nla[NFTA_TABLE_HANDLE]))
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

