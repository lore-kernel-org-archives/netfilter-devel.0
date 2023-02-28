Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3A14C64ED6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Feb 2023 15:35:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjB1Pf4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Feb 2023 10:35:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbjB1Pf4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Feb 2023 10:35:56 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 73BF31730
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2023 07:35:54 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2] src: add last statement
Date:   Tue, 28 Feb 2023 16:35:51 +0100
Message-Id: <20230228153551.273448-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This new statement allows you to know how long ago there was a matching
packet.

 # nft list ruleset
 table ip x {
        chain y {
		[...]
                ip protocol icmp last used 49m54s884ms counter packets 1 bytes 64
	}
 }

if the statement never sees a packet, then the listing says:

                ip protocol icmp last used never counter packets 0 bytes 0

Add tests/py in this patch too.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: never merged upstream for some reason, rebasing.

 include/parser.h            |  1 +
 include/statement.h         | 10 ++++++++++
 src/evaluate.c              |  1 +
 src/netlink_delinearize.c   | 14 ++++++++++++++
 src/netlink_linearize.c     | 14 ++++++++++++++
 src/parser_bison.y          | 27 +++++++++++++++++++++++++--
 src/scanner.l               |  9 ++++++++-
 src/statement.c             | 30 ++++++++++++++++++++++++++++++
 tests/py/any/last.t         | 13 +++++++++++++
 tests/py/any/last.t.payload |  8 ++++++++
 10 files changed, 124 insertions(+), 3 deletions(-)
 create mode 100644 tests/py/any/last.t
 create mode 100644 tests/py/any/last.t.payload

diff --git a/include/parser.h b/include/parser.h
index 71df43093204..f79a22f306af 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -42,6 +42,7 @@ enum startcond_type {
 	PARSER_SC_IGMP,
 	PARSER_SC_IP,
 	PARSER_SC_IP6,
+	PARSER_SC_LAST,
 	PARSER_SC_LIMIT,
 	PARSER_SC_META,
 	PARSER_SC_POLICY,
diff --git a/include/statement.h b/include/statement.h
index e648fb137b74..720a6ac2c754 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -47,6 +47,13 @@ struct counter_stmt {
 
 extern struct stmt *counter_stmt_alloc(const struct location *loc);
 
+struct last_stmt {
+	uint64_t		used;
+	uint32_t		set;
+};
+
+extern struct stmt *last_stmt_alloc(const struct location *loc);
+
 struct exthdr_stmt {
 	struct expr			*expr;
 	struct expr			*val;
@@ -303,6 +310,7 @@ extern struct stmt *xt_stmt_alloc(const struct location *loc);
  * @STMT_SYNPROXY:	synproxy statement
  * @STMT_CHAIN:		chain statement
  * @STMT_OPTSTRIP:	optstrip statement
+ * @STMT_LAST:		last statement
  */
 enum stmt_types {
 	STMT_INVALID,
@@ -333,6 +341,7 @@ enum stmt_types {
 	STMT_SYNPROXY,
 	STMT_CHAIN,
 	STMT_OPTSTRIP,
+	STMT_LAST,
 };
 
 /**
@@ -382,6 +391,7 @@ struct stmt {
 		struct counter_stmt	counter;
 		struct payload_stmt	payload;
 		struct meta_stmt	meta;
+		struct last_stmt	last;
 		struct log_stmt		log;
 		struct limit_stmt	limit;
 		struct reject_stmt	reject;
diff --git a/src/evaluate.c b/src/evaluate.c
index 19faf621bf65..47caf3b0d716 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4280,6 +4280,7 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 	switch (stmt->ops->type) {
 	case STMT_CONNLIMIT:
 	case STMT_COUNTER:
+	case STMT_LAST:
 	case STMT_LIMIT:
 	case STMT_QUOTA:
 	case STMT_NOTRACK:
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 00221505f289..60350cd6cd96 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1067,6 +1067,19 @@ static void netlink_parse_counter(struct netlink_parse_ctx *ctx,
 	ctx->stmt = stmt;
 }
 
+static void netlink_parse_last(struct netlink_parse_ctx *ctx,
+			       const struct location *loc,
+			       const struct nftnl_expr *nle)
+{
+	struct stmt *stmt;
+
+	stmt = last_stmt_alloc(loc);
+	stmt->last.used = nftnl_expr_get_u64(nle, NFTNL_EXPR_LAST_MSECS);
+	stmt->last.set = nftnl_expr_get_u32(nle, NFTNL_EXPR_LAST_SET);
+
+	ctx->stmt = stmt;
+}
+
 static void netlink_parse_log(struct netlink_parse_ctx *ctx,
 			      const struct location *loc,
 			      const struct nftnl_expr *nle)
@@ -1877,6 +1890,7 @@ static const struct expr_handler netlink_parsers[] = {
 	{ .name = "ct",		.parse = netlink_parse_ct },
 	{ .name = "connlimit",	.parse = netlink_parse_connlimit },
 	{ .name = "counter",	.parse = netlink_parse_counter },
+	{ .name = "last",	.parse = netlink_parse_last },
 	{ .name = "log",	.parse = netlink_parse_log },
 	{ .name = "limit",	.parse = netlink_parse_limit },
 	{ .name = "range",	.parse = netlink_parse_range },
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 3da72f50d5a6..11cf48a3f9d0 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1001,6 +1001,17 @@ static struct nftnl_expr *netlink_gen_quota_stmt(const struct stmt *stmt)
 	return nle;
 }
 
+static struct nftnl_expr *netlink_gen_last_stmt(const struct stmt *stmt)
+{
+	struct nftnl_expr *nle;
+
+	nle = alloc_nft_expr("last");
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_LAST_SET, stmt->last.set);
+	nftnl_expr_set_u64(nle, NFTNL_EXPR_LAST_MSECS, stmt->last.used);
+
+	return nle;
+}
+
 struct nftnl_expr *netlink_gen_stmt_stateful(const struct stmt *stmt)
 {
 	switch (stmt->ops->type) {
@@ -1012,6 +1023,8 @@ struct nftnl_expr *netlink_gen_stmt_stateful(const struct stmt *stmt)
 		return netlink_gen_limit_stmt(stmt);
 	case STMT_QUOTA:
 		return netlink_gen_quota_stmt(stmt);
+	case STMT_LAST:
+		return netlink_gen_last_stmt(stmt);
 	default:
 		BUG("unknown stateful statement type %s\n", stmt->ops->name);
 	}
@@ -1687,6 +1700,7 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 	case STMT_COUNTER:
 	case STMT_LIMIT:
 	case STMT_QUOTA:
+	case STMT_LAST:
 		nle = netlink_gen_stmt_stateful(stmt);
 		nft_rule_add_expr(ctx, nle, &stmt->location);
 		break;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 824e5db8ad90..5ad191404339 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -554,6 +554,9 @@ int nft_lex(void *, void *, void *);
 %token BYTES			"bytes"
 %token AVGPKT			"avgpkt"
 
+%token LAST			"last"
+%token NEVER			"never"
+
 %token COUNTERS			"counters"
 %token QUOTAS			"quotas"
 %token LIMITS			"limits"
@@ -710,8 +713,8 @@ int nft_lex(void *, void *, void *);
 %destructor { stmt_list_free($$); xfree($$); } stmt_list stateful_stmt_list set_elem_stmt_list
 %type <stmt>			stmt match_stmt verdict_stmt set_elem_stmt
 %destructor { stmt_free($$); }	stmt match_stmt verdict_stmt set_elem_stmt
-%type <stmt>			counter_stmt counter_stmt_alloc stateful_stmt
-%destructor { stmt_free($$); }	counter_stmt counter_stmt_alloc stateful_stmt
+%type <stmt>			counter_stmt counter_stmt_alloc stateful_stmt last_stmt
+%destructor { stmt_free($$); }	counter_stmt counter_stmt_alloc stateful_stmt last_stmt
 %type <stmt>			payload_stmt
 %destructor { stmt_free($$); }	payload_stmt
 %type <stmt>			ct_stmt
@@ -968,6 +971,7 @@ close_scope_at		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_AT); };
 close_scope_comp	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_COMP); };
 close_scope_ct		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CT); };
 close_scope_counter	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_COUNTER); };
+close_scope_last	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_LAST); };
 close_scope_dccp	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_DCCP); };
 close_scope_destroy	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CMD_DESTROY); };
 close_scope_dst		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_DST); };
@@ -2686,6 +2690,7 @@ chain_policy		:	ACCEPT		{ $$ = NF_ACCEPT; }
 			;
 
 identifier		:	STRING
+			|	LAST		{ $$ = xstrdup("last"); }
 			;
 
 string			:	STRING
@@ -2966,6 +2971,7 @@ stateful_stmt		:	counter_stmt	close_scope_counter
 			|	limit_stmt
 			|	quota_stmt
 			|	connlimit_stmt
+			|	last_stmt	close_scope_last
 			;
 
 stmt			:	verdict_stmt
@@ -3104,6 +3110,22 @@ counter_arg		:	PACKETS			NUM
 			}
 			;
 
+last_stmt		:	LAST
+			{
+				$$ = last_stmt_alloc(&@$);
+			}
+			|	LAST USED	NEVER
+			{
+				$$ = last_stmt_alloc(&@$);
+			}
+			|	LAST USED	time_spec
+			{
+				$$ = last_stmt_alloc(&@$);
+				$$->last.used = $3;
+				$$->last.set = true;
+			}
+			;
+
 log_stmt		:	log_stmt_alloc
 			|	log_stmt_alloc		log_args
 			;
@@ -4917,6 +4939,7 @@ keyword_expr		:	ETHER   close_scope_eth { $$ = symbol_value(&@$, "ether"); }
 			|	ORIGINAL		{ $$ = symbol_value(&@$, "original"); }
 			|	REPLY			{ $$ = symbol_value(&@$, "reply"); }
 			|	LABEL			{ $$ = symbol_value(&@$, "label"); }
+			|	LAST	close_scope_last	{ $$ = symbol_value(&@$, "last"); }
 			;
 
 primary_rhs_expr	:	symbol_expr		{ $$ = $1; }
diff --git a/src/scanner.l b/src/scanner.l
index bc5b5b62b9ce..15ca3d461d70 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -206,6 +206,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_IGMP
 %s SCANSTATE_IP
 %s SCANSTATE_IP6
+%s SCANSTATE_LAST
 %s SCANSTATE_LIMIT
 %s SCANSTATE_META
 %s SCANSTATE_POLICY
@@ -402,6 +403,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 <SCANSTATE_COUNTER,SCANSTATE_CT,SCANSTATE_LIMIT>"packets"		{ return PACKETS; }
 <SCANSTATE_COUNTER,SCANSTATE_CT,SCANSTATE_LIMIT,SCANSTATE_QUOTA>"bytes"	{ return BYTES; }
 
+"last"				{ scanner_push_start_cond(yyscanner, SCANSTATE_LAST); return LAST; }
+<SCANSTATE_LAST>{
+	"never"			{ return NEVER; }
+}
+
 <SCANSTATE_CMD_LIST,SCANSTATE_CMD_RESET>{
 	"counters"		{ return COUNTERS; }
 	"quotas"		{ return QUOTAS; }
@@ -437,10 +443,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "quota"			{ scanner_push_start_cond(yyscanner, SCANSTATE_QUOTA); return QUOTA; }
 <SCANSTATE_QUOTA>{
-	"used"		{ return USED; }
 	"until"		{ return UNTIL; }
 }
 
+<SCANSTATE_QUOTA,SCANSTATE_LAST>"used"		{ return USED; }
+
 "hour"			{ return HOUR; }
 "day"			{ return DAY; }
 
diff --git a/src/statement.c b/src/statement.c
index eafc51c484de..72455522c2c9 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -249,6 +249,36 @@ struct stmt *counter_stmt_alloc(const struct location *loc)
 	return stmt;
 }
 
+static void last_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
+{
+	nft_print(octx, "last");
+
+	if (nft_output_stateless(octx))
+		return;
+
+	nft_print(octx, " used ");
+
+	if (stmt->last.set)
+		time_print(stmt->last.used, octx);
+	else
+		nft_print(octx, "never");
+}
+
+static const struct stmt_ops last_stmt_ops = {
+	.type		= STMT_LAST,
+	.name		= "last",
+	.print		= last_stmt_print,
+};
+
+struct stmt *last_stmt_alloc(const struct location *loc)
+{
+	struct stmt *stmt;
+
+	stmt = stmt_alloc(loc, &last_stmt_ops);
+	stmt->flags |= STMT_F_STATEFUL;
+	return stmt;
+}
+
 static const char *objref_type[NFT_OBJECT_MAX + 1] = {
 	[NFT_OBJECT_COUNTER]	= "counter",
 	[NFT_OBJECT_QUOTA]	= "quota",
diff --git a/tests/py/any/last.t b/tests/py/any/last.t
new file mode 100644
index 000000000000..5c530461479f
--- /dev/null
+++ b/tests/py/any/last.t
@@ -0,0 +1,13 @@
+:input;type filter hook input priority 0
+:ingress;type filter hook ingress device lo priority 0
+
+*ip;test-ip4;input
+*ip6;test-ip6;input
+*inet;test-inet;input
+*arp;test-arp;input
+*bridge;test-bridge;input
+*netdev;test-netdev;ingress
+
+last;ok
+last used 300s;ok;last
+last used foo;fail
diff --git a/tests/py/any/last.t.payload b/tests/py/any/last.t.payload
new file mode 100644
index 000000000000..ed47d0f355eb
--- /dev/null
+++ b/tests/py/any/last.t.payload
@@ -0,0 +1,8 @@
+# last
+ip
+  [ last never ]
+
+# last used 300s
+ip
+  [ last 300000 ]
+
-- 
2.30.2

