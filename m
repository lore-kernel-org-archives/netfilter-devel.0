From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/3] src: expose table flags
Date: Tue, 17 Mar 2015 13:13:03 +0100
Message-ID: <1426594385-24063-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35486 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959AbbCQMJY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2015 08:09:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The nf_tables kernel API provides a way to disable a table using the
dormant flag. This patch adds the missing code to expose this feature
through nft.

Basically, if you want to disable a table and all its chains from seen
any traffic, you have to type:

 nft add table filter { flags dormant\; }

to re-enable the table, you have to:

 nft add table filter

this clears the flags.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/netlink.h  |    2 +-
 include/rule.h     |    6 ++++++
 src/mnl.c          |    2 ++
 src/netlink.c      |   21 +++++++++++++++++----
 src/parser_bison.y |   13 +++++++++++++
 src/rule.c         |   30 ++++++++++++++++++++++++++++++
 6 files changed, 69 insertions(+), 5 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index 4f79470..c1ff9c6 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -108,7 +108,7 @@ extern int netlink_delete_table(struct netlink_ctx *ctx, const struct handle *h,
 extern int netlink_list_tables(struct netlink_ctx *ctx, const struct handle *h,
 			       const struct location *loc);
 extern int netlink_get_table(struct netlink_ctx *ctx, const struct handle *h,
-			     const struct location *loc);
+			     const struct location *loc, struct table *table);
 extern int netlink_list_table(struct netlink_ctx *ctx, const struct handle *h,
 			      const struct location *loc);
 extern int netlink_flush_table(struct netlink_ctx *ctx, const struct handle *h,
diff --git a/include/rule.h b/include/rule.h
index 491411e..90836bc 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -63,6 +63,10 @@ extern void symbol_bind(struct scope *scope, const char *identifier,
 extern struct symbol *symbol_lookup(const struct scope *scope,
 				    const char *identifier);
 
+enum table_flags {
+	TABLE_F_DORMANT		= (1 << 0),
+};
+
 /**
  * struct table - nftables table
  *
@@ -71,6 +75,7 @@ extern struct symbol *symbol_lookup(const struct scope *scope,
  * @location:	location the table was defined at
  * @chains:	chains contained in the table
  * @sets:	sets contained in the table
+ * @flags:	table flags
  */
 struct table {
 	struct list_head	list;
@@ -79,6 +84,7 @@ struct table {
 	struct scope		scope;
 	struct list_head	chains;
 	struct list_head	sets;
+	enum table_flags 	flags;
 };
 
 extern struct table *table_alloc(void);
diff --git a/src/mnl.c b/src/mnl.c
index f48ead5..89c2bb5 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -707,6 +707,8 @@ int mnl_nft_table_get(struct mnl_socket *nf_sock, struct nft_table *nlt,
 	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE,
 					nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY),
 					NLM_F_ACK, seq);
+	nft_table_nlmsg_build_payload(nlh, nlt);
+
 	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, table_get_cb, nlt);
 }
 
diff --git a/src/netlink.c b/src/netlink.c
index 84d9d27..8c37ec5 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -800,6 +800,11 @@ static int netlink_add_table_batch(struct netlink_ctx *ctx,
 	int err;
 
 	nlt = alloc_nft_table(h);
+	if (table != NULL)
+		nft_table_attr_set_u32(nlt, NFT_TABLE_ATTR_FLAGS, table->flags);
+	else
+		nft_table_attr_set_u32(nlt, NFT_TABLE_ATTR_FLAGS, 0);
+
 	err = mnl_nft_table_batch_add(nlt, excl ? NLM_F_EXCL : 0,
 				      ctx->seqnum);
 	nft_table_free(nlt);
@@ -887,6 +892,8 @@ static struct table *netlink_delinearize_table(struct netlink_ctx *ctx,
 		nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY);
 	table->handle.table  =
 		xstrdup(nft_table_attr_get_str(nlt, NFT_TABLE_ATTR_NAME));
+	table->flags	     =
+		nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FLAGS);
 
 	return table;
 }
@@ -923,22 +930,28 @@ int netlink_list_tables(struct netlink_ctx *ctx, const struct handle *h,
 }
 
 int netlink_get_table(struct netlink_ctx *ctx, const struct handle *h,
-		      const struct location *loc)
+		      const struct location *loc, struct table *table)
 {
 	struct nft_table *nlt;
+	struct table *ntable;
 	int err;
 
 	nlt = alloc_nft_table(h);
 	err = mnl_nft_table_get(nf_sock, nlt, 0);
 	nft_table_free(nlt);
 
-	if (err < 0)
+	if (err < 0) {
 		netlink_io_error(ctx, loc,
 				 "Could not receive table from kernel: %s",
 				 strerror(errno));
-	return err;
-}
+		return err;
+	}
 
+	ntable = netlink_delinearize_table(ctx, nlt);
+	table->flags = ntable->flags;
+	xfree(ntable);
+	return 0;
+}
 
 int netlink_list_table(struct netlink_ctx *ctx, const struct handle *h,
 		       const struct location *loc)
diff --git a/src/parser_bison.y b/src/parser_bison.y
index fd2407c..6fc834d 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -853,9 +853,22 @@ table_block_alloc	:	/* empty */
 			}
 			;
 
+table_options		:	FLAGS		STRING
+			{
+				if (strcmp($2, "dormant") == 0) {
+					$<table>0->flags = TABLE_F_DORMANT;
+				} else {
+					erec_queue(error(&@2, "unknown table option %s", $2),
+						   state->msgs);
+					YYERROR;
+				}
+			}
+			;
+
 table_block		:	/* empty */	{ $$ = $<table>-1; }
 			|	table_block	common_block
 			|	table_block	stmt_seperator
+			|	table_block	table_options	stmt_seperator
 			|	table_block	CHAIN		chain_identifier
 					chain_block_alloc	'{' 	chain_block	'}'
 					stmt_seperator
diff --git a/src/rule.c b/src/rule.c
index feafe26..3c92589 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -501,6 +501,32 @@ struct table *table_lookup(const struct handle *h)
 	return NULL;
 }
 
+#define TABLE_FLAGS_MAX 1
+
+const char *table_flags_name[TABLE_FLAGS_MAX] = {
+	"dormant",
+};
+
+static void table_print_options(const struct table *table, const char **delim)
+{
+	uint32_t flags = table->flags;
+	int i;
+
+	if (flags) {
+		printf("\tflags ");
+
+		for (i = 0; i < TABLE_FLAGS_MAX; i++) {
+			if (flags & 0x1)
+				printf("%s", table_flags_name[i]);
+			flags >>= 1;
+			if (flags)
+				printf(",");
+		}
+		printf("\n");
+		*delim = "\n";
+	}
+}
+
 static void table_print(const struct table *table)
 {
 	struct chain *chain;
@@ -509,6 +535,8 @@ static void table_print(const struct table *table)
 	const char *family = family2str(table->handle.family);
 
 	printf("table %s %s {\n", family, table->handle.table);
+	table_print_options(table, &delim);
+
 	list_for_each_entry(set, &table->sets, list) {
 		if (set->flags & SET_F_ANONYMOUS)
 			continue;
@@ -778,6 +806,8 @@ static int do_list_table(struct netlink_ctx *ctx, struct cmd *cmd,
 	struct rule *rule, *nrule;
 	struct chain *chain;
 
+	if (netlink_get_table(ctx, &cmd->handle, &cmd->location, table) < 0)
+		goto err;
 	if (do_list_sets(ctx, &cmd->location, table) < 0)
 		goto err;
 	if (netlink_list_chains(ctx, &cmd->handle, &cmd->location) < 0)
-- 
1.7.10.4

