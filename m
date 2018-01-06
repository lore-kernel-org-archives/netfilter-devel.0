From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] netfilter: nf_tables: delete table via table handle
Date: Sun,  7 Jan 2018 00:00:15 +0530
Message-ID: <20180106183015.11557-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, harshasharmaiitr@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:45705 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751136AbeAFSam (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Jan 2018 13:30:42 -0500
Received: by mail-pf0-f196.google.com with SMTP id u19so3542335pfa.12
        for <netfilter-devel@vger.kernel.org>; Sat, 06 Jan 2018 10:30:42 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch add code to delete table via unique table handle.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 net/netfilter/nf_tables_api.c | 99 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 92 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index dabdd2ed66c8..3b1c879fdf61 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -73,6 +73,24 @@ static struct nft_af_info *nft_afinfo_lookup(struct net *net, int family)
 	return NULL;
 }
 
+static struct nft_af_info *nft_afinfo_lookup_byhandle(struct net *net,
+						      u64 handle)
+{
+	struct nft_af_info *afi;
+	struct nft_table *table;
+	int table_handle_check_flag = 0;
+
+	list_for_each_entry(afi, &net->nft.af_info, list) {
+		list_for_each_entry(table, &afi->tables, list) {
+			if (table->handle == handle)
+				table_handle_check_flag = 1;
+		}
+		if (table_handle_check_flag)
+			return afi;
+	}
+	return NULL;
+}
+
 static struct nft_af_info *
 nf_tables_afinfo_lookup(struct net *net, int family, bool autoload)
 {
@@ -94,6 +112,27 @@ nf_tables_afinfo_lookup(struct net *net, int family, bool autoload)
 	return ERR_PTR(-EAFNOSUPPORT);
 }
 
+static struct nft_af_info *
+nf_tables_afinfo_lookup_byhandle(struct net *net, u64 handle, bool autoload)
+{
+	struct nft_af_info *afi;
+
+	afi = nft_afinfo_lookup_byhandle(net, handle);
+	if (afi != NULL)
+		return afi;
+#ifdef CONFIG_MODULES
+	if (autoload) {
+		nfnl_unlock(NFNL_SUBSYS_NFTABLES);
+		request_module("nft-afinfo");
+		nfnl_lock(NFNL_SUBSYS_NFTABLES);
+		afi = nft_afinfo_lookup_byhandle(net, handle);
+		if (afi != NULL)
+			return ERR_PTR(-EAGAIN);
+	}
+#endif
+	return ERR_PTR(-EAFNOSUPPORT);
+}
+
 static void nft_ctx_init(struct nft_ctx *ctx,
 			 struct net *net,
 			 const struct sk_buff *skb,
@@ -107,7 +146,7 @@ static void nft_ctx_init(struct nft_ctx *ctx,
 	ctx->afi	= afi;
 	ctx->table	= table;
 	ctx->chain	= chain;
-	ctx->nla   	= nla;
+	ctx->nla	= nla;
 	ctx->portid	= NETLINK_CB(skb).portid;
 	ctx->report	= nlmsg_report(nlh);
 	ctx->seq	= nlh->nlmsg_seq;
@@ -367,6 +406,28 @@ static struct nft_table *nft_table_lookup(const struct nft_af_info *afi,
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
@@ -383,6 +444,22 @@ static struct nft_table *nf_tables_table_lookup(const struct nft_af_info *afi,
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
@@ -854,14 +931,22 @@ static int nf_tables_deltable(struct net *net, struct sock *nlsk,
 	struct nft_ctx ctx;
 
 	nft_ctx_init(&ctx, net, skb, nlh, NULL, NULL, NULL, nla);
-	if (family == AF_UNSPEC || nla[NFTA_TABLE_NAME] == NULL)
+	if (nla[NFTA_TABLE_HANDLE]) {
+		afi = nf_tables_afinfo_lookup_byhandle(net, be64_to_cpu(nla_get_be64(nla[NFTA_TABLE_HANDLE])), false);
+		if (IS_ERR(afi))
+			return PTR_ERR(afi);
+		else
+			table = nf_tables_table_lookup_byhandle(afi, nla[NFTA_TABLE_HANDLE], genmask);
+	} else if (family == AF_UNSPEC || nla[NFTA_TABLE_NAME] == NULL) {
 		return nft_flush(&ctx, family);
+	} else {
 
-	afi = nf_tables_afinfo_lookup(net, family, false);
-	if (IS_ERR(afi))
-		return PTR_ERR(afi);
-
-	table = nf_tables_table_lookup(afi, nla[NFTA_TABLE_NAME], genmask);
+		afi = nf_tables_afinfo_lookup(net, family, false);
+		if (IS_ERR(afi))
+			return PTR_ERR(afi);
+		else
+			table = nf_tables_table_lookup(afi, nla[NFTA_TABLE_NAME], genmask);
+	}
 	if (IS_ERR(table))
 		return PTR_ERR(table);
 
-- 
2.11.0

