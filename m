From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] nftables: operational limit match
Date: Sat, 5 Oct 2013 09:44:56 -0700
Message-ID: <20131005164456.GB16881@home>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="OwLcNYc0lM97+oe1"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:43493 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab3JEQo7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Oct 2013 12:44:59 -0400
Received: by mail-pd0-f174.google.com with SMTP id y13so5314797pdi.19
        for <netfilter-devel@vger.kernel.org>; Sat, 05 Oct 2013 09:44:59 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--OwLcNYc0lM97+oe1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The nft limit match currently does not work at all.  Below patches to nftables,
libnftables, and kernel address the issue.  A few notes on the implementation:

- Removed support for nano/micro/milli second limits.  These seem pointless,
  given we are using jiffies in the limit match, not a hpet.  And who really
  needs to limit items down to sub-second level??

- 'depth' member is removed as unnecessary.  All we need in the kernel is the
  rate and the unit.  

- 'stamp' member becomes the time we need to next refresh the token bucket,
  instead of being updated on every packet which goes through the match.

This closes netfilter bugzilla #827, reported by Eric Leblond.

Signed-off-by: Phil Oester <kernel@linuxace.com>


--OwLcNYc0lM97+oe1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-nft-limit-kernel

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index b8cd62f..a652136 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -538,12 +538,12 @@ enum nft_ct_attributes {
  * enum nft_limit_attributes - nf_tables limit expression netlink attributes
  *
  * @NFTA_LIMIT_RATE: refill rate (NLA_U64)
- * @NFTA_LIMIT_DEPTH: bucket depth (NLA_U64)
+ * @NFTA_LIMIT_UNIT: refill unit (NLA_U64)
  */
 enum nft_limit_attributes {
 	NFTA_LIMIT_UNSPEC,
 	NFTA_LIMIT_RATE,
-	NFTA_LIMIT_DEPTH,
+	NFTA_LIMIT_UNIT,
 	__NFTA_LIMIT_MAX
 };
 #define NFTA_LIMIT_MAX		(__NFTA_LIMIT_MAX - 1)
diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index a40ccc0..85da5bd 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -21,8 +21,8 @@ static DEFINE_SPINLOCK(limit_lock);
 
 struct nft_limit {
 	u64		tokens;
-	u64		depth;
 	u64		rate;
+	u64		unit;
 	unsigned long	stamp;
 };
 
@@ -33,11 +33,9 @@ static void nft_limit_eval(const struct nft_expr *expr,
 	struct nft_limit *priv = nft_expr_priv(expr);
 
 	spin_lock_bh(&limit_lock);
-	if (priv->stamp != jiffies) {
-		priv->tokens += priv->rate * (jiffies - priv->stamp);
-		if (priv->tokens > priv->depth)
-			priv->tokens = priv->depth;
-		priv->stamp = jiffies;
+	if (time_after_eq(jiffies, priv->stamp)) {
+		priv->tokens = priv->rate;
+		priv->stamp = jiffies + priv->unit * HZ;
 	}
 
 	if (priv->tokens >= 1) {
@@ -52,7 +50,7 @@ static void nft_limit_eval(const struct nft_expr *expr,
 
 static const struct nla_policy nft_limit_policy[NFTA_LIMIT_MAX + 1] = {
 	[NFTA_LIMIT_RATE]	= { .type = NLA_U64 },
-	[NFTA_LIMIT_DEPTH]	= { .type = NLA_U64 },
+	[NFTA_LIMIT_UNIT]	= { .type = NLA_U64 },
 };
 
 static int nft_limit_init(const struct nft_ctx *ctx,
@@ -62,12 +60,13 @@ static int nft_limit_init(const struct nft_ctx *ctx,
 	struct nft_limit *priv = nft_expr_priv(expr);
 
 	if (tb[NFTA_LIMIT_RATE] == NULL ||
-	    tb[NFTA_LIMIT_DEPTH] == NULL)
+	    tb[NFTA_LIMIT_UNIT] == NULL)
 		return -EINVAL;
 
 	priv->rate   = be64_to_cpu(nla_get_be64(tb[NFTA_LIMIT_RATE]));
-	priv->depth  = be64_to_cpu(nla_get_be64(tb[NFTA_LIMIT_DEPTH]));
-	priv->tokens = priv->depth;
+	priv->unit   = be64_to_cpu(nla_get_be64(tb[NFTA_LIMIT_UNIT]));
+	priv->stamp  = jiffies + priv->unit * HZ;
+	priv->tokens = priv->rate;
 	return 0;
 }
 
@@ -77,7 +76,7 @@ static int nft_limit_dump(struct sk_buff *skb, const struct nft_expr *expr)
 
 	if (nla_put_be64(skb, NFTA_LIMIT_RATE, cpu_to_be64(priv->rate)))
 		goto nla_put_failure;
-	if (nla_put_be64(skb, NFTA_LIMIT_DEPTH, cpu_to_be64(priv->depth)))
+	if (nla_put_be64(skb, NFTA_LIMIT_UNIT, cpu_to_be64(priv->unit)))
 		goto nla_put_failure;
 	return 0;
 

--OwLcNYc0lM97+oe1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-nft-limit-libnftables

diff --git a/include/libnftables/expr.h b/include/libnftables/expr.h
index b8f1d1e..232a810 100644
--- a/include/libnftables/expr.h
+++ b/include/libnftables/expr.h
@@ -134,7 +134,7 @@ enum {
 
 enum {
 	NFT_EXPR_LIMIT_RATE	= NFT_RULE_EXPR_ATTR_BASE,
-	NFT_EXPR_LIMIT_DEPTH,
+	NFT_EXPR_LIMIT_UNIT,
 };
 
 #ifdef __cplusplus
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index b690282..4ec8187 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -537,12 +537,12 @@ enum nft_ct_attributes {
  * enum nft_limit_attributes - nf_tables limit expression netlink attributes
  *
  * @NFTA_LIMIT_RATE: refill rate (NLA_U64)
- * @NFTA_LIMIT_DEPTH: bucket depth (NLA_U64)
+ * @NFTA_LIMIT_UNIT: refill unit (NLA_U64)
  */
 enum nft_limit_attributes {
 	NFTA_LIMIT_UNSPEC,
 	NFTA_LIMIT_RATE,
-	NFTA_LIMIT_DEPTH,
+	NFTA_LIMIT_UNIT,
 	__NFTA_LIMIT_MAX
 };
 #define NFTA_LIMIT_MAX		(__NFTA_LIMIT_MAX - 1)
diff --git a/src/expr/limit.c b/src/expr/limit.c
index 6954014..8c9d2ae 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -25,7 +25,7 @@
 
 struct nft_expr_limit {
 	uint64_t		rate;
-	uint64_t		depth;
+	uint64_t		unit;
 };
 
 static int
@@ -38,8 +38,8 @@ nft_rule_expr_limit_set(struct nft_rule_expr *e, uint16_t type,
 	case NFT_EXPR_LIMIT_RATE:
 		limit->rate = *((uint64_t *)data);
 		break;
-	case NFT_EXPR_LIMIT_DEPTH:
-		limit->depth = *((uint64_t *)data);
+	case NFT_EXPR_LIMIT_UNIT:
+		limit->unit = *((uint64_t *)data);
 		break;
 	default:
 		return -1;
@@ -57,9 +57,9 @@ nft_rule_expr_limit_get(const struct nft_rule_expr *e, uint16_t type,
 	case NFT_EXPR_LIMIT_RATE:
 		*data_len = sizeof(uint64_t);
 		return &limit->rate;
-	case NFT_EXPR_LIMIT_DEPTH:
+	case NFT_EXPR_LIMIT_UNIT:
 		*data_len = sizeof(uint64_t);
-		return &limit->depth;
+		return &limit->unit;
 	}
 	return NULL;
 }
@@ -74,7 +74,7 @@ static int nft_rule_expr_limit_cb(const struct nlattr *attr, void *data)
 
 	switch(type) {
 	case NFTA_LIMIT_RATE:
-	case NFTA_LIMIT_DEPTH:
+	case NFTA_LIMIT_UNIT:
 		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0) {
 			perror("mnl_attr_validate");
 			return MNL_CB_ERROR;
@@ -93,8 +93,8 @@ nft_rule_expr_limit_build(struct nlmsghdr *nlh, struct nft_rule_expr *e)
 
 	if (e->flags & (1 << NFT_EXPR_LIMIT_RATE))
 		mnl_attr_put_u64(nlh, NFTA_LIMIT_RATE, htobe64(limit->rate));
-	if (e->flags & (1 << NFT_EXPR_LIMIT_DEPTH))
-		mnl_attr_put_u64(nlh, NFTA_LIMIT_DEPTH, htobe64(limit->depth));
+	if (e->flags & (1 << NFT_EXPR_LIMIT_UNIT))
+		mnl_attr_put_u64(nlh, NFTA_LIMIT_UNIT, htobe64(limit->unit));
 }
 
 static int
@@ -110,9 +110,9 @@ nft_rule_expr_limit_parse(struct nft_rule_expr *e, struct nlattr *attr)
 		limit->rate = be64toh(mnl_attr_get_u64(tb[NFTA_LIMIT_RATE]));
 		e->flags |= (1 << NFT_EXPR_LIMIT_RATE);
 	}
-	if (tb[NFTA_LIMIT_DEPTH]) {
-		limit->depth = be64toh(mnl_attr_get_u64(tb[NFTA_LIMIT_DEPTH]));
-		e->flags |= (1 << NFT_EXPR_LIMIT_DEPTH);
+	if (tb[NFTA_LIMIT_UNIT]) {
+		limit->unit = be64toh(mnl_attr_get_u64(tb[NFTA_LIMIT_UNIT]));
+		e->flags |= (1 << NFT_EXPR_LIMIT_UNIT);
 	}
 
 	return 0;
@@ -128,10 +128,10 @@ static int nft_rule_expr_limit_json_parse(struct nft_rule_expr *e, json_t *root)
 
 	nft_rule_expr_set_u64(e, NFT_EXPR_LIMIT_RATE, uval64);
 
-	if (nft_jansson_parse_val(root, "depth", NFT_TYPE_U64, &uval64) < 0)
+	if (nft_jansson_parse_val(root, "unit", NFT_TYPE_U64, &uval64) < 0)
 		return -1;
 
-	nft_rule_expr_set_u64(e, NFT_EXPR_LIMIT_DEPTH, uval64);
+	nft_rule_expr_set_u64(e, NFT_EXPR_LIMIT_UNIT, uval64);
 
 	return 0;
 #else
@@ -151,11 +151,11 @@ static int nft_rule_expr_limit_xml_parse(struct nft_rule_expr *e, mxml_node_t *t
 
 	e->flags |= (1 << NFT_EXPR_LIMIT_RATE);
 
-	if (nft_mxml_num_parse(tree, "depth", MXML_DESCEND_FIRST, BASE_DEC,
-			       &limit->depth, NFT_TYPE_U64, NFT_XML_MAND) != 0)
+	if (nft_mxml_num_parse(tree, "unit", MXML_DESCEND_FIRST, BASE_DEC,
+			       &limit->unit, NFT_TYPE_U64, NFT_XML_MAND) != 0)
 		return -1;
 
-	e->flags |= (1 << NFT_EXPR_LIMIT_DEPTH);
+	e->flags |= (1 << NFT_EXPR_LIMIT_UNIT);
 
 	return 0;
 #else
@@ -169,19 +169,26 @@ nft_rule_expr_limit_snprintf(char *buf, size_t len, uint32_t type,
 			    uint32_t flags, struct nft_rule_expr *e)
 {
 	struct nft_expr_limit *limit = nft_expr_data(e);
+	static const char *units[] = {
+		[1]			= "second",
+		[1 * 60]		= "minute",
+		[1 * 60 * 60]		= "hour",
+		[1 * 60 * 60 * 24]	= "day",
+		[1 * 60 * 60 * 24 * 7]	= "week",
+	};
 
 	switch(type) {
 	case NFT_RULE_O_DEFAULT:
-		return snprintf(buf, len, "rate %"PRIu64" depth %"PRIu64" ",
-				limit->rate, limit->depth);
+		return snprintf(buf, len, "rate %"PRIu64"/%s ",
+				limit->rate, units[limit->unit]);
 	case NFT_RULE_O_XML:
 		return snprintf(buf, len, "<rate>%"PRIu64"</rate>"
-					  "<depth>%"PRIu64"</depth>",
-				limit->rate, limit->depth);
+					  "<unit>%"PRIu64"</unit>",
+				limit->rate, limit->unit);
 	case NFT_RULE_O_JSON:
 		return snprintf(buf, len, "\"rate\" : %"PRIu64", "
-					  "\"depth\" : %"PRIu64" ",
-				limit->rate, limit->depth);
+					  "\"unit\" : %"PRIu64" ",
+				limit->rate, limit->unit);
 	default:
 		break;
 	}

--OwLcNYc0lM97+oe1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-nft-limit-nftables

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index a236cc3..31dd907 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -544,12 +544,12 @@ enum nft_ct_attributes {
  * enum nft_limit_attributes - nf_tables limit expression netlink attributes
  *
  * @NFTA_LIMIT_RATE: refill rate (NLA_U64)
- * @NFTA_LIMIT_DEPTH: bucket depth (NLA_U64)
+ * @NFTA_LIMIT_UNIT: refill unit (NLA_U64)
  */
 enum nft_limit_attributes {
 	NFTA_LIMIT_UNSPEC,
 	NFTA_LIMIT_RATE,
-	NFTA_LIMIT_DEPTH,
+	NFTA_LIMIT_UNIT,
 	__NFTA_LIMIT_MAX
 };
 #define NFTA_LIMIT_MAX		(__NFTA_LIMIT_MAX - 1)
diff --git a/include/statement.h b/include/statement.h
index 5370231..6ecbb18 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -41,7 +41,6 @@ extern struct stmt *log_stmt_alloc(const struct location *loc);
 struct limit_stmt {
 	uint64_t		rate;
 	uint64_t		unit;
-	uint64_t		depth;
 };
 
 extern struct stmt *limit_stmt_alloc(const struct location *loc);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index d80fc78..3bb143b 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -385,8 +385,8 @@ static void netlink_parse_limit(struct netlink_parse_ctx *ctx,
 	struct stmt *stmt;
 
 	stmt = limit_stmt_alloc(loc);
-	stmt->limit.rate  = nft_rule_expr_get_u32(nle, NFT_EXPR_LIMIT_RATE);
-	stmt->limit.depth  = nft_rule_expr_get_u32(nle, NFT_EXPR_LIMIT_DEPTH);
+	stmt->limit.rate  = nft_rule_expr_get_u64(nle, NFT_EXPR_LIMIT_RATE);
+	stmt->limit.unit  = nft_rule_expr_get_u64(nle, NFT_EXPR_LIMIT_UNIT);
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
 
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 72c59e5..fd91155 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -551,8 +551,8 @@ static void netlink_gen_limit_stmt(struct netlink_linearize_ctx *ctx,
 	struct nft_rule_expr *nle;
 
 	nle = alloc_nft_expr("limit");
-	nft_rule_expr_set_u32(nle, NFT_EXPR_LIMIT_RATE, stmt->limit.rate);
-	nft_rule_expr_set_u32(nle, NFT_EXPR_LIMIT_DEPTH, stmt->limit.depth);
+	nft_rule_expr_set_u64(nle, NFT_EXPR_LIMIT_RATE, stmt->limit.rate);
+	nft_rule_expr_set_u64(nle, NFT_EXPR_LIMIT_UNIT, stmt->limit.unit);
 	nft_rule_add_expr(ctx->nlr, nle);
 }
 
diff --git a/src/parser.y b/src/parser.y
index 074f075..cfe1e86 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -1003,14 +1003,11 @@ limit_stmt		:	LIMIT	RATE	NUM	SLASH	time_unit
 			}
 			;
 
-time_unit		:	NANOSECOND	{ $$ = 1ULL; }
-			|	MICROSECOND	{ $$ = 1ULL * 1000; }
-			|	MILLISECOND	{ $$ = 1ULL * 1000 * 1000; }
-			|	SECOND		{ $$ = 1ULL * 1000 * 1000 * 1000; }
-			|	MINUTE		{ $$ = 1ULL * 1000 * 1000 * 1000 * 60; }
-			|	HOUR		{ $$ = 1ULL * 1000 * 1000 * 1000 * 60 * 60; }
-			|	DAY		{ $$ = 1ULL * 1000 * 1000 * 1000 * 60 * 60 * 24; }
-			|	WEEK		{ $$ = 1ULL * 1000 * 1000 * 1000 * 60 * 60 * 24 * 7; }
+time_unit		:	SECOND		{ $$ = 1ULL; }
+			|	MINUTE		{ $$ = 1ULL * 60; }
+			|	HOUR		{ $$ = 1ULL * 60 * 60; }
+			|	DAY		{ $$ = 1ULL * 60 * 60 * 24; }
+			|	WEEK		{ $$ = 1ULL * 60 * 60 * 24 * 7; }
 			;
 
 reject_stmt		:	_REJECT
diff --git a/src/statement.c b/src/statement.c
index 69db48f..658dc5f 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -144,8 +144,16 @@ struct stmt *log_stmt_alloc(const struct location *loc)
 
 static void limit_stmt_print(const struct stmt *stmt)
 {
-	printf("limit rate %" PRIu64 " depth %" PRIu64,
-	       stmt->limit.rate, stmt->limit.depth);
+	static const char *units[] = {
+		[1]			= "second",
+		[1 * 60]		= "minute",
+		[1 * 60 * 60]		= "hour",
+		[1 * 60 * 60 * 24]	= "day",
+		[1 * 60 * 60 * 24 * 7]	= "week",
+	};
+
+	printf("limit rate %" PRIu64 "/%s",
+	       stmt->limit.rate, units[stmt->limit.unit]);
 }
 
 static const struct stmt_ops limit_stmt_ops = {

--OwLcNYc0lM97+oe1--
