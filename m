From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/3] src: add per-bytes limit
Date: Tue, 22 Sep 2015 13:02:18 +0200
Message-ID: <1442919740-12888-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45358 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756870AbbIVKzm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Sep 2015 06:55:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This example show how to accept packets below the ratelimit:

... limit rate 1024 mbytes/second counter accept

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/datatype.h                  |    4 +++
 include/linux/netfilter/nf_tables.h |    9 ++++++
 include/statement.h                 |    1 +
 src/datatype.c                      |   55 +++++++++++++++++++++++++++++++++++
 src/netlink_delinearize.c           |    1 +
 src/netlink_linearize.c             |    1 +
 src/parser_bison.y                  |   17 +++++++++++
 src/statement.c                     |   43 +++++++++++++++++++++++++--
 8 files changed, 129 insertions(+), 2 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 2a6a4fc..ebafa65 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -235,4 +235,8 @@ extern void time_print(uint64_t seconds);
 extern struct error_record *time_parse(const struct location *loc,
 				       const char *c, uint64_t *res);
 
+extern struct error_record *rate_parse(const struct location *loc,
+				       const char *str, uint64_t *rate,
+				       uint64_t *unit);
+
 #endif /* NFTABLES_DATATYPE_H */
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 33056dc..db0457d 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -747,16 +747,25 @@ enum nft_ct_attributes {
 };
 #define NFTA_CT_MAX		(__NFTA_CT_MAX - 1)
 
+enum nft_limit_type {
+	NFT_LIMIT_PKTS,
+	NFT_LIMIT_PKT_BYTES
+};
+
 /**
  * enum nft_limit_attributes - nf_tables limit expression netlink attributes
  *
  * @NFTA_LIMIT_RATE: refill rate (NLA_U64)
  * @NFTA_LIMIT_UNIT: refill unit (NLA_U64)
+ * @NFTA_LIMIT_BURST: burst (NLA_U32)
+ * @NFTA_LIMIT_TYPE: type of limit (NLA_U32: enum nft_limit_type)
  */
 enum nft_limit_attributes {
 	NFTA_LIMIT_UNSPEC,
 	NFTA_LIMIT_RATE,
 	NFTA_LIMIT_UNIT,
+	NFTA_LIMIT_BURST,
+	NFTA_LIMIT_TYPE,
 	__NFTA_LIMIT_MAX
 };
 #define NFTA_LIMIT_MAX		(__NFTA_LIMIT_MAX - 1)
diff --git a/include/statement.h b/include/statement.h
index 48e6130..d2d0852 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -51,6 +51,7 @@ extern struct stmt *log_stmt_alloc(const struct location *loc);
 struct limit_stmt {
 	uint64_t		rate;
 	uint64_t		unit;
+	enum nft_limit_type	type;
 };
 
 extern struct stmt *limit_stmt_alloc(const struct location *loc);
diff --git a/src/datatype.c b/src/datatype.c
index f79f5d2..e5a486f 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -976,3 +976,58 @@ void concat_type_destroy(const struct datatype *dtype)
 		xfree(dtype);
 	}
 }
+
+static struct error_record *time_unit_parse(const struct location *loc,
+					    const char *str, uint64_t *unit)
+{
+	if (strcmp(str, "second") == 0)
+		*unit = 1ULL;
+	else if (strcmp(str, "minute") == 0)
+		*unit = 1ULL * 60;
+	else if (strcmp(str, "hour") == 0)
+		*unit = 1ULL * 60 * 60;
+	else if (strcmp(str, "day") == 0)
+		*unit = 1ULL * 60 * 60 * 24;
+	else if (strcmp(str, "week") == 0)
+		*unit = 1ULL * 60 * 60 * 24 * 7;
+	else
+		return error(loc, "Wrong rate format");
+
+	return NULL;
+}
+
+static struct error_record *data_unit_parse(const struct location *loc,
+					    const char *str, uint64_t *rate)
+{
+	if (strncmp(str, "bytes", strlen("bytes")) == 0)
+		*rate = 1ULL;
+	else if (strncmp(str, "kbytes", strlen("kbytes")) == 0)
+		*rate = 1024;
+	else if (strncmp(str, "mbytes", strlen("mbytes")) == 0)
+		*rate = 1024 * 1024;
+	else
+		return error(loc, "Wrong rate format");
+
+	return NULL;
+}
+
+struct error_record *rate_parse(const struct location *loc, const char *str,
+				uint64_t *rate, uint64_t *unit)
+{
+	struct error_record *erec;
+	const char *slash;
+
+	slash = strchr(str, '/');
+	if (!slash)
+		return error(loc, "wrong rate format");
+
+	erec = data_unit_parse(loc, str, rate);
+	if (erec != NULL)
+		return erec;
+
+	erec = time_unit_parse(loc, slash + 1, unit);
+	if (erec != NULL)
+		return erec;
+
+	return NULL;
+}
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 787eec7..569763b 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -583,6 +583,7 @@ static void netlink_parse_limit(struct netlink_parse_ctx *ctx,
 	stmt = limit_stmt_alloc(loc);
 	stmt->limit.rate = nftnl_expr_get_u64(nle, NFTNL_EXPR_LIMIT_RATE);
 	stmt->limit.unit = nftnl_expr_get_u64(nle, NFTNL_EXPR_LIMIT_UNIT);
+	stmt->limit.type = nftnl_expr_get_u32(nle, NFTNL_EXPR_LIMIT_TYPE);
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
 
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 707df49..cebd2f1 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -656,6 +656,7 @@ static void netlink_gen_limit_stmt(struct netlink_linearize_ctx *ctx,
 	nle = alloc_nft_expr("limit");
 	nftnl_expr_set_u64(nle, NFTNL_EXPR_LIMIT_RATE, stmt->limit.rate);
 	nftnl_expr_set_u64(nle, NFTNL_EXPR_LIMIT_UNIT, stmt->limit.unit);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_LIMIT_TYPE, stmt->limit.type);
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index cfb6b70..ec44a2c 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1446,6 +1446,23 @@ limit_stmt		:	LIMIT	RATE	NUM	SLASH	time_unit
 				$$ = limit_stmt_alloc(&@$);
 				$$->limit.rate	= $3;
 				$$->limit.unit	= $5;
+				$$->limit.type	= NFT_LIMIT_PKTS;
+			}
+			|	LIMIT RATE	NUM	STRING
+			{
+				struct error_record *erec;
+				uint64_t rate, unit;
+
+				erec = rate_parse(&@$, $4, &rate, &unit);
+				if (erec != NULL) {
+					erec_queue(erec, state->msgs);
+					YYERROR;
+				}
+
+				$$ = limit_stmt_alloc(&@$);
+				$$->limit.rate	= rate * $3;
+				$$->limit.unit	= unit;
+				$$->limit.type	= NFT_LIMIT_PKT_BYTES;
 			}
 			;
 
diff --git a/src/statement.c b/src/statement.c
index 9ebc593..ba7b8be 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -185,10 +185,49 @@ static const char *get_unit(uint64_t u)
 	return "error";
 }
 
+static const char *data_unit[] = {
+	"bytes",
+	"kbytes",
+	"mbytes",
+	NULL
+};
+
+static const char *get_rate(uint64_t byte_rate, uint64_t *rate)
+{
+	uint64_t res, prev, rest;
+	int i;
+
+	res = prev = byte_rate;
+	for (i = 0;; i++) {
+		rest = res % 1024;
+		res /= 1024;
+		if (res <= 1 && rest != 0)
+			break;
+		if (data_unit[i + 1] == NULL)
+			break;
+		prev = res;
+	}
+	*rate = prev;
+	return data_unit[i];
+}
+
 static void limit_stmt_print(const struct stmt *stmt)
 {
-	printf("limit rate %" PRIu64 "/%s",
-	       stmt->limit.rate, get_unit(stmt->limit.unit));
+	const char *data_unit;
+	uint64_t rate;
+
+	switch (stmt->limit.type) {
+	case NFT_LIMIT_PKTS:
+		printf("limit rate %" PRIu64 "/%s",
+		       stmt->limit.rate, get_unit(stmt->limit.unit));
+		break;
+	case NFT_LIMIT_PKT_BYTES:
+		data_unit = get_rate(stmt->limit.rate, &rate);
+
+		printf("limit rate %" PRIu64 " %s/%s",
+		       rate, data_unit, get_unit(stmt->limit.unit));
+		break;
+	}
 }
 
 static const struct stmt_ops limit_stmt_ops = {
-- 
1.7.10.4

