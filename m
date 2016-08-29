From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/8] src: add quota statement
Date: Mon, 29 Aug 2016 20:21:13 +0200
Message-ID: <1472494879-16442-2-git-send-email-pablo@netfilter.org>
References: <1472494879-16442-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48858 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752993AbcH2SVb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Aug 2016 14:21:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B09811324E3
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2016 20:21:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 99ACF100A66
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2016 20:21:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 49D5F100A66
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2016 20:21:27 +0200 (CEST)
In-Reply-To: <1472494879-16442-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This new statement is stateful, so it can be used from flow tables, eg.

 # nft add rule filter input \
        flow table http { ip saddr timeout 60s quota over 50 mbytes } drop

This basically sets a quota per source IP address of 50 mbytes after
which packets are dropped. Note that the timeout releases the entry if
no traffic is seen from this IP after 60 seconds.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/statement.h          | 10 +++++++++
 src/evaluate.c               |  1 +
 src/netlink_delinearize.c    | 14 ++++++++++++
 src/netlink_linearize.c      | 16 ++++++++++++++
 src/parser_bison.y           | 38 +++++++++++++++++++++++++++-----
 src/scanner.l                |  2 ++
 src/statement.c              | 26 ++++++++++++++++++++++
 tests/py/any/quota.t         | 24 ++++++++++++++++++++
 tests/py/any/quota.t.payload | 52 ++++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 178 insertions(+), 5 deletions(-)
 create mode 100644 tests/py/any/quota.t
 create mode 100644 tests/py/any/quota.t.payload

diff --git a/include/statement.h b/include/statement.h
index 1b21551..e278b70 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -105,6 +105,13 @@ struct queue_stmt {
 
 extern struct stmt *queue_stmt_alloc(const struct location *loc);
 
+struct quota_stmt {
+	uint64_t		bytes;
+	uint32_t		flags;
+};
+
+struct stmt *quota_stmt_alloc(const struct location *loc);
+
 #include <ct.h>
 struct ct_stmt {
 	enum nft_ct_keys		key;
@@ -200,6 +207,7 @@ extern struct stmt *xt_stmt_alloc(const struct location *loc);
  * @STMT_DUP:		dup statement
  * @STMT_FWD:		forward statement
  * @STMT_XT:		XT statement
+ * @STMT_QUOTA:		quota statement
  */
 enum stmt_types {
 	STMT_INVALID,
@@ -221,6 +229,7 @@ enum stmt_types {
 	STMT_DUP,
 	STMT_FWD,
 	STMT_XT,
+	STMT_QUOTA,
 };
 
 /**
@@ -272,6 +281,7 @@ struct stmt {
 		struct masq_stmt	masq;
 		struct redir_stmt	redir;
 		struct queue_stmt	queue;
+		struct quota_stmt	quota;
 		struct ct_stmt		ct;
 		struct set_stmt		set;
 		struct dup_stmt		dup;
diff --git a/src/evaluate.c b/src/evaluate.c
index 2f94ac6..d669b85 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2366,6 +2366,7 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 	switch (stmt->ops->type) {
 	case STMT_COUNTER:
 	case STMT_LIMIT:
+	case STMT_QUOTA:
 		return 0;
 	case STMT_EXPRESSION:
 		return stmt_evaluate_expr(ctx, stmt);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 12d0b4a..e9e0a82 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -620,6 +620,19 @@ static void netlink_parse_limit(struct netlink_parse_ctx *ctx,
 	ctx->stmt = stmt;
 }
 
+static void netlink_parse_quota(struct netlink_parse_ctx *ctx,
+				const struct location *loc,
+				const struct nftnl_expr *nle)
+{
+	struct stmt *stmt;
+
+	stmt = quota_stmt_alloc(loc);
+	stmt->quota.bytes = nftnl_expr_get_u64(nle, NFTNL_EXPR_QUOTA_BYTES);
+	stmt->quota.flags = nftnl_expr_get_u32(nle, NFTNL_EXPR_QUOTA_FLAGS);
+
+	ctx->stmt = stmt;
+}
+
 static void netlink_parse_reject(struct netlink_parse_ctx *ctx,
 				 const struct location *loc,
 				 const struct nftnl_expr *expr)
@@ -989,6 +1002,7 @@ static const struct {
 	{ .name = "fwd",	.parse = netlink_parse_fwd },
 	{ .name = "target",	.parse = netlink_parse_target },
 	{ .name = "match",	.parse = netlink_parse_match },
+	{ .name = "quota",	.parse = netlink_parse_quota },
 };
 
 static int netlink_parse_expr(const struct nftnl_expr *nle,
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index f4db685..a14d0ff 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -657,6 +657,19 @@ netlink_gen_limit_stmt(struct netlink_linearize_ctx *ctx,
 }
 
 static struct nftnl_expr *
+netlink_gen_quota_stmt(struct netlink_linearize_ctx *ctx,
+		       const struct stmt *stmt)
+{
+	struct nftnl_expr *nle;
+
+	nle = alloc_nft_expr("quota");
+	nftnl_expr_set_u64(nle, NFTNL_EXPR_QUOTA_BYTES, stmt->quota.bytes);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_QUOTA_FLAGS, stmt->quota.flags);
+
+	return nle;
+}
+
+static struct nftnl_expr *
 netlink_gen_stmt_stateful(struct netlink_linearize_ctx *ctx,
 			  const struct stmt *stmt)
 {
@@ -665,6 +678,8 @@ netlink_gen_stmt_stateful(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_counter_stmt(ctx, stmt);
 	case STMT_LIMIT:
 		return netlink_gen_limit_stmt(ctx, stmt);
+	case STMT_QUOTA:
+		return netlink_gen_quota_stmt(ctx, stmt);
 	default:
 		BUG("unknown stateful statement type %s\n", stmt->ops->name);
 	}
@@ -1105,6 +1120,7 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_fwd_stmt(ctx, stmt);
 	case STMT_COUNTER:
 	case STMT_LIMIT:
+	case STMT_QUOTA:
 		nle = netlink_gen_stmt_stateful(ctx, stmt);
 		nftnl_rule_add_expr(ctx->nlr, nle);
 		break;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 8c0f625..6b58fe7 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -376,6 +376,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token OVER			"over"
 %token UNTIL			"until"
 
+%token QUOTA			"quota"
+
 %token NANOSECOND		"nanosecond"
 %token MICROSECOND		"microsecond"
 %token MILLISECOND		"millisecond"
@@ -431,8 +433,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { handle_free(&$$); } set_spec set_identifier
 %type <val>			family_spec family_spec_explicit chain_policy prio_spec
 
-%type <string>			dev_spec
-%destructor { xfree($$); }	dev_spec
+%type <string>			dev_spec quota_unit
+%destructor { xfree($$); }	dev_spec quota_unit
 
 %type <table>			table_block_alloc table_block
 %destructor { close_scope(state); table_free($$); }	table_block_alloc
@@ -466,9 +468,9 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <stmt>			log_stmt log_stmt_alloc
 %destructor { stmt_free($$); }	log_stmt log_stmt_alloc
 %type <val>			level_type
-%type <stmt>			limit_stmt
-%destructor { stmt_free($$); }	limit_stmt
-%type <val>			limit_burst limit_mode time_unit
+%type <stmt>			limit_stmt quota_stmt
+%destructor { stmt_free($$); }	limit_stmt quota_stmt
+%type <val>			limit_burst limit_mode time_unit quota_mode
 %type <stmt>			reject_stmt reject_stmt_alloc
 %destructor { stmt_free($$); }	reject_stmt reject_stmt_alloc
 %type <stmt>			nat_stmt nat_stmt_alloc masq_stmt masq_stmt_alloc redir_stmt redir_stmt_alloc
@@ -1373,6 +1375,7 @@ stmt			:	verdict_stmt
 			|	meta_stmt
 			|	log_stmt
 			|	limit_stmt
+			|	quota_stmt
 			|	reject_stmt
 			|	nat_stmt
 			|	queue_stmt
@@ -1542,6 +1545,31 @@ limit_stmt		:	LIMIT	RATE	limit_mode	NUM	SLASH	time_unit	limit_burst
 			}
 			;
 
+quota_mode		:	OVER		{ $$ = NFT_QUOTA_F_INV; }
+			|	UNTIL		{ $$ = 0; }
+			|	/* empty */	{ $$ = 0; }
+			;
+
+quota_unit		:	BYTES		{ $$ = xstrdup("bytes"); }
+			|	STRING		{ $$ = $1; }
+			;
+
+quota_stmt		:	QUOTA	quota_mode NUM quota_unit
+			{
+				struct error_record *erec;
+				uint64_t rate;
+
+				erec = data_unit_parse(&@$, $4, &rate);
+				if (erec != NULL) {
+					erec_queue(erec, state->msgs);
+					YYERROR;
+				}
+				$$ = quota_stmt_alloc(&@$);
+				$$->quota.bytes	= $3 * rate;
+				$$->quota.flags	= $2;
+			}
+			;
+
 limit_mode		:	OVER				{ $$ = NFT_LIMIT_F_INV; }
 			|	UNTIL				{ $$ = 0; }
 			|	/* empty */			{ $$ = 0; }
diff --git a/src/scanner.l b/src/scanner.l
index e9384fd..53b79aa 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -319,6 +319,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "until"			{ return UNTIL; }
 "over"			{ return OVER; }
 
+"quota"			{ return QUOTA; }
+
 "nanosecond"		{ return NANOSECOND; }
 "microsecond"		{ return MICROSECOND; }
 "millisecond"		{ return MILLISECOND; }
diff --git a/src/statement.c b/src/statement.c
index 59b133c..8ccd489 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -325,6 +325,32 @@ struct stmt *queue_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &queue_stmt_ops);
 }
 
+static void quota_stmt_print(const struct stmt *stmt)
+{
+	bool inv = stmt->quota.flags & NFT_QUOTA_F_INV;
+	const char *data_unit;
+	uint64_t bytes;
+
+	data_unit = get_rate(stmt->quota.bytes, &bytes);
+	printf("quota %s%"PRIu64" %s",
+	       inv ? "over " : "", bytes, data_unit);
+}
+
+static const struct stmt_ops quota_stmt_ops = {
+	.type		= STMT_QUOTA,
+	.name		= "quota",
+	.print		= quota_stmt_print,
+};
+
+struct stmt *quota_stmt_alloc(const struct location *loc)
+{
+	struct stmt *stmt;
+
+	stmt = stmt_alloc(loc, &quota_stmt_ops);
+	stmt->flags |= STMT_F_STATEFUL;
+	return stmt;
+}
+
 static void reject_stmt_print(const struct stmt *stmt)
 {
 	printf("reject");
diff --git a/tests/py/any/quota.t b/tests/py/any/quota.t
new file mode 100644
index 0000000..9a8db11
--- /dev/null
+++ b/tests/py/any/quota.t
@@ -0,0 +1,24 @@
+:output;type filter hook output priority 0
+:ingress;type filter hook ingress device lo priority 0
+
+*ip;test-ip4;output
+*ip6;test-ip6;output
+*inet;test-inet;output
+*arp;test-arp;output
+*bridge;test-bridge;output
+*netdev;test-netdev;ingress
+
+quota 1025 bytes;ok
+quota 1 kbytes;ok
+quota 2 kbytes;ok
+quota 1025 kbytes;ok
+quota 1023 mbytes;ok
+quota 10230 mbytes;ok
+quota 1023000 mbytes;ok
+
+quota over 1 kbytes;ok
+quota over 2 kbytes;ok
+quota over 1025 kbytes;ok
+quota over 1023 mbytes;ok
+quota over 10230 mbytes;ok
+quota over 1023000 mbytes;ok
diff --git a/tests/py/any/quota.t.payload b/tests/py/any/quota.t.payload
new file mode 100644
index 0000000..519db2c
--- /dev/null
+++ b/tests/py/any/quota.t.payload
@@ -0,0 +1,52 @@
+# quota 1025 bytes
+ip test-ip4 output 
+  [ quota bytes 1025 flags 0 ]
+
+# quota 1 kbytes
+ip test-ip4 output 
+  [ quota bytes 1024 flags 0 ]
+
+# quota 2 kbytes
+ip test-ip4 output 
+  [ quota bytes 2048 flags 0 ]
+
+# quota 1025 kbytes
+ip test-ip4 output 
+  [ quota bytes 1049600 flags 0 ]
+
+# quota 1023 mbytes
+ip test-ip4 output 
+  [ quota bytes 1072693248 flags 0 ]
+
+# quota 10230 mbytes
+ip test-ip4 output 
+  [ quota bytes 10726932480 flags 0 ]
+
+# quota 1023000 mbytes
+ip test-ip4 output 
+  [ quota bytes 1072693248000 flags 0 ]
+
+# quota over 1 kbytes
+ip test-ip4 output 
+  [ quota bytes 1024 flags 1 ]
+
+# quota over 2 kbytes
+ip test-ip4 output 
+  [ quota bytes 2048 flags 1 ]
+
+# quota over 1025 kbytes
+ip test-ip4 output 
+  [ quota bytes 1049600 flags 1 ]
+
+# quota over 1023 mbytes
+ip test-ip4 output 
+  [ quota bytes 1072693248 flags 1 ]
+
+# quota over 10230 mbytes
+ip test-ip4 output 
+  [ quota bytes 10726932480 flags 1 ]
+
+# quota over 1023000 mbytes
+ip test-ip4 output 
+  [ quota bytes 1072693248000 flags 1 ]
+
-- 
2.1.4

