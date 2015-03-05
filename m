From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next] netfilter: nf_tables: limit maximum table name length to 32 bytes
Date: Thu,  5 Mar 2015 15:05:36 +0100
Message-ID: <1425564336-7265-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44966 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbbCEOB6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Mar 2015 09:01:58 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Set the same as we use for chain names, it should be enough.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Patrick: I'm planning to add per-table information after the name field, this
will make it easier and this stays consistent to what we have in chains and
sets (and other new object we'll add). I wouldn't expect people using larger
names than this limit.

 include/net/netfilter/nf_tables.h        |    2 +-
 include/uapi/linux/netfilter/nf_tables.h |    1 +
 net/netfilter/nf_tables_api.c            |    7 ++++---
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9eaaa78..f1e81d7 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -584,7 +584,7 @@ struct nft_table {
 	u64				hgenerator;
 	u32				use;
 	u16				flags;
-	char				name[];
+	char				name[NFT_TABLE_MAXNAMELEN];
 };
 
 /**
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 832bc46..b978393 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_NF_TABLES_H
 #define _LINUX_NF_TABLES_H
 
+#define NFT_TABLE_MAXNAMELEN	32
 #define NFT_CHAIN_MAXNAMELEN	32
 #define NFT_USERDATA_MAXLEN	256
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a8c9462..9168e6c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -401,7 +401,8 @@ nf_tables_chain_type_lookup(const struct nft_af_info *afi,
 }
 
 static const struct nla_policy nft_table_policy[NFTA_TABLE_MAX + 1] = {
-	[NFTA_TABLE_NAME]	= { .type = NLA_STRING },
+	[NFTA_TABLE_NAME]	= { .type = NLA_STRING,
+				    .len = NFT_TABLE_MAXNAMELEN - 1 },
 	[NFTA_TABLE_FLAGS]	= { .type = NLA_U32 },
 };
 
@@ -686,13 +687,13 @@ static int nf_tables_newtable(struct sock *nlsk, struct sk_buff *skb,
 	if (!try_module_get(afi->owner))
 		return -EAFNOSUPPORT;
 
-	table = kzalloc(sizeof(*table) + nla_len(name), GFP_KERNEL);
+	table = kzalloc(sizeof(*table), GFP_KERNEL);
 	if (table == NULL) {
 		module_put(afi->owner);
 		return -ENOMEM;
 	}
 
-	nla_strlcpy(table->name, name, nla_len(name));
+	nla_strlcpy(table->name, name, NFT_TABLE_MAXNAMELEN);
 	INIT_LIST_HEAD(&table->chains);
 	INIT_LIST_HEAD(&table->sets);
 	table->flags = flags;
-- 
1.7.10.4

