Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4203CC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Nov 2022 16:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiKXQ5N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Nov 2022 11:57:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiKXQ5A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2022 11:57:00 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4AB179AAD
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2022 08:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Rj4ZMrS/XzlXIqrQ0wGxMyEbRrRt14mJ/aRnrti2KKs=; b=WAwjaFX0TwvIha4Cc4EOOqEO+o
        3J59TvHKM4xqjsTJn34sWZzuQRY5W+AJmoeVbaQmE9N9pcaM9Q/+882hVxeYBOSDFd5Eylusgb8TR
        RAi0x871Hb3TcJvNl52L+M0ru0qvIv4YLFLR3OEzWaA+PyqkiDHzu+S5S4fbg4S8PTC2HOjqPvMNC
        RtiHiGc7y5151xtJ/LiHnQvVx5oJaHsJ1gl4Sea6uaHh0PNrJK73e4Jo5gawIe950TG+p1KvyNorH
        Kp6sHB9qKLu5SVyMJ5YDWtKfM6tJ0ZGsh70bqn01CLZcv5tdbsdhhank2oxJL5fJiOOI8RCZi15zw
        8dEDhW3A==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oyFWs-0000qn-Ao; Thu, 24 Nov 2022 17:56:50 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 3/4] xt: Rewrite unsupported compat expression dumping
Date:   Thu, 24 Nov 2022 17:56:40 +0100
Message-Id: <20221124165641.26921-4-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221124165641.26921-1-phil@nwl.cc>
References: <20221124165641.26921-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Choose a format which provides more information and is easily parseable.
Then teach parsers about it and make it explicitly reject the ruleset
giving a meaningful explanation. Also update the man pages with some
more details.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/libnftables-json.adoc | 18 +++++++++++++++---
 doc/statements.txt        | 17 +++++++++++++++++
 include/json.h            |  2 ++
 include/parser.h          |  1 +
 src/json.c                | 19 +++++++++++++------
 src/parser_bison.y        | 18 ++++++++++++++++++
 src/parser_json.c         |  5 +++++
 src/scanner.l             |  3 +++
 src/statement.c           |  1 +
 src/xt.c                  |  8 +++++++-
 10 files changed, 82 insertions(+), 10 deletions(-)

diff --git a/doc/libnftables-json.adoc b/doc/libnftables-json.adoc
index bb59945fc510d..d985149a0af35 100644
--- a/doc/libnftables-json.adoc
+++ b/doc/libnftables-json.adoc
@@ -1059,10 +1059,22 @@ Assign connection tracking expectation.
 
 === XT
 [verse]
-*{ "xt": null }*
+____
+*{ "xt": {
+	"type":* 'TYPENAME'*,
+	"name":* 'STRING'
+*}}*
+
+'TYPENAME' := *match* | *target* | *watcher*
+____
+
+This represents an xt statement from xtables compat interface. It is a
+fallback if translation is not available or not complete.
+
+Seeing this means the ruleset (or parts of it) were created by *iptables-nft*
+and one should use that to manage it.
 
-This represents an xt statement from xtables compat interface. Sadly, at this
-point, it is not possible to provide any further information about its content.
+*BEWARE:* nftables won't restore these statements.
 
 == EXPRESSIONS
 Expressions are the building blocks of (most) statements. In their most basic
diff --git a/doc/statements.txt b/doc/statements.txt
index 8076c21cded41..6c0baf92dab27 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -783,3 +783,20 @@ ____
 # jump to different chains depending on layer 4 protocol type:
 nft add rule ip filter input ip protocol vmap { tcp : jump tcp-chain, udp : jump udp-chain , icmp : jump icmp-chain }
 ------------------------
+
+XT STATEMENT
+~~~~~~~~~~~~
+This represents an xt statement from xtables compat interface. It is a
+fallback if translation is not available or not complete.
+
+[verse]
+____
+*xt* 'TYPE' 'NAME'
+
+'TYPE' := *match* | *target* | *watcher*
+____
+
+Seeing this means the ruleset (or parts of it) were created by *iptables-nft*
+and one should use that to manage it.
+
+*BEWARE:* nftables won't restore these statements.
diff --git a/include/json.h b/include/json.h
index b0d78eb84987e..f691678d4d726 100644
--- a/include/json.h
+++ b/include/json.h
@@ -92,6 +92,7 @@ json_t *connlimit_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 json_t *tproxy_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 json_t *synproxy_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 json_t *optstrip_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
+json_t *xt_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 
 int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd);
 
@@ -194,6 +195,7 @@ STMT_PRINT_STUB(connlimit)
 STMT_PRINT_STUB(tproxy)
 STMT_PRINT_STUB(synproxy)
 STMT_PRINT_STUB(optstrip)
+STMT_PRINT_STUB(xt)
 
 #undef STMT_PRINT_STUB
 #undef EXPR_PRINT_STUB
diff --git a/include/parser.h b/include/parser.h
index f55da0fd47bf2..977fbb94fbd62 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -50,6 +50,7 @@ enum startcond_type {
 	PARSER_SC_TCP,
 	PARSER_SC_TYPE,
 	PARSER_SC_VLAN,
+	PARSER_SC_XT,
 	PARSER_SC_CMD_EXPORT,
 	PARSER_SC_CMD_IMPORT,
 	PARSER_SC_CMD_LIST,
diff --git a/src/json.c b/src/json.c
index 6662f8087736a..89ff8a344c2e4 100644
--- a/src/json.c
+++ b/src/json.c
@@ -82,12 +82,6 @@ static json_t *stmt_print_json(const struct stmt *stmt, struct output_ctx *octx)
 	char buf[1024];
 	FILE *fp;
 
-	/* XXX: Can't be supported at this point:
-	 * xt_stmt_xlate() ignores output_fp.
-	 */
-	if (stmt->ops->type == STMT_XT)
-		return json_pack("{s:n}", "xt");
-
 	if (stmt->ops->json)
 		return stmt->ops->json(stmt, octx);
 
@@ -1624,6 +1618,19 @@ json_t *optstrip_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 			 expr_print_json(stmt->optstrip.expr, octx));
 }
 
+json_t *xt_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
+{
+	static const char *xt_typename[NFT_XT_MAX] = {
+		[NFT_XT_MATCH]          = "match",
+		[NFT_XT_TARGET]         = "target",
+		[NFT_XT_WATCHER]        = "watcher",
+	};
+
+	return json_pack("{s:{s:s, s:s}}", "xt",
+			 "type", xt_typename[stmt->xt.type],
+			 "name", stmt->xt.name);
+}
+
 static json_t *table_print_json_full(struct netlink_ctx *ctx,
 				     struct table *table)
 {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 760c23cf33223..d7cf8bc5fb1ee 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -626,6 +626,8 @@ int nft_lex(void *, void *, void *);
 %token IN			"in"
 %token OUT			"out"
 
+%token XT		"xt"
+
 %type <limit_rate>		limit_rate_pkts
 %type <limit_rate>		limit_rate_bytes
 
@@ -900,6 +902,9 @@ int nft_lex(void *, void *, void *);
 %type <stmt>			optstrip_stmt
 %destructor { stmt_free($$); }	optstrip_stmt
 
+%type <stmt>			xt_stmt
+%destructor { stmt_free($$); }	xt_stmt
+
 %type <expr>			boolean_expr
 %destructor { expr_free($$); }	boolean_expr
 %type <val8>			boolean_keys
@@ -991,6 +996,7 @@ close_scope_udplite	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_UDPL
 
 close_scope_log		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_STMT_LOG); }
 close_scope_synproxy	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_STMT_SYNPROXY); }
+close_scope_xt		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_XT); }
 
 common_block		:	INCLUDE		QUOTED_STRING	stmt_separator
 			{
@@ -2879,6 +2885,18 @@ stmt			:	verdict_stmt
 			|	synproxy_stmt	close_scope_synproxy
 			|	chain_stmt
 			|	optstrip_stmt
+			|	xt_stmt		close_scope_xt
+			;
+
+xt_stmt			:	XT	STRING	STRING
+			{
+				$$ = NULL;
+				xfree($2);
+				xfree($3);
+				erec_queue(error(&@$, "unsupported xtables compat expression, use iptables-nft with this ruleset"),
+					   state->msgs);
+				YYERROR;
+			}
 			;
 
 chain_stmt_type		:	JUMP	{ $$ = NFT_JUMP; }
diff --git a/src/parser_json.c b/src/parser_json.c
index 76c268f857202..057b4f4e3ff2c 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2764,6 +2764,11 @@ static struct stmt *json_parse_stmt(struct json_ctx *ctx, json_t *root)
 		return verdict_stmt_alloc(int_loc, expr);
 	}
 
+	if (!strcmp(type, "xt")) {
+		json_error(ctx, "unsupported xtables compat expression, use iptables-nft with this ruleset");
+		return NULL;
+	}
+
 	for (i = 0; i < array_size(stmt_parser_tbl); i++) {
 		if (!strcmp(type, stmt_parser_tbl[i].key))
 			return stmt_parser_tbl[i].cb(ctx, stmt_parser_tbl[i].key, tmp);
diff --git a/src/scanner.l b/src/scanner.l
index 1371cd044b65a..4edd729c80dab 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -214,6 +214,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_TCP
 %s SCANSTATE_TYPE
 %s SCANSTATE_VLAN
+%s SCANSTATE_XT
 %s SCANSTATE_CMD_EXPORT
 %s SCANSTATE_CMD_IMPORT
 %s SCANSTATE_CMD_LIST
@@ -799,6 +800,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "secmark"		{ scanner_push_start_cond(yyscanner, SCANSTATE_SECMARK); return SECMARK; }
 
+"xt"			{ scanner_push_start_cond(yyscanner, SCANSTATE_XT); return XT; }
+
 {addrstring}		{
 				yylval->string = xstrdup(yytext);
 				return STRING;
diff --git a/src/statement.c b/src/statement.c
index 327d00f99200a..eafc51c484de9 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -997,6 +997,7 @@ static const struct stmt_ops xt_stmt_ops = {
 	.name		= "xt",
 	.print		= xt_stmt_print,
 	.destroy	= xt_stmt_destroy,
+	.json		= xt_stmt_json,
 };
 
 struct stmt *xt_stmt_alloc(const struct location *loc)
diff --git a/src/xt.c b/src/xt.c
index 300416a1e8d92..12b52aa33bc30 100644
--- a/src/xt.c
+++ b/src/xt.c
@@ -115,7 +115,13 @@ void xt_stmt_xlate(const struct stmt *stmt, struct output_ctx *octx)
 	xt_xlate_free(xl);
 	xfree(entry);
 #else
-	nft_print(octx, "# xt_%s", stmt->xt.name);
+	static const char *typename[NFT_XT_MAX] = {
+		[NFT_XT_MATCH]		= "match",
+		[NFT_XT_TARGET]		= "target",
+		[NFT_XT_WATCHER]	= "watcher",
+	};
+
+	nft_print(octx, "xt %s %s", typename[stmt->xt.type], stmt->xt.name);
 #endif
 }
 
-- 
2.38.0

