From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 6/6] src: add `flush ruleset'
Date: Tue,  2 Sep 2014 16:42:22 +0200
Message-ID: <1409668946-8168-2-git-send-email-arturo.borrero.glez@gmail.com>
References: <1409668946-8168-1-git-send-email-arturo.borrero.glez@gmail.com>
Cc: pablo@netfilter.org, kaber@trash.net,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4.cica.es ([150.214.5.182]:49432 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753942AbaIBOmw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Sep 2014 10:42:52 -0400
In-Reply-To: <1409668946-8168-1-git-send-email-arturo.borrero.glez@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the `flush ruleset' operation to nft.

The syntax is:
 % nft flush ruleset [family]

To flush all the ruleset (all families):
 % nft flush ruleset

To flush the ruleset of a given family:
 % nft flush ruleset ip
 % nft flush ruleset inet

This flush is a shortcut operation which deletes all rules, sets, tables
and chains.
It's possible since the modifications in the kernel to the NFT_MSG_DELTABLE
API call.

Users can benefit of this operation when doing an atomic replacement of the
entire ruleset, loading a file like this:

 =========
 flush ruleset
 table ip filter {
 	chain input {
		counter accept
	}
 }
 =========

Also, users who want to simply clean the ruleset for whatever reason can do it now
without having to iterate families/tables.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/netlink.h |    4 ++++
 src/netlink.c     |   22 ++++++++++++++++++++++
 src/parser.y      |   30 +++++++++++++++++++++++++-----
 src/rule.c        |    2 ++
 src/scanner.l     |    1 +
 5 files changed, 54 insertions(+), 5 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index d7d5c2d..f611452 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -144,6 +144,10 @@ extern int netlink_io_error(struct netlink_ctx *ctx,
 			    const struct location *loc, const char *fmt, ...);
 extern void netlink_open_error(void) __noreturn;
 
+extern int netlink_flush_ruleset(struct netlink_ctx *ctx,
+				 const struct handle *h,
+				 const struct location *loc);
+
 extern struct nft_ruleset *netlink_dump_ruleset(struct netlink_ctx *ctx,
 						const struct handle *h,
 						const struct location *loc);
diff --git a/src/netlink.c b/src/netlink.c
index 102f799..7d3e71f 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1444,6 +1444,28 @@ int netlink_batch_send(struct list_head *err_list)
 	return mnl_batch_talk(nf_sock, err_list);
 }
 
+int netlink_flush_ruleset(struct netlink_ctx *ctx, const struct handle *h,
+			  const struct location *loc)
+{
+	int err;
+	struct nft_table *nlt;
+
+	if (!ctx->batch_supported) {
+		netlink_io_error(ctx, loc, "Operation not supported.");
+		return -1;
+	}
+
+	nlt = alloc_nft_table(h);
+	err = mnl_nft_table_batch_del(nf_sock, nlt, 0, ctx->seqnum);
+	nft_table_free(nlt);
+
+	if (err < 0)
+		netlink_io_error(ctx, loc, "Could not flush the ruleset: %s",
+				 strerror(errno));
+
+	return err;
+}
+
 struct nft_ruleset *netlink_dump_ruleset(struct netlink_ctx *ctx,
 					 const struct handle *h,
 					 const struct location *loc)
diff --git a/src/parser.y b/src/parser.y
index d7bc287..c6df10a 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -187,6 +187,7 @@ static int monitor_lookup_event(const char *event)
 %token ELEMENT			"element"
 %token MAP			"map"
 %token HANDLE			"handle"
+%token RULESET			"ruleset"
 
 %token INET			"inet"
 
@@ -395,11 +396,11 @@ static int monitor_lookup_event(const char *event)
 %type <cmd>			base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd
 %destructor { cmd_free($$); }	base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd
 
-%type <handle>			table_spec tables_spec chain_spec chain_identifier ruleid_spec
-%destructor { handle_free(&$$); } table_spec tables_spec chain_spec chain_identifier ruleid_spec
+%type <handle>			table_spec tables_spec chain_spec chain_identifier ruleid_spec ruleset_spec
+%destructor { handle_free(&$$); } table_spec tables_spec chain_spec chain_identifier ruleid_spec ruleset_spec
 %type <handle>			set_spec set_identifier
 %destructor { handle_free(&$$); } set_spec set_identifier
-%type <val>			handle_spec family_spec position_spec
+%type <val>			handle_spec family_spec family_spec_explicit position_spec
 
 %type <table>			table_block_alloc table_block
 %destructor { close_scope(state); table_free($$); }	table_block_alloc
@@ -773,6 +774,10 @@ flush_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_FLUSH, CMD_OBJ_SET, &$2, &@$, NULL);
 			}
+			|	RULESET		ruleset_spec
+			{
+				$$ = cmd_alloc(CMD_FLUSH, CMD_OBJ_RULESET, &$2, &@$, NULL);
+			}
 			;
 
 rename_cmd		:	CHAIN		chain_spec	identifier
@@ -1162,8 +1167,11 @@ string			:	STRING
 			|	QUOTED_STRING
 			;
 
-family_spec		:	/* empty */	{ $$ = NFPROTO_IPV4; }
-			|	IP		{ $$ = NFPROTO_IPV4; }
+family_spec		:	/* empty */		{ $$ = NFPROTO_IPV4; }
+			|	family_spec_explicit
+			;
+
+family_spec_explicit	:	IP		{ $$ = NFPROTO_IPV4; }
 			|	IP6		{ $$ = NFPROTO_IPV6; }
 			|	INET		{ $$ = NFPROTO_INET; }
 			|	ARP		{ $$ = NFPROTO_ARP; }
@@ -1252,6 +1260,18 @@ comment_spec		:	/* empty */
 			}
 			;
 
+ruleset_spec		:	/* empty */
+			{
+				memset(&$$, 0, sizeof($$));
+				$$.family	= NFPROTO_UNSPEC;
+			}
+			|	family_spec_explicit
+			{
+				memset(&$$, 0, sizeof($$));
+				$$.family	= $1;
+			}
+			;
+
 rule			:	stmt_list	comment_spec
 			{
 				struct stmt *i;
diff --git a/src/rule.c b/src/rule.c
index 1e54526..cb2a228 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -820,6 +820,8 @@ static int do_command_flush(struct netlink_ctx *ctx, struct cmd *cmd)
 		return netlink_flush_table(ctx, &cmd->handle, &cmd->location);
 	case CMD_OBJ_CHAIN:
 		return netlink_flush_chain(ctx, &cmd->handle, &cmd->location);
+	case CMD_OBJ_RULESET:
+		return netlink_flush_ruleset(ctx, &cmd->handle, &cmd->location);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
diff --git a/src/scanner.l b/src/scanner.l
index b7a00b4..f45c61c 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -240,6 +240,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "element"		{ return ELEMENT; }
 "map"			{ return MAP; }
 "handle"		{ return HANDLE; }
+"ruleset"		{ return RULESET; }
 
 "accept"		{ return ACCEPT; }
 "drop"			{ return DROP; }
-- 
1.7.10.4

