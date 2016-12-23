From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 03/10] src: add used quota support
Date: Fri, 23 Dec 2016 15:26:48 +0100
Message-ID: <1482503215-25422-3-git-send-email-pablo@netfilter.org>
References: <1482503215-25422-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40162 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941149AbcLWO1O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Dec 2016 09:27:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5D09F2519A2
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:27:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4F0AE8E672
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:27:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 221F18E661
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:27:09 +0100 (CET)
In-Reply-To: <1482503215-25422-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

table ip x {
        chain y {
                type filter hook forward priority 0; policy accept;
                quota over 200 mbytes used 1143 kbytes drop
        }
}

This patch allows us to list and to restore used quota.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/statement.h       |  1 +
 src/netlink_delinearize.c |  2 ++
 src/netlink_linearize.c   |  1 +
 src/parser_bison.y        | 21 +++++++++++++++++++--
 src/scanner.l             |  1 +
 src/statement.c           |  7 ++++++-
 6 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/include/statement.h b/include/statement.h
index 277ff2f47c7f..d317ae368164 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -108,6 +108,7 @@ extern struct stmt *queue_stmt_alloc(const struct location *loc);
 
 struct quota_stmt {
 	uint64_t		bytes;
+	uint64_t		used;
 	uint32_t		flags;
 };
 
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index cb0f6ac7b1a2..9a16926e3817 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -777,6 +777,8 @@ static void netlink_parse_quota(struct netlink_parse_ctx *ctx,
 
 	stmt = quota_stmt_alloc(loc);
 	stmt->quota.bytes = nftnl_expr_get_u64(nle, NFTNL_EXPR_QUOTA_BYTES);
+	stmt->quota.used =
+		nftnl_expr_get_u64(nle, NFTNL_EXPR_QUOTA_CONSUMED);
 	stmt->quota.flags = nftnl_expr_get_u32(nle, NFTNL_EXPR_QUOTA_FLAGS);
 
 	ctx->stmt = stmt;
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 0915038fecae..144068d23378 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -734,6 +734,7 @@ netlink_gen_quota_stmt(struct netlink_linearize_ctx *ctx,
 
 	nle = alloc_nft_expr("quota");
 	nftnl_expr_set_u64(nle, NFTNL_EXPR_QUOTA_BYTES, stmt->quota.bytes);
+	nftnl_expr_set_u64(nle, NFTNL_EXPR_QUOTA_CONSUMED, stmt->quota.used);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_QUOTA_FLAGS, stmt->quota.flags);
 
 	return nle;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 0f3ad915b701..aea6e47d8b12 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -378,6 +378,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token UNTIL			"until"
 
 %token QUOTA			"quota"
+%token USED			"used"
 
 %token NANOSECOND		"nanosecond"
 %token MICROSECOND		"microsecond"
@@ -427,7 +428,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <string>			identifier type_identifier string comment_spec
 %destructor { xfree($$); }	identifier type_identifier string comment_spec
 
-%type <val>			time_spec
+%type <val>			time_spec quota_used
 
 %type <val>			type_identifier_list
 %type <datatype>		data_type
@@ -1636,7 +1637,22 @@ quota_unit		:	BYTES		{ $$ = xstrdup("bytes"); }
 			|	STRING		{ $$ = $1; }
 			;
 
-quota_stmt		:	QUOTA	quota_mode NUM quota_unit
+quota_used		:	/* empty */	{ $$ = 0; }
+			|	USED NUM quota_unit
+			{
+				struct error_record *erec;
+				uint64_t rate;
+
+				erec = data_unit_parse(&@$, $3, &rate);
+				if (erec != NULL) {
+					erec_queue(erec, state->msgs);
+					YYERROR;
+				}
+				$$ = $2 * rate;
+			}
+			;
+
+quota_stmt		:	QUOTA	quota_mode NUM quota_unit quota_used
 			{
 				struct error_record *erec;
 				uint64_t rate;
@@ -1648,6 +1664,7 @@ quota_stmt		:	QUOTA	quota_mode NUM quota_unit
 				}
 				$$ = quota_stmt_alloc(&@$);
 				$$->quota.bytes	= $3 * rate;
+				$$->quota.used = $5;
 				$$->quota.flags	= $2;
 			}
 			;
diff --git a/src/scanner.l b/src/scanner.l
index 625023f5257c..8aa4b08ba8fc 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -312,6 +312,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "over"			{ return OVER; }
 
 "quota"			{ return QUOTA; }
+"used"			{ return USED; }
 
 "nanosecond"		{ return NANOSECOND; }
 "microsecond"		{ return MICROSECOND; }
diff --git a/src/statement.c b/src/statement.c
index e70eb51ec859..4d3ca55a4081 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -352,11 +352,16 @@ static void quota_stmt_print(const struct stmt *stmt)
 {
 	bool inv = stmt->quota.flags & NFT_QUOTA_F_INV;
 	const char *data_unit;
-	uint64_t bytes;
+	uint64_t bytes, used;
 
 	data_unit = get_rate(stmt->quota.bytes, &bytes);
 	printf("quota %s%"PRIu64" %s",
 	       inv ? "over " : "", bytes, data_unit);
+
+	if (stmt->quota.used) {
+		data_unit = get_rate(stmt->quota.used, &used);
+		printf(" used %"PRIu64" %s", used, data_unit);
+	}
 }
 
 static const struct stmt_ops quota_stmt_ops = {
-- 
2.1.4

