From: Phil Sutter <phil@nwl.cc>
Subject: [nf-next PATCH v3 3/6] netfilter: nf_tables: Allow table names of up to 255 chars
Date: Thu, 27 Jul 2017 16:56:41 +0200
Message-ID: <20170727145644.16888-4-phil@nwl.cc>
References: <20170727145644.16888-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:41169 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751444AbdG0O45 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jul 2017 10:56:57 -0400
In-Reply-To: <20170727145644.16888-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Allocate all table names dynamically to allow for arbitrary lengths but
introduce NFT_NAME_MAXLEN as an upper sanity boundary. It's value was
chosen to allow using a domain name as per RFC 1035.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Introduce NFT_NAME_MAXLEN as an upper boundary to restrict overly long
  names but still allow to use e.g. domain names.
- Adjust commit messages accordingly.

Changes since v2:
- Adjust commit summary - length is not really unlimited.
- Don't drop NFT_TABLE_MAXNAMELEN macro since it's UAPI.
- Keep using NFT_TABLE_MAXNAMELEN in netlink policies to reduce patch
  size.
- Add size of chain's table name unconditionally to nlmsg size in
  nft_trace_notify() since info->chain should always be present.
---
 include/net/netfilter/nf_tables.h        |  2 +-
 include/uapi/linux/netfilter/nf_tables.h |  3 +-
 net/netfilter/nf_tables_api.c            | 49 +++++++++++++++++++++++---------
 net/netfilter/nf_tables_trace.c          |  2 +-
 4 files changed, 40 insertions(+), 16 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index bd5be0d691d51..05ecf78ec0787 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -957,7 +957,7 @@ struct nft_table {
 	u32				use;
 	u16				flags:14,
 					genmask:2;
-	char				name[NFT_TABLE_MAXNAMELEN];
+	char				*name;
 };
 
 enum nft_af_flags {
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 683f6f88fcace..f796da401672b 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1,7 +1,8 @@
 #ifndef _LINUX_NF_TABLES_H
 #define _LINUX_NF_TABLES_H
 
-#define NFT_TABLE_MAXNAMELEN	32
+#define NFT_NAME_MAXLEN		256
+#define NFT_TABLE_MAXNAMELEN	NFT_NAME_MAXLEN
 #define NFT_CHAIN_MAXNAMELEN	32
 #define NFT_SET_MAXNAMELEN	32
 #define NFT_OBJ_MAXNAMELEN	32
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7843efa33c598..dd824def0a182 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -726,7 +726,10 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 	if (table == NULL)
 		goto err2;
 
-	nla_strlcpy(table->name, name, NFT_TABLE_MAXNAMELEN);
+	table->name = nla_strdup(name, GFP_KERNEL);
+	if (table->name == NULL)
+		goto err3;
+
 	INIT_LIST_HEAD(&table->chains);
 	INIT_LIST_HEAD(&table->sets);
 	INIT_LIST_HEAD(&table->objects);
@@ -735,10 +738,12 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 	nft_ctx_init(&ctx, net, skb, nlh, afi, table, NULL, nla);
 	err = nft_trans_table_add(&ctx, NFT_MSG_NEWTABLE);
 	if (err < 0)
-		goto err3;
+		goto err4;
 
 	list_add_tail_rcu(&table->list, &afi->tables);
 	return 0;
+err4:
+	kfree(table->name);
 err3:
 	kfree(table);
 err2:
@@ -865,6 +870,7 @@ static void nf_tables_table_destroy(struct nft_ctx *ctx)
 {
 	BUG_ON(ctx->table->use > 0);
 
+	kfree(ctx->table->name);
 	kfree(ctx->table);
 	module_put(ctx->afi->owner);
 }
@@ -1977,7 +1983,7 @@ static void nf_tables_rule_notify(const struct nft_ctx *ctx,
 }
 
 struct nft_rule_dump_ctx {
-	char table[NFT_TABLE_MAXNAMELEN];
+	char *table;
 	char chain[NFT_CHAIN_MAXNAMELEN];
 };
 
@@ -2002,7 +2008,7 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 			continue;
 
 		list_for_each_entry_rcu(table, &afi->tables, list) {
-			if (ctx && ctx->table[0] &&
+			if (ctx && ctx->table &&
 			    strcmp(ctx->table, table->name) != 0)
 				continue;
 
@@ -2042,7 +2048,12 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 
 static int nf_tables_dump_rules_done(struct netlink_callback *cb)
 {
-	kfree(cb->data);
+	struct nft_rule_dump_ctx *ctx = cb->data;
+
+	if (ctx) {
+		kfree(ctx->table);
+		kfree(ctx);
+	}
 	return 0;
 }
 
@@ -2074,9 +2085,14 @@ static int nf_tables_getrule(struct net *net, struct sock *nlsk,
 			if (!ctx)
 				return -ENOMEM;
 
-			if (nla[NFTA_RULE_TABLE])
-				nla_strlcpy(ctx->table, nla[NFTA_RULE_TABLE],
-					    sizeof(ctx->table));
+			if (nla[NFTA_RULE_TABLE]) {
+				ctx->table = nla_strdup(nla[NFTA_RULE_TABLE],
+							GFP_KERNEL);
+				if (!ctx->table) {
+					kfree(ctx);
+					return -ENOMEM;
+				}
+			}
 			if (nla[NFTA_RULE_CHAIN])
 				nla_strlcpy(ctx->chain, nla[NFTA_RULE_CHAIN],
 					    sizeof(ctx->chain));
@@ -4415,7 +4431,7 @@ static int nf_tables_fill_obj_info(struct sk_buff *skb, struct net *net,
 }
 
 struct nft_obj_filter {
-	char		table[NFT_OBJ_MAXNAMELEN];
+	char		*table;
 	u32		type;
 };
 
@@ -4480,7 +4496,10 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 
 static int nf_tables_dump_obj_done(struct netlink_callback *cb)
 {
-	kfree(cb->data);
+	struct nft_obj_filter *filter = cb->data;
+
+	kfree(filter->table);
+	kfree(filter);
 
 	return 0;
 }
@@ -4494,9 +4513,13 @@ nft_obj_filter_alloc(const struct nlattr * const nla[])
 	if (!filter)
 		return ERR_PTR(-ENOMEM);
 
-	if (nla[NFTA_OBJ_TABLE])
-		nla_strlcpy(filter->table, nla[NFTA_OBJ_TABLE],
-			    NFT_TABLE_MAXNAMELEN);
+	if (nla[NFTA_OBJ_TABLE]) {
+		filter->table = nla_strdup(nla[NFTA_OBJ_TABLE], GFP_KERNEL);
+		if (!filter->table) {
+			kfree(filter);
+			return ERR_PTR(-ENOMEM);
+		}
+	}
 	if (nla[NFTA_OBJ_TYPE])
 		filter->type = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
 
diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index 0c3a0049e4aa2..62787d985e9d3 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -175,7 +175,7 @@ void nft_trace_notify(struct nft_traceinfo *info)
 		return;
 
 	size = nlmsg_total_size(sizeof(struct nfgenmsg)) +
-		nla_total_size(NFT_TABLE_MAXNAMELEN) +
+		nla_total_size(strlen(info->chain->table->name)) +
 		nla_total_size(NFT_CHAIN_MAXNAMELEN) +
 		nla_total_size_64bit(sizeof(__be64)) +	/* rule handle */
 		nla_total_size(sizeof(__be32)) +	/* trace type */
-- 
2.13.1

