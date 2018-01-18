From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH v2] src: print 'handle' attribute in tables
Date: Fri, 19 Jan 2018 01:23:48 +0530
Message-ID: <20180118195348.12844-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, harshasharmaiitr@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:39306 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754976AbeARTyI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Jan 2018 14:54:08 -0500
Received: by mail-pf0-f194.google.com with SMTP id e11so15475191pff.6
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Jan 2018 11:54:08 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Print 'handle' attribute in tables, when listing via '-a' option

For eg.
nft list ruleset -a

table ip test-ip4 {
	chain input {
		ip saddr 8.8.8.8 counter packets 0 bytes 0 # handle 3
	}
} # handle 1
table ip filter {
	chain output {
		tcp dport ssh counter packets 0 bytes 0 # handle 4
	}
} # handle 2
table ip xyz {
} # handle 3

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
Change in v2:
 - print handle after '}'
 - change log message accordingly

 include/linux/netfilter/nf_tables.h | 4 ++++
 src/netlink.c                       | 6 +++++-
 src/rule.c                          | 5 ++++-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index f328944..6db9130 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -160,12 +160,14 @@ enum nft_table_flags {
  * @NFTA_TABLE_NAME: name of the table (NLA_STRING)
  * @NFTA_TABLE_FLAGS: bitmask of enum nft_table_flags (NLA_U32)
  * @NFTA_TABLE_USE: number of chains in this table (NLA_U32)
+ * @NFTA_TABLE_HANDLE: numeric handle of the table (NLA_U64)
  */
 enum nft_table_attributes {
 	NFTA_TABLE_UNSPEC,
 	NFTA_TABLE_NAME,
 	NFTA_TABLE_FLAGS,
 	NFTA_TABLE_USE,
+	NFTA_TABLE_HANDLE,
 	__NFTA_TABLE_MAX
 };
 #define NFTA_TABLE_MAX		(__NFTA_TABLE_MAX - 1)
@@ -1307,6 +1309,7 @@ enum nft_object_attributes {
  *
  * @NFTA_TRACE_TABLE: name of the table (NLA_STRING)
  * @NFTA_TRACE_CHAIN: name of the chain (NLA_STRING)
+ * @NFTA_TRACE_TABLE_HANDLE: numeric handle of the table (NLA_U64)
  * @NFTA_TRACE_RULE_HANDLE: numeric handle of the rule (NLA_U64)
  * @NFTA_TRACE_TYPE: type of the event (NLA_U32: nft_trace_types)
  * @NFTA_TRACE_VERDICT: verdict returned by hook (NLA_NESTED: nft_verdicts)
@@ -1326,6 +1329,7 @@ enum nft_trace_attributes {
 	NFTA_TRACE_UNSPEC,
 	NFTA_TRACE_TABLE,
 	NFTA_TRACE_CHAIN,
+	NFTA_TRACE_TABLE_HANDLE,
 	NFTA_TRACE_RULE_HANDLE,
 	NFTA_TRACE_TYPE,
 	NFTA_TRACE_VERDICT,
diff --git a/src/netlink.c b/src/netlink.c
index 8653ae6..59d7096 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -123,6 +123,8 @@ struct nftnl_table *alloc_nftnl_table(const struct handle *h)
 	nftnl_table_set_u32(nlt, NFTNL_TABLE_FAMILY, h->family);
 	if (h->table != NULL)
 		nftnl_table_set(nlt, NFTNL_TABLE_NAME, h->table);
+	if (h->handle.id)
+		nftnl_table_set_u64(nlt, NFTNL_TABLE_HANDLE, h->handle.id);
 
 	return nlt;
 }
@@ -137,7 +139,7 @@ struct nftnl_chain *alloc_nftnl_chain(const struct handle *h)
 
 	nftnl_chain_set_u32(nlc, NFTNL_CHAIN_FAMILY, h->family);
 	nftnl_chain_set_str(nlc, NFTNL_CHAIN_TABLE, h->table);
-	if (h->handle.id != 0)
+	if (h->handle.id)
 		nftnl_chain_set_u64(nlc, NFTNL_CHAIN_HANDLE, h->handle.id);
 	if (h->chain != NULL)
 		nftnl_chain_set_str(nlc, NFTNL_CHAIN_NAME, h->chain);
@@ -964,6 +966,7 @@ static struct table *netlink_delinearize_table(struct netlink_ctx *ctx,
 	table->handle.family = nftnl_table_get_u32(nlt, NFTNL_TABLE_FAMILY);
 	table->handle.table  = xstrdup(nftnl_table_get_str(nlt, NFTNL_TABLE_NAME));
 	table->flags	     = nftnl_table_get_u32(nlt, NFTNL_TABLE_FLAGS);
+	table->handle.handle.id = nftnl_table_get_u64(nlt, NFTNL_TABLE_HANDLE);
 
 	return table;
 }
@@ -992,6 +995,7 @@ int netlink_list_tables(struct netlink_ctx *ctx, const struct handle *h,
 		return 0;
 	}
 
+	ctx->data = h;
 	nftnl_table_list_foreach(table_cache, list_table_cb, ctx);
 	nftnl_table_list_free(table_cache);
 	return 0;
diff --git a/src/rule.c b/src/rule.c
index bb9add0..a1e6bfd 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -820,7 +820,10 @@ static void table_print(const struct table *table, struct output_ctx *octx)
 		chain_print(chain, octx);
 		delim = "\n";
 	}
-	nft_print(octx, "}\n");
+	nft_print(octx, "}");
+	if (octx->handle > 0)
+		nft_print(octx, " # handle %" PRIu64, table->handle.handle.id);
+	nft_print(octx, "\n");
 }
 
 struct cmd *cmd_alloc(enum cmd_ops op, enum cmd_obj obj,
-- 
2.11.0

